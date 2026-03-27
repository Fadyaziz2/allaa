<?php
return [
    'app' => [
        ['name' => 'company_name', 'value' => 'InvoiceX'],
        ['name' => 'company_logo', 'value' => '/assets/images/logo.svg'],
        ['name' => 'company_icon', 'value' => '/assets/images/icon.png'],
        ['name' => 'company_banner', 'value' => '/assets/images/banner.png'],
        ['name' => 'company_phone', 'value' => null],
        ['name' => 'company_address', 'value' => null],
        ['name' => 'company_tax_id', 'value' => null],
        ['name' => 'company_website', 'value' => null],
        ['name' => 'language', 'value' => 'en'],
        ['name' => 'date_format', 'value' => 'd-m-Y'],
        ['name' => 'time_format', 'value' => 'h'],
        ['name' => 'time_zone', 'value' => 'Asia/Dhaka'],
        ['name' => 'currency_symbol', 'value' => '$'],
        ['name' => 'decimal_separator', 'value' => '.'],
        ['name' => 'thousand_separator', 'value' => ','],
        ['name' => 'number_of_decimal', 'value' => '2'],
        ['name' => 'currency_position', 'value' => 'prefix_with_space'],
        ['name' => 'firebase_server_key', 'value' => 'AAAAQ9Ya2Y4:APA91bH2P_3suVjla3p3_9YUOs4NSoYLDdKltpgdMCU-F4kTttw2FDprnMVN2b4cvayUaaaDoxEqAYvJ2Dww-HaMGTPde_VPRNtb1D7W199m78FsRSDasrY7VqNZC0YfLJlPY1yD0xI2']
    ],

    'time_format' => [
        'h',
        'H'
    ],

    'currency_position' => [
        'prefix_only',
        'prefix_with_space',
        'suffix_only',
        'suffix_with_space'
    ],

    'date_format' => [
        'd-m-Y',
        'm-d-Y',
        'Y-m-d',
        'm/d/Y',
        'd/m/Y',
        'Y/m/d',
        'm.d.Y',
        'd.m.Y',
        'Y.m.d'
    ],

    'decimal_separator' => [
        '.',
        ','
    ],

    'thousand_separator' => [
        '.',
        ',',
        'space'
    ],
    'number_of_decimal' => [
        '0',
        '2'
    ],
];
