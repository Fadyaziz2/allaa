<strong style="color: #0e4da4;">{{config('app.name')}}</strong><br>
<b>{{__('default.address')}}: </b>{{config('settings.application.company_address')}}<br>
<b>{{__('default.phone')}}: </b>{{config('settings.application.company_phone')}}
@if(config('settings.application.company_tax_id'))
<b>{{__('default.tax_id')}}: </b>{{config('settings.application.company_tax_id')}}
@endif
@if(config('settings.application.company_website'))
<b>{{__('default.web')}}: </b>{{config('settings.application.company_website')}}
@endif
