<?php

use App\Helpers\Core\General\SettingHelper;

if (!function_exists('number_with_currency_symbol')) {
    function number_with_currency_symbol($number)
    {
        return resolve(SettingHelper::class)->numberWithCurrencySymbol($number);
    }
}
if (!function_exists('app_date_format')) {
    function app_date_format($date)
    {
        return resolve(SettingHelper::class)->appDateFormat($date);
    }
}
