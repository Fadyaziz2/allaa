<?php

namespace App\Services\Invoice\Customer;

use App\Mail\Invoice\Customer\CustomerPortalInvitation;
use App\Models\User;
use App\Services\Invoice\AppService;
use Illuminate\Support\Facades\Mail;

class CustomerService extends AppService
{
    public function __construct(User $user)
    {
        $this->model = $user;
    }

    public function assignRole($customer): static
    {

        $customer->assignRole('Customer');

        return $this;
    }

    public function userProfile($customer): static
    {

        $customer->userProfile()->updateOrCreate([
            'user_id' => $customer->id
        ], [
                'phone_number' => $this->getAttribute('phone_number'),
                'phone_country' => $this->getAttribute('phone_country'),
                'portal_access' => $this->getAttribute('portal_access') && count($this->getAttribute('portal_access')) > 0 ? 1 : 0,
                'tax_no' => $this->getAttribute('tax_no')
            ]
        );

        return $this;
    }

    public function billingInfo($customer): static
    {
        $customer->billingAddress()->updateOrCreate([
            'user_id' => $customer->id
        ], [
            'name' => $this->getAttribute('name'),
            'country_id' => $this->getAttribute('country_id'),
            'city' => $this->getAttribute('city'),
            'state' => $this->getAttribute('state'),
            'zip_code' => $this->getAttribute('zip_code'),
            'phone' => $this->getAttribute('phone'),
            'address' => $this->getAttribute('address'),
        ]);
        return $this;
    }

    public function portalInvitation(): static
    {

        if ($this->getAttribute('portal_access') !== null && count($this->getAttribute('portal_access')) > 0) {
            $this->sendMail();
        }

        return $this;
    }

    public function userProfileDelete(): static
    {
        $this->model->userProfile()->delete();
        return $this;
    }

    public function billingAddressDelete(): static
    {
        $this->model->billingAddress()->delete();
        return $this;
    }

    public function resendPortalAccessMail(): static
    {
        $this->sendMail();
        return $this;
    }

    public function updateProfilePortal(): static
    {
        $this->model->userProfile()->updateOrCreate([
            'user_id' => $this->model->id
        ], [

            'portal_access' => 1
        ]);

        return $this;
    }

    public function mobileUserProfile($customer): static
    {
        $customer->userProfile()->updateOrCreate([
            'user_id' => $customer->id
        ], [
                'phone_number' => $this->getAttribute('phone_number'),
                'phone_country' => $this->getAttribute('phone_country'),
                'tax_no' => $this->getAttribute('tax_no')
            ]
        );

        return $this;
    }

    public function mobilePortalInvitation(): static
    {
        if ($this->getAttribute('portal_access') !== null && $this->getAttribute('portal_access') == 1) {
            $this->sendMail();
        }

        return $this;

    }

    private function sendMail(): void
    {
        $password = $this->randomPassword();
        $this->model->update([
            'password' => $password
        ]);
        Mail::to(optional($this->model)->email)
            ->send(new CustomerPortalInvitation($this->model, $password));
    }

    public function randomPassword(): string
    {
        $alphabet = "abcdefghijklmnopqrstuwxyzABCDEFGHIJKLMNOPQRSTUWXYZ0123456789";
        $pass = array(); //remember to declare $pass as an array
        $alphaLength = strlen($alphabet) - 1; //put the length -1 in cache
        for ($i = 0; $i < 8; $i++) {
            $n = rand(0, $alphaLength);
            $pass[] = $alphabet[$n];
        }
        return implode($pass); //turn the array into a string
    }

}
