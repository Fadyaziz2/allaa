<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use App\Filters\BaseFilter;
use App\Models\Core\Role\Role;
use App\Models\Core\Traits\HasRoles;
use App\Models\Core\Traits\Relationship\ProfilePictureRelationTrait;
use App\Models\Core\Traits\Relationship\StatusRelationTrait;
use App\Models\Core\Traits\UserMethod;
use App\Models\Core\User\UserOtp;
use App\Models\Core\User\UserProfile;
use App\Models\Invoice\Country\Country;
use App\Models\Invoice\Customer\BillingAddress;
use App\Models\Invoice\Notification\DeviceToken;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Illuminate\Support\Facades\Hash;
use Tymon\JWTAuth\Contracts\JWTSubject;

class User extends Authenticatable implements JWTSubject
{
    use HasFactory,
        Notifiable,
        ProfilePictureRelationTrait,
        StatusRelationTrait,
        UserMethod,
        HasRoles;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'first_name',
        'last_name',
        'email',
        'password',
        'invitation_token',
        'status_id',
        'is_admin',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
        'is_admin' => 'boolean',
        'status_id' => 'integer'
    ];

    protected $appends = ['full_name'];


    public function getFullNameAttribute()
    {
        return $this->last_name ? $this->first_name . ' ' . $this->last_name : $this->first_name;
    }

    public function setPasswordAttribute($password): void
    {
        $this->attributes['password'] = Hash::make($password);
    }

    public function userProfile(): HasOne
    {
        return $this->hasOne(UserProfile::class);
    }

    public function roles(): \Illuminate\Database\Eloquent\Relations\BelongsToMany
    {
        return $this->belongsToMany(Role::class);
    }

    public function role()
    {
        return $this->roles()->toOne();
    }

    public function billingAddress(): HasOne
    {
        return $this->hasOne(BillingAddress::class, 'user_id');
    }

    public function country(): \Illuminate\Database\Eloquent\Relations\BelongsTo
    {
        return $this->belongsTo(Country::class, 'country_id', 'id');
    }

    public function otpNumber(): HasOne
    {
        return $this->hasOne(UserOtp::class);
    }

    public function scopeFilter($query, BaseFilter $filter): \Illuminate\Database\Eloquent\Builder
    {
        return $filter->apply($query);
    }

    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    public function getJWTCustomClaims(): array
    {
        return [];
    }

    public function deviceTokens(): HasMany
    {
        return $this->hasMany(DeviceToken::class);
    }

}
