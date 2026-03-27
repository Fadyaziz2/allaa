<?php

namespace App\Models\Core\File;

use Illuminate\Database\Eloquent\Model;

class File extends Model
{
    protected $fillable = ['path', 'type'];

    protected $casts = [
        'imageable_id' => 'integer'
    ];

    public function imageable(): \Illuminate\Database\Eloquent\Relations\MorphTo
    {
        return $this->morphTo();
    }

    public function getFullPathAttribute()
    {
        return url($this->path);
    }
}
