<?php

namespace App\Services\Mobile\Dashboard;

use App\Filters\Invoice\Invoice\InvoiceFilter;
use App\Helpers\Core\Traits\DateRangeHelper;
use App\Helpers\Core\Traits\MobileDateRangeHelper;
use App\Models\Core\Status\Status;
use App\Models\Invoice\Invoice\Invoice;
use App\Models\Invoice\Product\Product;
use App\Models\User;
use App\Services\BaseService;
use Carbon\CarbonPeriod;
use Illuminate\Database\Query\Builder as QBuilder;
use Illuminate\Support\Carbon;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;

class DashboardService extends BaseService
{
    use MobileDateRangeHelper;

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
        return Invoice::query()
            ->filter(new InvoiceFilter())
            ->sum($column);
    }

    public function manipulateIncomeOverviewChart($range_type): array
    {

        $dateRange = $this->dateRange($range_type);

        $range = $dateRange->range;
        $invoices = DB::table('invoices')
            ->when($range, fn(QBuilder $query) => $query->whereBetween('issue_date', $range))
            ->get();

        $sumGroups = $invoices->groupBy(function ($row) use ($dateRange) {
            return \Carbon\Carbon::parse($row->issue_date)->format($dateRange->context);
        })->map(function ($rows) use ($dateRange) {
            return $dateRange->range ? $rows->sum('received_amount') : ['income' => floatval($rows->sum('received_amount'))];
        });


        return $dateRange->range
            ? $this->fillPeriods($sumGroups, $dateRange)
            : $this->formatNonRangeData($sumGroups);

    }

    public function paymentOverView(): array
    {
        $receivedAmount = DB::table('invoices')
            ->sum('received_amount');

        $dueAmount = DB::table('invoices')->sum('due_amount');

        return [
            [
                'name' => 'Received Amount',
                'amount' => floatval($receivedAmount),
                'currency_with_amount' => number_with_currency_symbol($receivedAmount)
            ],
            [
                'name' => 'Due Amount',
                'amount' => floatval($dueAmount),
                'currency_with_amount' => number_with_currency_symbol($dueAmount)
            ]
        ];
    }

    private function fillPeriods($sumGroups, $dateRange): array
    {
        $period = CarbonPeriod::create(...$dateRange->range);
        $data = [];

        foreach ($period as $date) {
            $format = $date->format($dateRange->context);
            $data[] = [
                'income' => $sumGroups[$format] ?? 0,
                'context' => $format,
                'date' => $date->format('Y-m-d')
            ];
        }

        return $data;
    }

    private function formatNonRangeData($sumGroups): array
    {
        $data = [];

        foreach ($sumGroups as $context => $values) {
            $stringConvert = strval($context);
            $data[] = [
                'income' => $values['income'] ?? 0,
                'context' => $stringConvert,
                'date' => $stringConvert
            ];
        }

        return $data;
    }

    public function getStatus(): \Illuminate\Support\Collection
    {
        return Status::query()
            ->where('type', 'invoice')
            ->pluck('id', 'name');
    }
}
