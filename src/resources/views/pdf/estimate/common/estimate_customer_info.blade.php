@if($estimate->customer)
    {{$estimate->customer->billingAddress?->name ? $estimate->customer->billingAddress->name : $estimate->customer->full_name}}<br>
    {{$estimate->customer->billingAddress?->address ? $estimate->customer->billingAddress->address.',' : '' }}
    {{$estimate->customer->billingAddress?->city ? $estimate->customer->billingAddress->city.',' : '' }}
    {{$estimate->customer->billingAddress?->state ? $estimate->customer->billingAddress->state.'-' : '' }}{!! $estimate->customer->billingAddress?->zip_code ? $estimate->customer->billingAddress->zip_code.',' : '' !!}
    {!! $estimate->customer->billingAddress?->country ? $estimate->customer->billingAddress->country->name.'<br>' : '' !!}
    {{$estimate->customer->email }}<br>
    @if($estimate->customer->billingAddress?->phone)
        {!! $estimate->customer->billingAddress->phone.'<br>' !!}
    @else
        @if($estimate->customer?->userProfile)
            <span>{{ $estimate->customer->userProfile->phone_number }}</span><br>
        @endif
    @endif
@endif
