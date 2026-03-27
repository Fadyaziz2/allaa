<?php

namespace App\Services\Invoice\Dashboard;

use App\Filters\Invoice\Invoice\InvoiceFilter;
use App\Helpers\Core\Traits\DateRangeHelper;
use App\Models\Core\Status\Status;
use App\Models\Invoice\Expense\Expense;
use App\Models\Invoice\Invoice\Invoice;
use App\Models\Invoice\Product\Product;
use App\Models\User;
use App\Services\BaseService;
use Carbon\CarbonPeriod;
use Illuminate\Database\Query\Builder as QBuilder;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;

class DashboardService extends BaseService
{
    use DateRangeHelper;

    public \Illuminate\Support\Collection $status;

    public function __construct()
    {
        $this->status = $this->getStatus();
    }

    public function totalCustomer(): int
    {
        return User::query()->whereHas('roles', fn($query) => $query->where('alias', 'customer'))->count();
    }

    public function totalProduct(): int
    {
        return Product::query()->count();
    }

    public function invoiceCount($status = null): int
    {
        return Invoice::query()
            ->filter(new InvoiceFilter())
            ->when($status, fn($query) => $query->where('status_id', $status))
            ->count();
    }

    public function invoiceAmount($column)
    {
        return Invoice::query()->filter(new InvoiceFilter())->sum($column);
    }


    public function manipulateIncomeOverviewChart($range_type): object|array
    {
        $dateRange = $this->dateRange($range_type);
        $range = $dateRange->range;
        $invoices = DB::table('invoices')
            ->when($range, function (QBuilder $query) use ($range) {
                $query->whereBetween('issue_date', $range);
            })->get();

        $sumGroups = $invoices->groupBy(function ($row) use ($dateRange) {
            return \Carbon\Carbon::parse($row->issue_date)->format($dateRange->context);
        })->map(function ($rows) use ($dateRange) {
            return $dateRange->range ? $rows->sum('received_amount') : $this->keyValueReceivedAmountSum($rows);
        });


        return $dateRange->range
            ? $this->fillPeriods('income', $sumGroups, $dateRange)
            : $sumGroups;
    }


    public function keyValueReceivedAmountSum($row): array
    {
        return ['income' => $row->sum('received_amount')];
    }

    public function paymentOverView(): Collection
    {
        return DB::table('invoices')
            ->select(
                DB::raw('SUM(received_amount) as received_amount'),
                DB::raw('SUM(due_amount) as due_amount')
            )->get();
    }

    public function manipulateExpenseOverviewChart($range_type): object|array
    {
        $dateRange = $this->dateRange($range_type);
        $range = $dateRange->range;
        $invoices = DB::table('expenses')
            ->when($range, function (QBuilder $query) use ($range) {
                $query->whereBetween('date', $range);
            })->get();

        $sumGroups = $invoices->groupBy(function ($row) use ($dateRange) {
            return \Carbon\Carbon::parse($row->date)->format($dateRange->context);
        })->map(function ($rows) use ($dateRange) {
            return $dateRange->range ? $rows->sum('amount') : ['expense' => $rows->sum('amount')];
        });

        return $dateRange->range
            ? $this->fillPeriods('expense', $sumGroups, $dateRange)
            : $sumGroups;
    }

    private function fillPeriods($keys, $sumGroups, $dateRange): array
    {
        $period = CarbonPeriod::create(...$dateRange->range);

        $data = [];

        foreach ($period->toArray() as $date) {

            $format = $date->format($dateRange->context);

            $data[app_date_format($format)] = [
                $keys => $sumGroups[$format] ?? 0,
                'context' => $format,
                'date' => $date->format('Y-m-d')
            ];
        }
        return $data;
    }

    public function incomeExpenseLabel($range_type): array
    {
        $dateRange = $this->dateRange($range_type);

        $period = CarbonPeriod::create(...$dateRange->range);

        $data = [];
        foreach ($period->toArray() as $date) {
            $format = $date->format($dateRange->context);
            $data[$format] = app_date_format($format);
        }

        return $data;

    }


    public function income()
    {
        return Invoice::query()->sum('received_amount');
    }

    public function expense()
    {
        return Expense::query()->sum('amount');
    }

    public function getStatus(): \Illuminate\Support\Collection
    {
        return Status::query()
            ->where('type', 'invoice')
            ->pluck('id', 'name');
    }


}
