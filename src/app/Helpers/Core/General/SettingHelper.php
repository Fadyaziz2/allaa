<?php

namespace App\Helpers\Core\General;

use Carbon\Carbon;

class SettingHelper
{
    public function numberWithCurrencySymbol($number): string
    {
        if ($this->getCurrencyPosition() == 'prefix_with_space') {
            return $this->getCurrencySymbol() . ' ' . $this->numberFormatter($number);
        } elseif ($this->getCurrencyPosition() == 'prefix_only') {
            return $this->getCurrencySymbol() . $this->numberFormatter($number);
        } elseif ($this->getCurrencyPosition() == 'suffix_with_space') {
            return $this->numberFormatter($number) . ' ' . $this->getCurrencySymbol();
        } else {
            return $this->numberFormatter($number) . $this->getCurrencySymbol();
        }
    }

    public function numberFormatter($number): string
    {
        $number = number_format($number, $this->getNumberOfDecimal());
        $parts = explode('.', $number);
        $parts[0] = preg_replace('/\B(?=(\d{3})+(?!\d))/', $this->getThousandSeparator(), $parts[0]);
        return implode($this->getDecimalSeparator(), $parts);
    }

    public function getNumberOfDecimal()
    {
        return config('settings.application.number_of_decimal');
    }

    public function getThousandSeparator()
    {
        return config('settings.application.thousand_separator');
    }

    public function getDecimalSeparator()
    {
        return config('settings.application.decimal_separator');
    }

    public function getCurrencySymbol()
    {
        return config('settings.application.currency_symbol');
    }

    public function getCurrencyPosition()
    {
        return config('settings.application.currency_position');
    }

    public function appDateFormat($date): string
    {
        return Carbon::parse($date)->format($this->getDateFormat());
    }

    public function getDateFormat()
    {
        return config('settings.application.date_format');
    }
}
