<?php

namespace App\Models\Core\Traits;

trait TranslatedNameTrait
{
    public function getTranslatedNameAttribute(): \Illuminate\Foundation\Application|array|string|\Illuminate\Contracts\Translation\Translator|\Illuminate\Contracts\Foundation\Application|null
    {
        return __("default.{$this->attributes['name']}");
    }
}
