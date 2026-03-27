<?php

namespace Database\Seeders\Core\Notification;

use App\Models\Core\Notification\NotificationType;
use Database\Seeders\Core\Traits\DisableForeignKeys;
use Illuminate\Database\Seeder;

class NotificationTypeSeeder extends Seeder
{
    use DisableForeignKeys;

    public function run(): void
    {
        $this->disableForeignKeys();

        NotificationType::query()->truncate();

        $notifications = [
            [
                'name' => 'reset_password'
            ],
            [
                'name' => 'user_invitation'
            ],
            [
                'name' => 'user_joined'
            ],
            [
                'name' => 'customer_credential'
            ],
            [
                'name' => 'invoice_sending_attachment'
            ],
            [
                'name' => 'payment_received'
            ],
            [
                'name' => 'quotation_sending_attachment'
            ],[
                'name' => 'recurring_sending_attachment'
            ],
        ];

        NotificationType::query()->insert($notifications);

        $this->enableForeignKeys();
    }
}
