<?php

namespace App\Http\Controllers\Mobile\Api\Estimate;

use App\Exceptions\GeneralException;
use App\Http\Controllers\Controller;
use App\Models\Invoice\Estimate\Estimate;
use App\Models\Invoice\Invoice\Invoice;
use App\Models\Invoice\Invoice\InvoiceDetail;
use App\Models\Invoice\Invoice\InvoiceTax;
use App\Repositories\Core\StatusRepository;
use App\Services\Invoice\Customization\CustomizationService;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;

class EstimateToInvoiceConvertController extends Controller
{
    public function invoiceConvert(Estimate $estimate)
    {
        try {
            DB::beginTransaction();
            $invoiceNumber = Invoice::query()->max('invoice_number');
            $invoiceSetting = resolve(CustomizationService::class)->index('invoice');

            $newInvoice = new Invoice();
            $newInvoice->customer_id = $estimate->customer_id;
            $newInvoice->issue_date = $estimate->date;
            $newInvoice->due_date = $estimate->date;
            $newInvoice->invoice_number = $invoiceNumber + 1;
            $newInvoice->invoice_full_number = $invoiceSetting['invoice_prefix'] . ($invoiceSetting['invoice_serial_start'] + $invoiceNumber + 1);
            $newInvoice->recurring = 0;
            $newInvoice->status_id = resolve(StatusRepository::class)->invoiceDue();
            $newInvoice->sub_total = $estimate->sub_total;
            $newInvoice->discount_type = $estimate->discount_type;
            $newInvoice->discount_amount = $estimate->discount_amount;
            $newInvoice->total_amount = $estimate->total_amount;
            $newInvoice->grand_total = $estimate->grand_total;
            $newInvoice->received_amount = 0;
            $newInvoice->due_amount = $estimate->grand_total;
            $newInvoice->note = $estimate->note;
            $newInvoice->invoice_template = $estimate->estimate_template;
            $newInvoice->created_by = auth()->id();
            $newInvoice->created_at = Carbon::now();
            $newInvoice->save();

            $estimateRelation = $estimate->load(['estimateDetails', 'taxes']);
            $invoiceDetails = [];
            foreach ($estimateRelation->estimateDetails as $item) {

                $invoiceDetails[] = [
                    'quantity' => $item->quantity,
                    'price' => $item->price,
                    'invoice_id' => $newInvoice->id,
                    'product_id' => $item->product_id,
                    'created_at' => now(),
                    'updated_at' => now()
                ];
            }

            $invoiceTaxes = [];

            foreach ($estimateRelation->taxes as $item) {
                $invoiceTaxes[] = [
                    'tax_id' => $item->tax_id,
                    'invoice_id' => $newInvoice->id,
                    'total_amount' => $item->total_amount,
                    'created_at' => now(),
                    'updated_at' => now()
                ];
            }
            InvoiceDetail::query()->insert($invoiceDetails);

            InvoiceTax::query()->insert($invoiceTaxes);

            DB::commit();
            return success_response(trans('default.estimate_to_invoice_convert_has_been_successfully'));

        } catch (\Exception $exception) {
            if (app()->environment('production')) {
                return error_response(trans('default.estimate_to_invoice_convert_has_been_field'), 500);
            }
            return error_response($exception->getMessage(), 500);
        }

    }
}
