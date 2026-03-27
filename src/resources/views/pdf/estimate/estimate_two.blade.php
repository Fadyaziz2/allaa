<!DOCTYPE html>
<html lang="en">
<head>
    <title>{{config('settings.application.company_name')}} Estimate</title>
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
                        {{__('default.estimate_pdf.estimate')}}
                    </div>
                    <div style='font-size: 14px; color: #0e4da4;'>
                        {{__('default.estimate_pdf.estimate_no')}}: {{$estimate->invoice_full_number}}
                    </div>
                    <div style='font-size: 14px;margin-bottom: 16px'>
                        {{__('default.invoice_pdf.date')}}: {{app_date_format($estimate->date)}} <br>
                    </div>
                    <div style='font-size: 18px;
                        text-transform: uppercase;
                        margin: 4px 0;
                        font-weight: bold;
                        margin-top: 8px;
                        color: #0e4da4;'
                    >
                        {{__('default.estimate_pdf.estimate_to')}}
                    </div>
                    <div style='font-size: 14px;  '>
                        @include('pdf.estimate.common.estimate_customer_info')
                    </div>
                </td>
                <td style='text-align:right;vertical-align: top;max-width:50%;word-break: break-all;word-wrap: break-word;'>
                    <div style='width:100%;display:block'>
                        <img style="margin-left: 100%;display:inline-block;" src="{{$estimate_logo}}" height='70' alt="Estimate logo">
                        @include('pdf.estimate.common.estimate_company_info')
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <table style='width: 100%; margin-top: 16px; border-collapse: collapse;'>
        @include('pdf.estimate.common.estimate_table')
    </table>
    @include('pdf.estimate.common.estimate_note')
</div>
</body>
</html>
