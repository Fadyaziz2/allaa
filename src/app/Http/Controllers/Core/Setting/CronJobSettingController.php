<?php

namespace App\Http\Controllers\Core\Setting;

use App\Http\Controllers\Controller;

class CronJobSettingController extends Controller
{
    public function index(): array
    {
        $cpanelCommand = exec("which php") . ' ' . base_path() . '/artisan schedule:run >> /dev/null 2>&1';
        return [
            'cron_job_command' => $cpanelCommand,
        ];
    }

    public function cronjobSymlink(): string
    {
        $value = $this->laravel['config']['filesystems.links'] ??
            [public_path('storage') => storage_path('app/public')];
        $link = array_key_first($value);
        $target = array_values($value)[0];
        return 'ln -s ' . $target . ' ' . $link;
    }
}
