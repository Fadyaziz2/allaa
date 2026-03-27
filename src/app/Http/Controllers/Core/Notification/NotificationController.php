<?php

namespace App\Http\Controllers\Core\Notification;

use App\Http\Controllers\Controller;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Facades\DB;


class NotificationController extends Controller
{
    public function index()
    {
        $request = request();
        $notifications = auth()->user()->notifications();

        if ($request->read || $request->status === 'read')
            $notifications = $notifications->whereNotNull('read_at');
        if ($request->unread || $request->status === 'unread')
            $notifications = $notifications->whereNull('read_at');

        $notifications = $notifications->latest('created_at');

        $date = json_decode(htmlspecialchars_decode($request->get('date')), true);

        return $notifications->when($date, function (Builder $builder) use ($date) {
            $builder->whereBetween(DB::raw('DATE(created_at)'), array_values($date));
        })->when($request->get('search'), function (Builder $builder) use ($request) {
            $builder->whereRaw('JSON_UNQUOTE(JSON_EXTRACT(data, "$.message")) LIKE ?', ["%" . $request->get('search') . "%"]);
        })->paginate($request->get('per_page', 10));
    }

    public function markAsRead($id): \Illuminate\Http\JsonResponse
    {
        $notification = auth()->user()
            ->notifications()
            ->whereId($id)
            ->first();
        $notification->markAsRead();

        return response()->json([
            'message' => __('default.marked_successfully')
        ]);
    }

    public function markAsUnread($id): \Illuminate\Http\JsonResponse
    {
        $notification = auth()->user()->notifications()->whereId($id)->first();
        $notification->markAsUnread();

        return response()->json([
            'message' => __('default.un_marked_successfully')
        ]);

    }

    public function markAsReadAll(): \Illuminate\Http\JsonResponse
    {
        auth()->user()->unreadNotifications->markAsRead();

        return response()->json([
            'message' => __('default.marked_successfully')
        ]);

    }

}
