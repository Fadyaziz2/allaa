<?php

namespace Database\Factories\Invoice\Customer;

use App\Models\Core\Status\Status;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;


class CustomerFactory extends Factory
{
    protected $model = User::class;

    public function definition(): array
    {
        $status = Status::query()->where('type', 'user')
            ->pluck('id')
            ->toArray();
        return [
            'first_name' => fake()->firstName(),
            'last_name' => fake()->lastName(),
            'email' => fake()->unique()->safeEmail(),
            'email_verified_at' => now(),
            'password' => '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', // password
            'remember_token' => Str::random(30),
            'is_admin' => 0,
            'status_id' => $status[array_rand($status)],
        ];
    }
}
