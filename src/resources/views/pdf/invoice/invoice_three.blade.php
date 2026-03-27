<!DOCTYPE html>
<html lang="en">
<head>
    <title>{{config('settings.application.company_name')}} Invoice</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <style>
        body{
            font-family:'DejaVu Sans', Arial, Helvetica, sans-serif;
            line-height: 1.3;
        }
        p{
            margin: 0;
            padding: 0;
        }
    </style>
</head>
<body style='margin:2px; padding:0;'>

<div style='width:100%;text-align:center;display:flex;flex-direction:column; justify-content: center; align-items:center;padding-bottom: 10px;border-bottom: 1px dashed #ededed;'>
        <img style="display:inline-block;" src="{{$invoice_logo}}" height='70' alt="invoice logo">
        <div style="text-align: center">
            @include('pdf.invoice.common.invoice_company_info_three')
        </div>
    </div>
    <table style="margin-top:5px;width:100%;border-collapse: collapse;">
        <tr>
            <td style='text-align:left;vertical-align: top'>
                <div style='
                        font-size: 16px;
                        text-transform: uppercase;
                        font-weight: bold;
                        margin-top: 8px; color: #0e4da4;'>
                    {{__('default.invoice_pdf.invoice_to')}}
                </div>
                <div style='font-size: 14px;'>
                    @include('pdf.invoice.common.invoice_customer_info')
                </div>
            </td>
            <td style='vertical-align: top;text-align:right;'>
                <div style='font-size: 16px;margin-bottom: 4px;color: #0e4da4;text-transform: uppercase;'>
                    <b>{{__('default.invoice_pdf.invoice')}}</b>
                </div>
                <div style="font-size: 14px; text-transform:uppercase;color: #0e4da4;">{{__('default.invoice_pdf.invoice_no')}}: {{$invoice->invoice_full_number}}</div>
                <div style='font-size: 14px;'>
                    {{__('default.invoice_pdf.issue_date')}}: {{app_date_format($invoice->issue_date)}} <br>
                    {{__('default.invoice_pdf.due_date')}}: {{app_date_format($invoice->due_date)}}
                </div>
            </td>
        </tr>
    </table>
    <table style='width: 100%; margin-top: 25px; border-collapse: collapse;'>
        @include('pdf.invoice.common.invoice_table')
        @include('pdf.invoice.common.invoice_table_footer')
    </table>
    @include('pdf.invoice.common.invoice_note')
</div>
</body>
</html>
