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

<div style="color: #312f2f;" style="page-break-inside:avoid;">
    <div style="border-bottom: 1px dashed #e3e3e3;padding-bottom: 16px;">
        <table style="padding: 0;width:100%;border-collapse: collapse;table-layout:fixed;">
            <tr>
                <td style='text-align:left;vertical-align: top;max-width:50%;word-break: break-all;word-wrap: break-word;'>
                    <div
                        style='
                        font-size: 18px;
                        text-transform: uppercase;
                        font-weight: bold;
                        color: #0e4da4;'
                    >
                        {{__('default.invoice_pdf.invoice')}}
                    </div>
                    <div style='font-size: 16px; color: #0e4da4;'>
                        {{__('default.invoice_pdf.invoice_no')}}: {{$invoice->invoice_full_number}}
                    </div>
                    <div style='font-size: 16px;margin-bottom: 16px'>
                        {{__('default.invoice_pdf.issue_date')}}: {{app_date_format($invoice->issue_date)}} <br>
                        {{__('default.invoice_pdf.due_date')}}: {{app_date_format($invoice->due_date)}}
                    </div>
                    <div style='font-size: 16px;
                        text-transform: uppercase;
                        margin: 4px 0;
                        font-weight: bold;
                        margin-top: 8px;
                        color: #0e4da4;'
                    >
                        {{__('default.invoice_pdf.invoice_to')}}
                    </div>
                    <div style='font-size: 14px;'>
                        @include('pdf.invoice.common.invoice_customer_info')
                    </div>
                </td>
                <td style='text-align:right;vertical-align: top;max-width:50%;word-break: break-all;word-wrap: break-word;'>
                    <div style='width:100%;display:block'>
                        <img style="margin-left: 100%;display:inline-block;" src="{{$invoice_logo}}" height='70' alt="Invoice logo">
                        @include('pdf.invoice.common.invoice_company_info')
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <table style='width: 100%; margin-top: 16px; border-collapse: collapse;'>
        @include('pdf.invoice.common.invoice_table')
        @include('pdf.invoice.common.invoice_table_footer')
    </table>
    @include('pdf.invoice.common.invoice_note')
</div>
</body>
</html>
