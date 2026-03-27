<?php

namespace App\Services\Invoice\Customization;

use App\Helpers\Core\Traits\FileHandler;
use App\Models\Invoice\Customization\Customization;
use App\Services\BaseService;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Collection;

class CustomizationService extends BaseService
{
    use FileHandler;

    public function __construct(Customization $model)
    {
        $this->model = $model;
    }

    public function index($type)
    {
        return $this->formatSettings($this->basicQuery($type)->get(['id', 'name', 'value']));
    }

    public function update($type)
    {
        $settings = request()->except('allowed_resource');

        return collect(array_keys($settings))->map(function ($key) use ($settings, $type) {

            $setting = $this->createSettingInstance($key, $type);
            if (request()->file($key)) {
                $this->deleteImage(optional($setting)->value);
                $settings[$key] = $this->uploadImage(request()
                    ->file($key), 'customization/'.$type);
            }

            $this->setModel($setting);

            return parent::save([
                'name' => $key,
                'value' => $settings[$key],
                'type' => $type
            ]);
        });
    }

    public function formatSettings(Collection $settings)
    {
        return $settings->reduce(function ($final, $setting) {
            $final[$setting->name] = $setting->value;
            return $final;
        }, []);
    }

    public function createSettingInstance(string $name, string $type)
    {
        return $this->basicQuery($type)
            ->where('name', $name)
            ->firstOrNew();
    }

    public function basicQuery($type = null)
    {
        return $this->model::query()->when($type, function (Builder $builder) use ($type) {
            $builder->whereIn('type', is_array($type) ? $type : [$type]);
        });
    }

}
