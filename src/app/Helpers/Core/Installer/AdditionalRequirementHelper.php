<?php

namespace App\Helpers\Core\Installer;

use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\File;

class AdditionalRequirementHelper
{
    public function index(): ?array
    {
        return $this->link();
    }

    public function link(): ?array
    {
        $baseDir = basename(base_path());
        $storagePath = public_path('storage');

        if ($baseDir === 'src') {
            return $this->handle();
        }

        if (!file_exists($storagePath)) {
            Artisan::call('storage:link');
            return $this->response(true, trans('default.symlink_working'));
        }

        return $this->response(true, 'Symlink created successfully');
    }

    public function handle()
    {
        foreach ($this->links() as $link => $target) {
            if (str_contains($link, 'src/public/')) {
                $link = str_replace('src/public/', '', $link);

                if (!file_exists($link)) {
                    return $this->createSymlink($target, $link);
                }

                return $this->response(true, 'Symlink created successfully');
            }
        }
    }

    protected function links()
    {
        return config('filesystems.links', [public_path('storage') => storage_path('app/public')]);
    }

    private function createSymlink($target, $link): array
    {
        try {
            File::link($target, $link);
            return $this->response(true, 'Symlink created successfully');
        } catch (\Exception $e) {
            return $this->response(false, $e->getMessage(), [
                'symlink' => [
                    'target_link' => $target,
                    'storage_link' => $link,
                ]
            ]);
        }
    }

    private function response($status, $message, $optional = null): array
    {
        return [
            'status' => $status,
            'message' => $message,
            'optional' => $optional,
        ];
    }
}
