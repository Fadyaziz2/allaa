<?php

namespace Database\Factories\Invoice\Customer;

use App\Models\Core\User\UserProfile;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;


class UserProfileFactory extends Factory
{
   protected $model = UserProfile::class;

    public function definition(): array
    {
        return [
            'gender' => $this->faker->randomElement(['male', 'female', 'others']),
            'phone_number' => $this->faker->phoneNumber,
            'phone_country' => $this->faker->countryCode,
            'address' => $this->faker->address,
            'date_of_birth' => $this->faker->date('Y-m-d', '2000-01-01'),
            'tax_no' => $this->faker->randomDigit(),
            'portal_access' => $this->faker->randomElement([0,1])
        ];
    }
}
