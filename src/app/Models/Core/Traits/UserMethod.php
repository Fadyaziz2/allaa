<?php

namespace App\Models\Core\Traits;

use App\Models\Core\Role\Role;

trait UserMethod
{
    /**
     * @return mixed
     */
    public function isAdmin(): mixed
    {
        return $this->hasRole(config('access.users.app_admin_role'));
    }

    public function assignRole($role): ?bool
    {
        if ($this->hasRole($role)) {
            return true;
        }

        if (is_string($role)) {
            return $this->roles()->attach(
                Role::findByName($role)->id
            );
        }

        return $this->roles()->attach($role instanceof Role ? $role->id : $role);
    }

    public function isAppAdmin(): bool
    {
        return $this->admin();
    }

    public function isCustomer(): bool
    {
        return $this->customer();
    }

    /*
    * @param string $type
    * @param null $brand_id
    * @return mixed
    * @throws \Exception
    *
    * Basically the result is cached. it will be deleted if any updated is happens in user model
    */
    public function admin()
    {
        return $this->roles()
            ->where('is_admin', 1)
            ->where('is_default', 1)
            ->exists();
    }

    public function customer(): bool
    {
        return $this->roles()
            ->where('alias', 'customer')
            ->where('is_default', 1)
            ->exists();
    }
}
