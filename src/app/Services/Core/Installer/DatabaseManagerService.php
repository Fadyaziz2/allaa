<?php

namespace App\Services\Core\Installer;

use App\Exceptions\GeneralException;
use App\Helpers\Core\Installer\DatabaseManagerHelper;
use App\Models\User;
use App\Services\BaseService;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Log;
use Psr\Container\ContainerExceptionInterface;
use Psr\Container\NotFoundExceptionInterface;

class DatabaseManagerService extends BaseService
{
    protected DatabaseManagerHelper $databaseManager;

    public function __construct(DatabaseManagerHelper $databaseManager)
    {
        $this->databaseManager = $databaseManager;

    }

    public function clearCaches(): self
    {
        Artisan::call('config:clear');
        Artisan::call('route:clear');
        Artisan::call('view:clear');

        return $this;
    }


    /**
     * @throws ContainerExceptionInterface
     * @throws NotFoundExceptionInterface
     * @throws GeneralException
     */
    public function setDatabaseConnection(): self
    {
        $this->databaseManager->setDatabaseConfig();

        return $this;
    }

    public function saveFileWizard(): self
    {
        $this->databaseManager->saveFileWizard(request());

        return $this;
    }

    public function sessionDestroy(): DatabaseManagerService
    {
        session()->flush();
        return $this;
    }

    public function setMigration(): self
    {
        $this->databaseManager->migration();

        return $this;
    }

    public function setDatabaseSeeder(): self
    {
        $this->databaseManager->seed();

        return $this;
    }

    public function storageLink(): self
    {
        try {

            $explode_base_path = explode(DIRECTORY_SEPARATOR, base_path());
            array_pop($explode_base_path);
            $explode_base_path[] = 'storage';
            $link = implode(DIRECTORY_SEPARATOR, $explode_base_path);

            // Check and remove existing link or directory
            if (is_link($link) || is_dir($link)) {
                if (is_link($link)) {
                    unlink($link); // Remove the symlink
                } elseif (is_dir($link)) {
                    // Recursively remove directory if it exists
                    $this->deleteDirectory($link);
                }
                // Create the new symlink
                $target = storage_path("app/public");
                symlink($target, $link);
            }

        } catch (\Exception $e) {
            Log::error('Failed to create symbolic link: ' . $e->getMessage());
        }
        return $this;
    }

    public function updateUser(): static
    {
        $user = User::query()->first();
        $user->update([
            'first_name' => request()->get('first_name'),
            'last_name' => request()->get('last_name'),
            'email' => request()->get('email'),
            'password' => request()->get('password'),
        ]);

        return $this;

    }

    public function setEnvironmentValue(): DatabaseManagerService
    {
        $this->databaseManager->setEnvironmentValue('APP_INSTALLED', 'true');

        return $this;
    }

    public function setEnvironmentAppDebugValue(): static
    {
        $this->databaseManager->setEnvironmentValueSet('APP_DEBUG', 'false');

        return $this;
    }

    protected function deleteDirectory($dir): bool
    {
        if (!file_exists($dir)) {
            return false;
        }

        if (!is_dir($dir)) {
            return unlink($dir);
        }

        foreach (scandir($dir) as $item) {
            if ($item == '.' || $item == '..') {
                continue;
            }

            $this->deleteDirectory($dir . DIRECTORY_SEPARATOR . $item);
        }

        return rmdir($dir);
    }

}
