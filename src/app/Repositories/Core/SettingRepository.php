<?php

namespace App\Repositories\Core;

use App\Models\Core\Setting\Setting;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Collection;

class SettingRepository extends BaseRepository
{
    /**
     * SettingRepository constructor.
     * @param Setting $setting
     * @khokon ahmed
     */
    public function __construct(Setting $setting)
    {
        $this->model = $setting;
    }

    public function getFormattedSettings($context = 'app')
    {
        return $this->formatSettings($this->basicQuery($context)->get(['id', 'name', 'value']));
    }

    public function findAppSettingWithName(string $name, string $context = 'app')
    {
        return $this->basicQuery($context, null, null)
            ->where('name', $name)
            ->first();
    }

    public function createSettingInstance(string $name, string $context)
    {
        return $this->basicQuery($context)
            ->where('name', $name)
            ->firstOrNew();
    }

    public function formatSettings(Collection $settings)
    {
        return $settings->reduce(function ($final, $setting) {
            $final[$setting->name] = $setting->value;
            return $final;
        }, []);
    }

    public function getDeliverySettingLists($context = null)
    {
        return $this->formatSettings(
            $this->basicQuery($context)
                ->get(['id', 'name', 'value'])
        );

    }


    public function basicQuery($context = null)
    {
        return $this->model::query()->when($context, function (Builder $builder) use ($context) {
            $builder->whereIn('context', is_array($context) ? $context : [$context]);
        });
    }

    public function settings($context)
    {
        $context = is_array($context) ? $context : func_get_args();
        return $this->model::query()
            ->whereIn('context', $context)
            ->get();
    }

    public function getDefaultMailKey($key = 'default_mail')
    {
        return $this->model::query()
            ->select(['id', 'name', 'value', 'context'])
            ->where('name', $key)
            ->first();
    }

    public function getDefaultSmsKey($key = 'default_sms')
    {
        return $this->model::query()
            ->select(['id', 'name', 'value', 'context'])
            ->where('name', $key)
            ->first();
    }
}
