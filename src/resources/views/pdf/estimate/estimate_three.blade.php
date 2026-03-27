<!DOCTYPE html>
<html lang="en">
<head>
    <title>{{config('settings.application.company_name')}} Estimate</title>
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

<div style="color: #312f2f;">
    <div style='width:100%;text-align:center;display:flex;flex-direction:column; justify-content: center; align-items:center;padding-bottom: 10px;border-bottom: 1px dashed #ededed;'>
        <img style="display:inline-block;" src="{{$estimate_logo}}" height='70' alt="estimate logo">
        <div style="text-align: center">
            @include('pdf.estimate.common.estimate_company_info_three')
        </div>
    </div>
    <table style="margin-top:5px;width:100%;border-collapse: collapse;">
        <tr>
            <td style='text-align:left;vertical-align: top'>
                <div style='
                        font-size: 18px;
                        text-transform: uppercase;
                        margin-bottom: 4px;
                        font-weight: bold;
                        margin-top: 8px; color: #0e4da4;'>
                    {{__('default.estimate_pdf.estimate_to')}}
                </div>
                <div style='font-size: 14px;'>
                    @include('pdf.estimate.common.estimate_customer_info')
                </div>
            </td>
            <td style='vertical-align: top;text-align:right;'>
                <div style='font-size: 18px;margin-bottom: 4px;color: #0e4da4;text-transform: uppercase;'>
                    <b>{{__('default.estimate_pdf.estimate')}}</b>
                </div>
                <div style="font-size: 14px; color: #0e4da4;">{{__('default.estimate_pdf.estimate_no')}}: {{$estimate->invoice_full_number}}</div>
                <div style='font-size: 14px;'>
                    {{__('default.invoice_pdf.issue_date')}}: {{app_date_format($estimate->date)}} <br>
                </div>
            </td>
        </tr>
    </table>
    <div>
        <table style='width: 100%; margin-top: 25px; border-collapse: collapse;'>
            @include('pdf.estimate.common.estimate_table')
        </table>
        @include('pdf.estimate.common.estimate_note')
    </div>


</div>

</body>
</html>


