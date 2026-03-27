<?php

namespace App\Http\Controllers\Core\Notification;

use App\Http\Controllers\Controller;
use App\Models\Core\Notification\NotificationTemplate;
use Illuminate\Http\Request;

class NotificationTemplateController extends Controller
{

    public function update(Request $request, NotificationTemplate $template)
    {
        $template->update([
            'subject' => $request->subject,
            'custom_content' => $request->description
        ]);

        return updated_responses('templates');

    }
}
