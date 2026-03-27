<thead>
<tr>
    <th style='width:40%; text-align:left;'>{{__('default.invoice_pdf.product')}}</th>
    <th style='text-align:left;'>{{__('default.invoice_pdf.quantity')}}</th>
    <th style='text-align:left;'>{{__('default.invoice_pdf.price')}}</th>
    <th style='text-align:right;'>{{__('default.invoice_pdf.amount')}}</th>
</tr>
</thead>

<tbody>
    @foreach($estimate->estimateDetails as $detail)
        <tr style='border-bottom: 1px dashed lightgrey;'>
            <td style='width:40%;padding-right: 15px;'>
                @if($detail->product)
                    {{$detail->product->name}}
                @endif
            </td>
            <td style='text-align:left;'>{{$detail->quantity}}</td>
            <td style='text-align:left;'>{{number_with_currency_symbol($detail->price)}}</td>
            <td align="right">{{number_with_currency_symbol($detail->quantity * $detail->price)}}</td>
        </tr>
    @endforeach
</tbody>
<tfoot style="line-height: 1.5; white-space:nowrap">
<tr>
    <td colspan="2"></td>
    <td><b style='font-weight: bold;color:#0E4DA4;'>{{__('default.invoice_pdf.subtotal')}}</b></td>
    <td style='text-align:right;'><b
            style='font-weight: bold;color:#0E4DA4;'>{{number_with_currency_symbol($estimate->sub_total)}}</b></td>
</tr>
<tr>
    <td colspan="2"></td>
    <td style='color:#0E4DA4;'>{{__('default.invoice_pdf.discount')}} @if($estimate->discount_type === 'percentage')
            ({{$estimate->discount_amount}}%)
        @endif</td>
    @if($estimate->discount_type === 'percentage')
        <td style='text-align:right;color:#0E4DA4;'>{{number_with_currency_symbol(($estimate->sub_total*$estimate->discount_amount/100))}}</td>
    @else
        <td style='text-align:right;color:#0E4DA4;'>{{number_with_currency_symbol($estimate->discount_amount)}}</td>
    @endif
</tr>
<tr>
    <td colspan="2"></td>
    <td><b style='font-weight: bold;color:#0E4DA4;'>{{__('default.invoice_pdf.total')}}</b></td>
    <td style='text-align:right;'><b
            style='font-weight: bold;color:#0E4DA4;'>{{number_with_currency_symbol($estimate->total_amount)}}</b>
    </td>
</tr>
@foreach($estimate->taxes as $taxInfo)
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
            style='font-weight: bold;color:#0E4DA4;'>{{number_with_currency_symbol($estimate->grand_total)}}</b>
    </td>
</tr>
<!-- @include('pdf.estimate.common.estimate_note')  -->
</tfoot>
