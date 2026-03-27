<template>
    <app-datatable id="recent-invoice" :options="options" @action="actionTiger"/>
</template>

<script setup>
import {RECENT_INVOICE} from "@services/endpoints/invoice";
import {ref} from "vue";
import {useI18n} from "vue-i18n";
import {formatDateToLocal, numberWithCurrencySymbol} from "@utilities/helpers";

const {t} = useI18n();
const options = ref({
    url: RECENT_INVOICE,
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
            title: t('invoice_number'),
            type: 'text',
            key: 'invoice_number',
        },
        {
            title: t('customer'),
            type: 'object',
            key: 'customer',
            modifier: (customer => customer ? customer.full_name : '-')
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
        },{
            title: t('total'),
            type: 'object',
            key: 'grand_total',
            modifier: (total_amount => numberWithCurrencySymbol(total_amount)),
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
    actions: [],
})

const actionTiger = (row, action) => {

}
</script>

