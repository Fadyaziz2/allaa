<?php

namespace Database\Seeders\Core\Notification;

use App\Models\Core\Notification\NotificationTemplate;
use App\Models\Core\Notification\NotificationTemplateAudience;
use App\Models\Core\Role\Role;
use Database\Seeders\Core\Traits\DisableForeignKeys;
use Illuminate\Database\Seeder;

class NotificationAudienceSeeder extends Seeder
{
    use DisableForeignKeys;

    public function run(): void
    {
        $this->disableForeignKeys();

        NotificationTemplateAudience::query()->truncate();

        $supperAdmin = Role::query()->where('is_admin', 1)->pluck('id');

        $userJoin = NotificationTemplate::query()->where('type', 'database')
            ->withWhereHas('notificationType', function ($query) {
                $query->whereIn('name', ['user_joined']);
            });

        $userJoin->each(fn($item) => $item->audiences()->create([
            'audience_type' => 'roles',
            'audience' => $supperAdmin
        ]));
    }
}
