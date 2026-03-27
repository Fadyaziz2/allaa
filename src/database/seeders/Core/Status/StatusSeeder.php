<?php

namespace Database\Seeders\Core\Status;

use App\Models\Core\Status\Status;
use Database\Seeders\Core\Traits\DisableForeignKeys;
use Illuminate\Database\Seeder;

class StatusSeeder extends Seeder
{
    use DisableForeignKeys;

    public function run(): void
    {
        $this->disableForeignKeys();

        Status::query()->truncate();

        $status = [
            [
                'name' => 'status_active',
                'type' => 'user',
                'class' => 'success'
            ],
            [
                'name' => 'status_inactive',
                'type' => 'user',
                'class' => 'danger'
            ],
            [
                'name' => 'status_invited',
                'type' => 'user',
                'class' => 'orange',
            ],
            [
                'name' => 'status_paid',
                'type' => 'invoice',
                'class' => 'success'
            ],
            [
                'name' => 'status_due',
                'type' => 'invoice',
                'class' => 'danger'
            ],
            [
                'name' => 'status_pending',
                'type' => 'estimate',
                'class' => 'warning'
            ],
            [
                'name' => 'status_approved',
                'type' => 'estimate',
                'class' => 'success'
            ],
            [
                'name' => 'status_reject',
                'type' => 'estimate',
                'class' => 'danger'
            ]
        ];

        Status::query()->insert($status);

        $this->enableForeignKeys();
    }
}
