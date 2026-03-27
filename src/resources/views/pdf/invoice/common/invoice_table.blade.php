<thead>
<tr>
    <th style='text-align:left; width:40%;padding-right: 15px;'>{{__('default.invoice_pdf.product')}}</th>
    <th style='text-align:left;'>{{__('default.invoice_pdf.quantity')}}</th>
    <th style='text-align:left;'>{{__('default.invoice_pdf.price')}}</th>
    <th style='text-align:right;'>{{__('default.invoice_pdf.amount')}}</th>
</tr>
</thead>
<tbody>
@foreach($invoice->invoiceDetails as $detail)
    <tr style='border-bottom: 1px dashed lightgrey;'>
        <td style='width:40%;'>
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
