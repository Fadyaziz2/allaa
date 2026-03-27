<?php

namespace App\Http\Controllers;

use Exception;
use Illuminate\Support\Facades\File;

class InstallDemoController extends Controller
{
    public function demoData(): array
    {
        \Illuminate\Support\Facades\Artisan::call('optimize:clear');
        if (app()->isLocal() && env('INSTALL_DEMO_DATA')) {
            try {
                \Illuminate\Support\Facades\Artisan::call('migrate:fresh --seed');

                resolve(\App\Services\Core\Installer\DatabaseManagerService::class)->storageLink();

                return [
                    'status' => true,
                    'message' => "seed data import successfully"
                ];
            } catch (Exception $exception) {

                return [
                    'status' => false,
                    'message' => $exception->getMessage()
                ];
            }
        }

        return [
            'status' => false,
            'message' => "seed data import failed"
        ];
    }

    public function cashClear(): array
    {
        $path = str_replace('/src', '', base_path());
        $fullPath = "$path/build/manifest.json";

        if (file_exists($fullPath)) {
            unlink($fullPath);
        }

        $directoryPath = public_path('updates/');
        // Check if the directory exists
        if (File::exists($directoryPath)) {
            // Delete the directory and its contents
            File::deleteDirectory($directoryPath);
        }

        \Illuminate\Support\Facades\Artisan::call('cache:clear');
        \Illuminate\Support\Facades\Artisan::call('optimize:clear');
        return [
            'status' => true,
            'message' => "Cash clear has been successfully"
        ];
    }
}
