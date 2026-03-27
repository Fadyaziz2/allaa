<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Invoice</title>
    <style>
        body {
            font-size: 13px;
            margin: 0;
            padding: 0;
            width: 60mm;
            max-width: 60mm;
        }

        .header-border {
            border-top: 1px dashed #000;
            margin-bottom: 2px;
            padding-top: 1px;
        }

        .header-border-top {
            border-top: 1px dashed #000;
            margin-bottom: 2px;
            padding-top: 1px;
        }


        table.items {
            width: 100%;
            border-collapse: collapse;
            margin: 3px 0;
            table-layout: fixed;
            font-size: 11px;
        }

        .receipt {
            width: 100%;
            max-width: 58mm;
            padding: 2px 0;
            text-align: center;
        }

        .header {
            text-align: center;
            font-size: 12px;
            font-weight: bold;
            /*padding-bottom: 4px;*/
        }

        .details {
            margin-top: 3px;
            margin-bottom: 3px;
            text-align: left;
            padding: 3px 0;
        }

        .details p {
            margin: 1px 0;
        }

        table.items {
            width: 100%;
            border-collapse: collapse;
            margin-top: 3px;
        }

        /* Header cells */
        table.items th,
        table.items td {
            font-size: 11px;
            text-align: left;
            padding: 1px 4px;
            word-wrap: break-word;
        }

        table.items td {
            word-break: break-word;
            max-width: 100px;
        }

        table.items tr td {
            padding: 2px 4px;
        }

        table.items tbody tr {
            border-bottom: 1px solid #ddd;
        }


        /* Style for the totals footer */
        table.items tfoot tr td {
            /*padding: 3px 4px;*/
            font-size: 11px;
            white-space: nowrap;
        }

        table.items tfoot tr td:nth-child(3),
        table.items tfoot tr td:nth-child(4) {
            text-align: right;
        }

        .divider {
            border-top: 1px dashed #000;
        }

        .footer {
            text-align: center;
            margin-top: 5px;
            font-size: 11px;
        }
    </style>
</head>

<body>
<div class="receipt">
    <!-- Header -->
    <div class="header">
        @if (config('app.name'))
            <span>{{ config('app.name') }}</span><br>
        @endif

        @if (config('settings.application.company_address'))
            <span>{{ config('settings.application.company_address') }}</span><br>
        @endif

        @if (config('settings.application.company_phone'))
            <span>Phone: {{ config('settings.application.company_phone') }}</span>
        @endif
    </div>
    <br>
    <div class="header-border-top"></div>
    <div class="header-border-top"></div>
    <div class="details">
        <p><b>{{ __('default.estimate_pdf.estimate') }} #:</b> {{ $estimate->invoice_full_number }}</p>
        <p><b>{{ __('default.invoice_pdf.issue_date') }}:</b>
            {{ \Carbon\Carbon::parse()->parse($estimate->issue_date)->format($systemSettings['date_format']) }} ,
            {{ \Illuminate\Support\Carbon::parse()->parse($estimate->created_at)->timezone($systemSettings['time_zone'])->format('g:i A') }}
        </p>
        <p><b>{{ __('default.invoice_pdf.customer') }}:</b> {{ $estimate->customer->full_name }}</p>
    </div>
    <div class="header-border"></div>
    <div class="header-border"></div>

    <!-- Order Items -->
    <table class="items">
        <thead>
        <tr>
            <th style="width: 50%">{{ __('default.invoice_pdf.item') }}</th>
            <th style="width: 20%">{{ __('default.invoice_pdf.qty') }}</th>
            <th style="width: 30%; text-align:right">{{ __('default.invoice_pdf.price') }}</th>
        </tr>
        </thead>
        <tbody>
        @foreach ($estimate->estimateDetails as $detail)
            <tr>
                <td>{{ $detail->product->name ?? 'N/A' }}</td>
                <td>{{ $detail->quantity }}</td>
                <td style="text-align:right">
                    {{ number_with_currency_symbol($detail->quantity * $detail->price) }}</td>
            </tr>
        @endforeach
        </tbody>
        <tfoot>
        <tr>
            <td></td>
            <td style="text-align: right;"><b>{{ __('default.invoice_pdf.subtotal') }}</b></td>
            <td style="text-align: right;"><b>{{ number_with_currency_symbol($estimate->sub_total) }}</b></td>
        </tr>
        <tr>
            <td></td>
            <td style="text-align: right; ">
                <b>  {{ __('default.invoice_pdf.discount') }}
                    @if ($estimate->discount_type === 'percentage')
                        ({{ $estimate->discount_amount }}%)
                    @endif</b>
            </td>
            <td style="text-align: right;">
                <b>
                    @if ($estimate->discount_type === 'percentage')
                        {{ number_with_currency_symbol(($estimate->sub_total * $estimate->discount_amount) / 100) }}
                    @else
                        {{ number_with_currency_symbol($estimate->discount_amount) }}
                    @endif
                </b>
            </td>
        </tr>
        <tr>
            <td></td>
            <td style="text-align: right;"><b>{{ __('default.invoice_pdf.total') }}</b></td>
            <td style="text-align: right;"><b>{{ number_with_currency_symbol($estimate->total_amount) }}</b></td>
        </tr>
        @foreach ($estimate->taxes as $taxInfo)
            <tr>
                <td></td>
                <td style="text-align: right;">
                    @if ($taxInfo->tax)
                        <b>  {{ $taxInfo->tax->name }} ({{ $taxInfo->tax->rate }}%)</b>
                    @endif
                </td>
                <td style="text-align: right;">{{ number_with_currency_symbol($taxInfo->total_amount) }}</td>
            </tr>
        @endforeach
        <tr>
            <td></td>
            <td style="text-align: right;"><b>{{ __('default.invoice_pdf.grand_total') }}</b></td>
            <td style="text-align: right;"><b>{{ number_with_currency_symbol($estimate->grand_total) }}</b></td>
        </tr>
        </tfoot>
    </table>
    <div class="divider"></div>
    <!-- Footer -->
    <div class="footer">
        <p>{{ __('default.invoice_pdf.thank_you_for_your_purchase') }}</p>
        <span>{{ __('default.invoice_pdf.visit_us_again') }}</span>
    </div>
</div>
</body>
</html>
