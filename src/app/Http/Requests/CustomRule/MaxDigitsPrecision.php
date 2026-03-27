<?php

namespace App\Http\Requests\CustomRule;

use Illuminate\Contracts\Validation\Rule;

class MaxDigitsPrecision implements Rule
{

    private int $digits;

    public function __construct(int $digits)
    {
        $this->digits = $digits;
    }

    /**
     * Determine if the validation rule passes.
     *
     * @param  string  $attribute
     * @param  mixed  $value
     * @return bool
     */
    public function passes($attribute, $value): bool
    {
        $chaLength = strlen($value);

        return $chaLength <= $this->digits;
    }

    /**
     * Get the validation error message.
     *
     * @return string
     */
    public function message(): string
    {
        return "The :attribute must have a maximum of {$this->digits} digits in total.";
    }
}
