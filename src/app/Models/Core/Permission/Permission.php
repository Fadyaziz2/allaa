<?php

namespace App\Models\Core\Permission;

use App\Models\Core\BaseModel;
use App\Models\Core\Role\Role;
use App\Models\Core\Traits\TranslatedNameTrait;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Permission extends BaseModel
{
    use TranslatedNameTrait;

    protected $fillable = ['name', 'group_name'];

    protected $appends = ['translated_name'];

    public function roles(): BelongsToMany
    {
        return $this->belongsToMany(Role::class);
    }
}
