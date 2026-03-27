<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;

class SymlinkStorageCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:symlink-storage';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Create a symbolic link from "public/storage" to "storage/app/public"';

    /**
     * Execute the console command.
     */
    public function handle(): void
    {
        try {
            $target = storage_path("app/public");
            $explode_base_path = explode(DIRECTORY_SEPARATOR, base_path());
            array_pop($explode_base_path);
            $explode_base_path[] = 'storage';
            $path = implode(DIRECTORY_SEPARATOR, $explode_base_path);

            if (!is_dir($path)) {
                symlink($target, $path);
                $this->info('The [public/storage] directory has been linked.');
            } else {
                $this->warn('The [public/storage] directory already exists.');
            }
        } catch (\Exception $e) {
            $this->error('Permission denied.');
        }

    }
}
