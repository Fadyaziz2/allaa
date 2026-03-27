<?php

namespace App\Console\Commands\Invoice;

use App\Jobs\Invoice\Invoice\InvoiceRecurringJob;
use App\Models\Invoice\Invoice\Invoice;
use App\Repositories\Core\StatusRepository;
use Illuminate\Console\Command;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;

class RecurringInvoiceCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'recurring:invoice';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Due Invoice generate';

    /**
     * Execute the console command.
     */
    public function handle(): void
    {
        Invoice::query()
            ->with(['recurringType:id,name'])
            ->where('issue_date', '<=', date('Y-m-d'))
            ->where('recurring', 1)
            ->get()->each(function ($item) {
                if ($item->recurringType) {
                    $this->checkRecurringType($item);

                }
            });
    }

    private function checkRecurringType($item): void
    {
        $invoiceRecurring = $this->invoiceRecurringQuery($item);
        if ($item->recurringType->name == 'every_week') {
            $recurringDate = $invoiceRecurring ? Carbon::createFromDate($invoiceRecurring->recurring_date)->addWeek()
                : Carbon::createFromDate($item->issue_date)->addWeek();

            $checkWeek = $item->recurrings()->whereDate('recurring_date', Carbon::create($recurringDate)->format('Y-m-d'))->first();
            if (!$checkWeek) {
                $this->store($item, $recurringDate);
            }

        } else if ($item->recurringType->name == 'monthly') {

            $recurringDate = $invoiceRecurring ? Carbon::createFromDate($invoiceRecurring->recurring_date)->addMonth()
                : Carbon::createFromDate($item->issue_date)->addMonth();

            $this->store($item, $recurringDate);

        } else if ($item->recurringType->name == 'yearly') {

            $recurringDate = $invoiceRecurring ? Carbon::createFromDate($invoiceRecurring->recurring_date)->addYear()
                : Carbon::createFromDate($item->issue_date)->addYear();

            $this->store($item, $recurringDate);

        }

    }

    private function invoiceRecurringQuery($item)
    {
        $recurringInvoice = $item->recurrings()
            ->whereYear('recurring_date', Carbon::now()->year)
            ->whereMonth('recurring_date', Carbon::now()->month)
            ->orderBy('recurring_date', 'desc')
            ->first();
        if (!$recurringInvoice) {
            return $item->recurrings()
                ->orderBy('recurring_date', 'desc')
                ->first();
        }
        return $recurringInvoice;
    }

    protected function store($item, $recurringDate)
    {
        $recurringDateFormat = Carbon::parse($recurringDate)->format('Y-m-d');

        if (Carbon::today()->format('Y-m-d') > $recurringDateFormat) {

            DB::transaction(function () use ($item, $recurringDateFormat) {

                $date = Carbon::createFromFormat('Y-m-d', $recurringDateFormat);

                $create = $item->create(array_merge($item->toArray(), [
                        'invoice_number' => $item->max('invoice_number') + 1,
                        'invoice_full_number' => $item->invoice_full_number . '-re-' . ($item->max('invoice_number') + 1),
                        'recurring' => 3,
                        'issue_date' => $date,
                        'due_date' => Carbon::createFromFormat('Y-m-d', $recurringDateFormat)->addDays(7),
                        'status_id' => resolve(StatusRepository::class)->invoiceDue(),
                        'sub_total' => $item->sub_total,
                        'total_amount' => $item->total_amount,
                        'grand_total' => $item->grand_total,
                        'received_amount' => 0,
                        'due_amount' => $item->grand_total
                    ])
                );

                $create->invoiceDetails()->createMany($item->invoiceDetails->toArray());
                $create->taxes()->createMany($item->taxes->toArray());

                $item->recurrings()->create([
                    'invoice_id' => $create->id,
                    'recurring_date' => $date
                ]);
                InvoiceRecurringJob::dispatch($create)->onQueue('high');
            });

        }
    }
}
