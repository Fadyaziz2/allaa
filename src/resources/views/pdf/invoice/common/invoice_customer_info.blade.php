@if($invoice->customer)
    {{$invoice->customer->billingAddress?->name ? $invoice->customer->billingAddress->name : $invoice->customer->full_name}}<br>
    {{$invoice->customer->billingAddress?->address ? $invoice->customer->billingAddress->address.',' : '' }}
    {{$invoice->customer->billingAddress?->city ? $invoice->customer->billingAddress->city.',' : '' }}
    {{$invoice->customer->billingAddress?->state ? $invoice->customer->billingAddress->state.'-' : '' }}{!! $invoice->customer->billingAddress?->zip_code ? $invoice->customer->billingAddress->zip_code.',' : '' !!}
    {!! $invoice->customer->billingAddress?->country ? $invoice->customer->billingAddress->country->name.'<br>' : '' !!}
    {{$invoice->customer->email }}<br>
    @if($invoice->customer->billingAddress?->phone)
        {!! $invoice->customer->billingAddress->phone.'<br>' !!}
    @else
        @if($invoice->customer?->userProfile)
            <span>{{ $invoice->customer->userProfile->phone_number }}</span><br>
        @endif
    @endif
@endif
