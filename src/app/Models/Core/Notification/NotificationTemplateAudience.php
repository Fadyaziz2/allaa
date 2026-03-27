<?php

namespace App\Models\Core\Notification;

use Illuminate\Database\Eloquent\Model;

class NotificationTemplateAudience extends Model
{
    protected $fillable = ['notification_template_id', 'audience_type', 'audience'];
}
