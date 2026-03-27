<template>
    <app-datatable id="recent-invoice" :options="options" @action="actionTiger"/>
</template>

<script setup>
import {RECENT_TRANSACTION} from "@services/endpoints/invoice";
import {ref} from "vue";
import {useI18n} from "vue-i18n";
import {formatDateToLocal, numberWithCurrencySymbol} from "@utilities/helpers";

const {t} = useI18n();
const options = ref({
    url: RECENT_TRANSACTION,
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
    showPagination: false,
    showAction: false,
    columns: [
        {
            title: t('number'),
            type: 'text',
            key: 'invoice_full_number',
        },
        {
            title: t('amount'),
            type: 'object',
            key: 'amount',
            modifier: (amount => numberWithCurrencySymbol(amount))
        },
        {
            title: t('received_on'),
            type: 'object',
            key: 'received_on',
            modifier: (date => formatDateToLocal(date))
        },
        {
            title: t('customer'),
            type: 'object',
            key: 'customer',
            modifier: (customer => customer ? customer.full_name : ''),
        },
        {
            title: t('payment_method'),
            type: 'object',
            key: 'payment_method',
            modifier: (payment_method => payment_method ? payment_method.name : '')
        },

    ],
    actions: [],
})

const actionTiger = (row, action) => {

}
</script>

