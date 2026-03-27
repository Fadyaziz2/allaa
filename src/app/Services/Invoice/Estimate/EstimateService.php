<?php

namespace App\Services\Invoice\Estimate;

use App\Jobs\Invoice\Estimate\EstimateAttachmentJob;
use App\Models\Invoice\Estimate\Estimate;
use App\Models\Invoice\Estimate\EstimateDetail;
use App\Services\Invoice\AppService;
use App\Services\Invoice\Customization\CustomizationService;
use App\Services\Invoice\Traits\TaxTrait;
use App\Services\Traits\HasWhen;
use Barryvdh\DomPDF\Facade\Pdf;
use Illuminate\Support\Facades\Storage;

class EstimateService extends AppService
{
    use HasWhen, TaxTrait;

    public function __construct(Estimate $estimate)
    {
        $this->model = $estimate;
    }

    public function estimateDetails(): static
    {
        foreach (request()->get('products') as $product) {

            if (isset($product['id'])) {
                EstimateDetail::query()
                    ->where('id', $product['id'])
                    ->update([
                        'quantity' => $product['quantity'],
                        'price' => $product['price'],
                        'product_id' => $product['product_id'],
                    ]);
            } else {
                EstimateDetail::query()->create([
                    'quantity' => $product['quantity'],
                    'price' => $product['price'],
                    'estimate_id' => $this->model->id,
                    'product_id' => $product['product_id'],
                ]);
            }
        }
        return $this;
    }

    public function estimateTax(): static
    {
        return $this->taxes();
    }

    public function removeEstimateProduct($estimate): static
    {
        if (count(request()->get('remove_product'))) {
            $estimate->estimateDetails()->whereIn('id', request()->get('remove_product'))->delete();
        }
        return $this;
    }

    public function removeEstimateTax($estimate): static
    {
        if (count(request()->get('remove_tax'))) {
            $estimate->taxes()->whereIn('id', request()->get('remove_tax'))->delete();
        }
        return $this;
    }

    public function deleteEstimateDetails(): static
    {
        $this->model->estimateDetails()->delete();
        return $this;
    }

    public function deleteEstimateTax(): static
    {
        $this->model->taxes()->delete();
        return $this;
    }

    public function estimateInfo(): Estimate
    {
        return $this->model->load(['estimateDetails' => function ($query) {
            $query->with('product:id,name');
        }, 'taxes', 'customer:id,first_name,last_name,email', 'customer.userProfile']);
    }

    public function pdfGenerate($estimateInfo): static
    {
        $pdf = $this->getPdf($estimateInfo);

        $output = $pdf->output();
        $filePath = $this->getAttribute('file_path');
        Storage::put($filePath, $output);
        return $this;
    }

    public function sendEstimateAttachment($estimate): static
    {
        EstimateAttachmentJob::dispatch($estimate)->onQueue('high');
        return $this;
    }

    public function getPdf($estimateInfo): \Barryvdh\DomPDF\PDF
    {
        $invoiceSetting = resolve(CustomizationService::class)->index('estimate');
        $invoiceLogo = config('app.url') . $invoiceSetting['estimate_logo'];

        if ($estimateInfo->estimate_template == 2) {
            $pdf = PDF::loadView('pdf.estimate.estimate_two', [
                'estimate' => $estimateInfo,
                'estimate_logo' => $invoiceLogo
            ]);
        } elseif ($estimateInfo->estimate_template == 3) {
            $pdf = PDF::loadView('pdf.estimate.estimate_three', [
                'estimate' => $estimateInfo,
                'estimate_logo' => $invoiceLogo
            ]);

        } else {
            $pdf = PDF::loadView('pdf.estimate.estimate', [
                'estimate' => $estimateInfo,
                'estimate_logo' => $invoiceLogo
            ]);
        }
        return $pdf;
    }


}
