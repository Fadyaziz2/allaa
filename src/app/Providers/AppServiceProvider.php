<?php

namespace App\Providers;

use App\Helpers\Core\Settings\SetEmailConfig;
use App\Services\Core\Setting\SettingService;
use Exception;
use Illuminate\Support\Facades\View;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        $this->app->bind(\Illuminate\Foundation\Vite::class, \App\Vendor\CustomVite::class);
    }

    /**
     * Bootstrap any application services.
     */
    public function boot()
    {
        try {
            $settings = resolve(SettingService::class)->getFormattedSettings('app');
            View::composer('*', function ($view) use ($settings) {
                $view->with('settings', $settings);
            });

            foreach ($settings as $key => $setting) {
                if ($key == 'company_name') {
                    config()->set('app.name', $setting);
                }
                config()->set('settings.application.' . $key, $setting);
            }
        } catch (\Exception $exception) {
            return $exception->getMessage();
        }


        // Mail Setting Config

        try {
            SetEmailConfig::new(true)
                ->clear()
                ->set();
        } catch (Exception $exception) {
            return $exception->getMessage();
        }
    }
}
