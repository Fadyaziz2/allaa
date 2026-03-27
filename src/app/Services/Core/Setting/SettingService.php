<?php

namespace App\Services\Core\Setting;

use App\Helpers\Core\Traits\FileHandler;
use App\Repositories\Core\SettingRepository;
use App\Services\BaseService;

class SettingService extends BaseService
{
    use FileHandler;

    public function update()
    {
        $settings = request()->except('allowed_resource', 'permissions');

        return collect(array_keys($settings))->map(function ($key) use ($settings) {

            $setting = resolve(SettingRepository::class)
                ->createSettingInstance($key, 'app');

            if (request()->file($key)) {
                $this->deleteImage(optional($setting)->value);
                $settings[$key] = $this->uploadImage(request()
                    ->file($key), config('file.' . $key . '.folder'), config('file.' . $key . '.height'));
            }

            $this->setModel($setting);

            if ($locale = request()->get('language')) {
                session()->put('locale', $locale);
            }

            return parent::save([
                'name' => $key,
                'value' => $settings[$key],
                'context' => 'app'
            ]);
        });

    }

    public function getFormattedSettings($context = 'app')
    {
        return resolve(SettingRepository::class)
            ->getFormattedSettings($context);
    }

    public function getCachedFormattedSettings()
    {
        return resolve(SettingRepository::class)
            ->getFormattedSettings('app');
    }

    public function setDefaultSettings($key, $value, $context = 'mail', $settingable_type = null, $settingable_id = null)
    {
        $setting = resolve(SettingRepository::class)
            ->createSettingInstance($key, $context, $settingable_type, $settingable_id);

        $setting->fill([
            'name' => $key,
            'value' => $value,
            'context' => $context,
            'settingable_type' => $settingable_type,
            'settingable_id' => $settingable_id
        ]);

        return $setting->save();
    }


}
