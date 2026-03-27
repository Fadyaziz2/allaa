<?php

namespace App\Http\Controllers\Core\Notification;

use App\Http\Controllers\Controller;
use App\Models\Core\Notification\NotificationType;
use Illuminate\Http\Request;

class NotificationTypeController extends Controller
{

    public function index(): \Illuminate\Database\Eloquent\Collection|array
    {
        return NotificationType::query()
            ->get();
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
