<?php

namespace App\Jobs\Invoice\Estimate;

use App\Mail\Invoice\Estimate\EstimateAttachmentMail;
use App\Models\Invoice\Estimate\Estimate;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldBeUnique;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Storage;

class EstimateAttachmentJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    /**
     * Create a new job instance.
     */
    public function __construct(public Estimate $estimate)
    {
        //
    }

    /**
     * Execute the job.
     */
    public function handle(): void
    {
        Mail::to(optional($this->estimate->customer)->email)
            ->send(
                (new EstimateAttachmentMail($this->estimate)));

        Storage::delete('public/pdf/estimate_' . $this->estimate->invoice_full_number . '.pdf');
    }
}
