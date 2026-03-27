<template>
    <div class="content-wrapper">
        <app-breadcrumb  :page-title="$t('customer_details')"/>
        <div class="row">
            <div class="col-md-3">
                <div class="customer-profile-panel rounded-default mb-3">
                    <div class="inner">
                        <div class="photo">
                            <img
                                :src="customerDetails.profile_picture ? urlGenerator(customerDetails.profile_picture.path) :  urlGenerator('assets/images/avatar.svg')"
                                :alt="customerDetails.full_name" class="img-fluid ">
                        </div>
                        <div class="user-info">
                            <h5 class="mb-2 fw-bold fs-16 brand-color">{{ customerDetails.full_name }}</h5>
                            <p class="mb-0 fs-16 user-email">{{ customerDetails.email }}</p>
                        </div>
                    </div>
                    <div class="other-infos mt-4">
                        <div class="info mb-3">
                            <p class="mb-0 title">{{ $t('phone_number') }}</p>
                            <p class="mb-0 fs-16 values">
                                {{
                                    customerDetails.user_profile && customerDetails.user_profile.phone_number ? customerDetails.user_profile.phone_number : '-'
                                }}</p>
                        </div>
                        <div class="info mb-3">
                            <p class="mb-0 title">{{ $t('tax_no') }}</p>
                            <p class="mb-0 fs-16 values">
                                {{
                                    customerDetails.user_profile && customerDetails.user_profile.tax_no ? customerDetails.user_profile.tax_no : '-'
                                }}</p>
                        </div>
                        <h5 class="mb-3 fw-bold fs-16 brand-color">{{ $t('billing_address') }}</h5>
                        <div class="info mb-3">
                            <p class="mb-0 title">{{ $t('name') }}</p>
                            <p class="mb-0 fs-16 values">
                                {{
                                    customerDetails.billing_address && customerDetails.billing_address.name ? customerDetails.billing_address.name : '-'
                                }}
                            </p>
                        </div>
                        <div class="info mb-3">
                            <p class="mb-0 title">{{ $t('phone_number') }}</p>
                            <p class="mb-0 fs-16 values">
                                {{
                                    customerDetails.billing_address && customerDetails.billing_address.phone ? customerDetails.billing_address.phone : '-'
                                }}
                            </p>
                        </div>
                        <div class="info mb-3">
                            <p class="mb-0 title">{{ $t('address') }}</p>
                            <p class="mb-0 fs-16 values">
                                {{
                                    customerDetails.billing_address && customerDetails.billing_address.address ? customerDetails.billing_address.address : '-'
                                }}
                            </p>
                        </div>
                        <div class="info mb-3">
                            <p class="mb-0 title">{{ $t('city') }}</p>
                            <p class="mb-0 fs-16 values">
                                {{
                                    customerDetails.billing_address && customerDetails.billing_address.city ? customerDetails.billing_address.city : '-'
                                }}
                            </p>
                        </div>
                        <div class="info mb-3">
                            <p class="mb-0 title">{{ $t('state') }}</p>
                            <p class="mb-0 fs-16 values">
                                {{
                                    customerDetails.billing_address && customerDetails.billing_address.state ? customerDetails.billing_address.state : '-'
                                }}
                            </p>
                        </div>
                        <div class="info mb-3">
                            <p class="mb-0 title">{{ $t('zip_code') }}</p>
                            <p class="mb-0 fs-16 values">
                                {{
                                    customerDetails.billing_address && customerDetails.billing_address.zip_code ? customerDetails.billing_address.zip_code : '-'
                                }}
                            </p>
                        </div>
                        <div class="info mb-3">
                            <p class="mb-0 title">{{ $t('country') }}</p>
                            <p class="mb-0 fs-16 values">
                                {{
                                    customerDetails.billing_address && customerDetails.billing_address.country ? customerDetails.billing_address.country.name : '-'
                                }}
                            </p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-9">
                <div class="row">
                    <div class="col-md-4 col-sm-6">
                        <div class="report-card rounded-default mb-3">
                            <div class="title">{{numberWithCurrencySymbol(statisticsData.total_invoice_amount)}}</div>
                            <div class="sub-title">{{ $t('total_invoice_amount') }}</div>
                        </div>
                    </div>
                    <div class="col-md-4 col-sm-6">
                        <div class="report-card rounded-default mb-3">
                            <div class="title">{{ numberWithCurrencySymbol(statisticsData.total_paid_amount) }}</div>
                            <div class="sub-title">{{ $t('total_paid') }}</div>
                        </div>
                    </div>
                    <div class="col-md-4 col-sm-6">
                        <div class="report-card rounded-default mb-3">
                            <div class="title">{{numberWithCurrencySymbol(statisticsData.total_due_amount)}}</div>
                            <div class="sub-title">{{ $t('total_due') }}</div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <app-datatable :id="tableId" :options="options" @action="actionTiger"/>

                    </div>
                </div>
            </div>
        </div>

    </div>
</template>
<script setup>
import {ref, onMounted} from "vue"
import {useI18n} from 'vue-i18n';
import Axios from "@services/axios";
import {CUSTOMER_DETAILS, CUSTOMER_INVOICE_DETAILS} from "@services/endpoints/invoice";
import {urlGenerator} from "@utilities/urlGenerator";
import {formatDateToLocal, numberWithCurrencySymbol} from "@utilities/helpers";

const props = defineProps({
    id: {}
})
const tableId = ref('customer-invoice-table')
const {t} = useI18n();
const options = ref({
    url: `${CUSTOMER_INVOICE_DETAILS}/${props.id}`,
    pageSize: 5,
    rowLimit: 10,
    orderBy: 'desc',
    showGridView: false,
    actionType: 'dropdown',
    paginationType: 'pagination',
    enableRowSelect: false,
    enableBulkSelect: false,
    showSearch: false,
    showFilter: false,
    columns: [
        {
            title: t('invoice_number'),
            type: 'text',
            key: 'invoice_full_number'
        },
        {
            title: t('issue_date'),
            type: 'object',
            key: 'issue_date',
            modifier: (issue_date => formatDateToLocal(issue_date))
        },
        {
            title: t('due_date'),
            type: 'object',
            key: 'due_date',
            modifier: (due_date => formatDateToLocal(due_date))
        },

        {
            title: t('total'),
            type: 'object',
            key: 'grand_total',
            modifier: (total_amount => numberWithCurrencySymbol(total_amount)),
        },
        {
            title: t('paid'),
            type: 'object',
            key: 'received_amount',
            modifier: (total_amount => numberWithCurrencySymbol(total_amount)),
        },
        {
            title: t('due_amount'),
            type: 'object',
            key: 'due_amount',
            modifier: (due_amount => numberWithCurrencySymbol(due_amount)),
        },

        {
            title: t('status'),
            type: 'custom-html',
            key: 'status',
            modifier: (value) => {
                return `<span class="badge-square-fill bg-${value.class} mr-2">${value.translated_name}</span>`
            }
        },
    ],
})

const actionTiger = (row, action) => {
}

const customerDetails = ref({})
const statisticsData = ref({})
const getCustomerDetails = () => {
    Axios.get(`${CUSTOMER_DETAILS}/${props.id}`).then((response) => {
        customerDetails.value = response.data.customer_details
        statisticsData.value = response.data
    })

}
onMounted(() => {
    getCustomerDetails()
})

</script>
