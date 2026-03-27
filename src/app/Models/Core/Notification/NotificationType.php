<?php

namespace App\Models\Core\Notification;

use Illuminate\Database\Eloquent\Model;

class NotificationType extends Model
{
    public $timestamps = false;

    protected $fillable = ['name'];

    public function notificationTemplates(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(NotificationTemplate::class, 'notification_type_id', 'id');
    }

    protected $appends = ['original_name'];

    public function getOriginalNameAttribute(): array|string
    {
        return str_replace('_', ' ', ucfirst($this->attributes['name']));
    }
}
