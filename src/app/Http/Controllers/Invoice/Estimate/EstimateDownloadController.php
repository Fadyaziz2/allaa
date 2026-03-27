<?php

namespace App\Http\Controllers\Invoice\Estimate;

use App\Http\Controllers\Controller;
use App\Models\Invoice\Estimate\Estimate;
use App\Models\Invoice\Invoice\Invoice;
use App\Services\Core\Setting\SettingService;
use App\Services\Invoice\Estimate\EstimateService;
use Barryvdh\DomPDF\Facade\Pdf;
use Illuminate\Support\Facades\Storage;

class EstimateDownloadController extends Controller
{

    public function download(Estimate $estimate)
    {
        $pdf = $this->generatePdf($estimate);

        if (request()->has('preview')) {
            return response()->make($pdf->stream(), 200, [
                'Content-Type' => 'application/pdf',
                'Content-Disposition' => 'inline; filename="' . $estimate->invoice_full_number . '.pdf"',
            ]);
        }

        if (request('isMobileDownload')) {
            // Ensure the directory exists
            Storage::makeDirectory('public/pdf/estimate');

            // Save the PDF into storage
            $fileName = "{$estimate->invoice_full_number}.pdf";
            $pdf->save(Storage::path("public/pdf/estimate/{$fileName}")); // Save the PDF to the storage folder

            // Provide the location of the saved PDF
            return success_response('Data fetched successfully', Storage::url("public/pdf/estimate/{$fileName}"));
        }


        return $pdf->download("{$estimate->invoice_full_number}.pdf");
    }

    public function thermalEstimatePreview(Estimate $estimate)
    {
        // Load relationships if not already eager-loaded
        $estimate->loadMissing([
            'estimateDetails',
            'estimateDetails.product',
            'customer',
            'customer.userProfile',
            'customer.billingAddress',
        ]);

        // Calculate dynamic height
        $baseHeight = 300;
        $itemCount = $estimate->estimateDetails->count();
        $itemHeight = 4 * $itemCount;
        $totalHeight = $baseHeight + $itemHeight;

        // Minimum height fallback
        if ($totalHeight < 450) {
            $totalHeight = 450;
        }
        $systemSettings = resolve(SettingService::class)->getFormattedSettings('app');

        // Load view
        $pdf = Pdf::loadView('pdf.estimate.thermal_estimate', [
            'estimate' => $estimate,
            'systemSettings' => $systemSettings
        ]);

        // Set custom thermal paper size (80mm wide = 226.77pt)
        $pdf->setPaper([0, 0, 226.77, $totalHeight], 'portrait');

        return $pdf->download("{$estimate->estimate_full_number}.pdf");
    }

    public function generatePdf(Estimate $estimate)
    {
        $estimateInfo = $estimate->load(['estimateDetails' => function ($query) {
            $query->with('product:id,name');
        }, 'taxes', 'customer:id,first_name,last_name,email', 'customer.userProfile']);

        return resolve(EstimateService::class)->getPdf($estimateInfo);
    }
}
