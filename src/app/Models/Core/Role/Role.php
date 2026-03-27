<?php

namespace App\Models\Core\Role;

use App\Models\Core\BaseModel;
use App\Models\Core\Permission\Permission;
use App\Models\Core\Traits\RoleMethod;
use App\Models\User;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Role extends BaseModel
{
    use RoleMethod;

    protected $fillable = ['name', 'alias', 'is_admin', 'is_default', 'created_by'];

    protected $casts = [
        'is_admin' => 'boolean',
        'is_default' => 'boolean',
    ];

    public function users(): BelongsToMany
    {
        return $this->belongsToMany(User::class);
    }

    public function permissions(): BelongsToMany
    {
        return $this->belongsToMany(Permission::class);
    }

}
