<tfoot style="line-height: 1.5; white-space:nowrap">
<tr>
    <td colspan="2"></td>
    <td><b style='font-weight: bold;color:#0E4DA4;'>{{__('default.invoice_pdf.subtotal')}}</b></td>
    <td style='text-align:right;'><b
            style='font-weight: bold;color:#0E4DA4;'>{{number_with_currency_symbol($invoice->sub_total)}}</b>
    </td>
</tr>
<tr>
    <td colspan="2"></td>
    <td style='color:#0E4DA4;'>{{__('default.invoice_pdf.discount')}} @if($invoice->discount_type === 'percentage')
        ({{$invoice->discount_amount}}%)
        @endif
    </td>
    @if($invoice->discount_type === 'percentage')
        <td style='text-align:right;color:#0E4DA4;'>{{number_with_currency_symbol(($invoice->sub_total*$invoice->discount_amount/100))}}</td>
    @else
        <td style='text-align:right;color:#0E4DA4;'>{{number_with_currency_symbol($invoice->discount_amount)}}</td>
    @endif
</tr>
<tr>
    <td colspan="2"></td>
    <td><b style='font-weight: bold;color:#0E4DA4;'>{{__('default.invoice_pdf.total')}}</b></td>
    <td style='text-align:right;'>
        <b style='font-weight: bold;color:#0E4DA4;'>{{number_with_currency_symbol($invoice->total_amount)}}</b>
    </td>
</tr>
@foreach($invoice->taxes as $taxInfo)
    <tr>
        <td colspan="2"></td>
        <td style='color:#0E4DA4;vertical-align:top'>
            @if($taxInfo->tax)
                {{$taxInfo->tax->name}} ({{($taxInfo->tax->rate)}}%)
            @endif
        </td>
        <td style='text-align:right;color:#0E4DA4;'>
            {{number_with_currency_symbol($taxInfo->total_amount)}}
        </td>
    </tr>
@endforeach
<tr>
    <td colspan="2"></td>
    <td><b style='font-weight: bold;color:#0E4DA4;'>{{__('default.invoice_pdf.grand_total')}}</b></td>
    <td style='text-align:right;'><b
            style='font-weight: bold;color:#0E4DA4;'>{{number_with_currency_symbol($invoice->grand_total)}}</b>
    </td>
</tr>
<tr>
    <td colspan="2"></td>
    <td><b style='font-weight: bold;color:#0E4DA4;'>{{__('default.invoice_pdf.received_amount')}}</b></td>
    <td style='text-align:right;'><b
            style='font-weight: bold;color:#0E4DA4;'>{{number_with_currency_symbol($invoice->received_amount)}}</b>
    </td>
</tr>
<tr>
    <td colspan="2"></td>
    <td><b style='font-weight: bold;color:#0E4DA4;'>{{__('default.invoice_pdf.due_amount')}}</b></td>
    <td style='text-align:right;'><b
            style='font-weight: bold;color:#0E4DA4;'>{{number_with_currency_symbol($invoice->due_amount)}}</b>
    </td>
</tr>
</tfoot>
