<?php

namespace App\Models\Core\Notification;

use Illuminate\Database\Eloquent\Model;

class NotificationTemplate extends Model
{

    protected $fillable = ['subject', 'default_content', 'custom_content', 'type', 'notification_type_id'];


    public function parse(array $vars = [], $subject = false): string
    {
        $content = $this->attributes['custom_content'] ?? $this->attributes['default_content'];
        if ($subject) {
            $content = $this->attributes['subject'];
        }
        return strtr($content, $vars);
    }

    public function subjectReplace(array $vars = []): string
    {
        return $this->parse($vars, true);
    }


    public function notificationType(): \Illuminate\Database\Eloquent\Relations\BelongsTo
    {
        return $this->belongsTo(NotificationType::class, 'notification_type_id', 'id');
    }

    public function audiences(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(NotificationTemplateAudience::class, 'notification_template_id', 'id');
    }

}
