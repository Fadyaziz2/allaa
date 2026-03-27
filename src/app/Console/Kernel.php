<?php

namespace App\Console;

use App\Console\Commands\Invoice\RecurringInvoiceCommand;
use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Console\Kernel as ConsoleKernel;

class Kernel extends ConsoleKernel
{
    protected $commands = [
        RecurringInvoiceCommand::class
    ];

    /**
     * Define the application's command schedule.
     */
    protected function schedule(Schedule $schedule): void
    {
        $schedule->command('queue:work --queue=high,default,high-priority --tries=2 --stop-when-empty')
            ->everyMinute()
            ->withoutOverlapping();

        $schedule->command('recurring:invoice')
            ->everyMinute();
    }

    /**
     * Register the commands for the application.
     */
    protected function commands(): void
    {
        $this->load(__DIR__ . '/Commands');

        require base_path('routes/console.php');
    }
}
