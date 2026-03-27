<?php

namespace App\Http\Controllers\Mobile\Api\Notification;

use App\Http\Controllers\Controller;
use App\Http\Resources\Mobile\Notification\NotificationResourceCollection;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Psr\Container\ContainerExceptionInterface;
use Psr\Container\NotFoundExceptionInterface;

class NotificationController extends Controller
{
    /**
     * @throws NotFoundExceptionInterface
     * @throws ContainerExceptionInterface
     */
    public function index()
    {
        $request = request();
        $notifications = auth()->user()->notifications();

        if ($request->read)
            $notifications = $notifications->whereNotNull('read_at');
        if ($request->unread)
            $notifications = $notifications->whereNull('read_at');

        $notifications = $notifications->latest('created_at');

        $date = json_decode(htmlspecialchars_decode($request->get('date')), true);

        $notificationData =  $notifications->when($date, function (Builder $builder) use ($date) {
            $builder->whereBetween(DB::raw('DATE(created_at)'), array_values($date));
        })->when($request->get('search'), function (Builder $builder) use ($request) {
            $builder->whereRaw('JSON_UNQUOTE(JSON_EXTRACT(data, "$.message")) LIKE ?', ["%" . $request->get('search') . "%"]);
        })->paginate($request->get('per_page', 10));

        return success_response('Notifications fetched successfully', new NotificationResourceCollection($notificationData));
    }

    public function markAsReadAll(): \Illuminate\Http\JsonResponse
    {
        auth()->user()->unreadNotifications->markAsRead();

        return success_response('Notifications marked as read successfully');

    }

    public function getUnreadNotifications(): \Illuminate\Http\JsonResponse
    {
        $countUnread = auth()->user()->unreadNotifications->count();
        $isExists = false;
        if ($countUnread){
            $isExists = true;
        }

        return success_response('Data fetched successfully',$isExists);
    }
}
