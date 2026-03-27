<?php

namespace App\Models\Core\Status;

use App\Models\Core\Traits\TranslatedNameTrait;
use Illuminate\Database\Eloquent\Model;

class Status extends Model
{
   use TranslatedNameTrait;

    public $timestamps = false;

    protected $fillable = [
        'name', 'type', 'class',
    ];

    protected $appends = ['translated_name'];

    public static function findByNameAndType($name, $type = 'user'): object
    {
        return self::query()
            ->where('name', $name)
            ->where('type', $type)
            ->first();
    }
}
