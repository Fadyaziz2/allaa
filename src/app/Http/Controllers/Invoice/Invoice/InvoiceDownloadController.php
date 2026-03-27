<?php

namespace App\Http\Controllers\Invoice\Invoice;

use App\Services\Core\Setting\SettingService;
use Illuminate\Http\Request;
use Barryvdh\DomPDF\Facade\Pdf;
use App\Http\Controllers\Controller;
use App\Models\Invoice\Invoice\Invoice;
use Illuminate\Support\Facades\Storage;
use App\Services\Invoice\Invoice\InvoiceService;
use App\Services\Invoice\Customization\CustomizationService;
use Stripe\Service\Tax\SettingsService;

class InvoiceDownloadController extends Controller
{
    public function download(Invoice $invoice)
    {
        $pdf = $this->generatePdf($invoice);

        if (request()->has('preview')) {
            return response()->make($pdf->stream(), 200, [
                'Content-Type' => 'application/pdf',
                'Content-Disposition' => 'inline; filename="' . $invoice->invoice_full_number . '.pdf"',
            ]);
        }

        if (request('isMobileDownload')) {
            // Ensure the directory exists
            Storage::makeDirectory('public/pdf/invoice');

            // Save the PDF into storage
            $fileName = "{$invoice->invoice_full_number}.pdf";
            $pdf->save(Storage::path("public/pdf/invoice/{$fileName}")); // Save the PDF to the storage folder

            // Provide the location of the saved PDF
            return success_response('Data fetched successfully', Storage::url("public/pdf/invoice/{$fileName}"));
        }

        return $pdf->download("{$invoice->invoice_full_number}.pdf");
    }

    public function thermalInvoicePreview(Invoice $invoice)
    {
        // Load relationships if not already eager-loaded
        $invoice->loadMissing([
            'invoiceDetails',
            'invoiceDetails.product',
            'customer',
            'customer.userProfile',
            'customer.billingAddress',
        ]);

        // Calculate dynamic height
        $baseHeight = 300;
        $itemCount = $invoice->invoiceDetails->count();
        $itemHeight = 4 * $itemCount;
        $totalHeight = $baseHeight + $itemHeight;

        // Minimum height fallback
        if ($totalHeight < 450) {
            $totalHeight = 450;
        }
        $systemSettings = resolve(SettingService::class)->getFormattedSettings('app');

        // Load view
        $pdf = Pdf::loadView('pdf.invoice.thermal_invoice', [
            'invoice' => $invoice,
            'systemSettings' => $systemSettings
        ]);

        // Set custom thermal paper size (80mm wide = 226.77pt)
        $pdf->setPaper([0, 0, 226.77, $totalHeight], 'portrait');

        return $pdf->download("{$invoice->invoice_full_number}.pdf");
    }


    public function generatePdf(Invoice $invoice)
    {
        $invoiceInfo = $invoice->load(['invoiceDetails' => function ($query) {
            $query->with('product:id,name');
        }, 'taxes', 'customer:id,first_name,last_name,email', 'customer.userProfile', 'customer.billingAddress']);

        return resolve(InvoiceService::class)->getPdf($invoiceInfo);
    }
}
