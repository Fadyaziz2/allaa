<template>
    <app-datatable id="recent-estimate" :options="options" @action="actionTiger"/>
</template>

<script setup>
import {useI18n} from "vue-i18n";

const {t} = useI18n();
import {RECENT_ESTIMATE} from "@services/endpoints/invoice";
import {ref} from "vue";
import {numberWithCurrencySymbol} from "@utilities/helpers";

const options = ref({
    url: RECENT_ESTIMATE,
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
            title: t('estimate_number'),
            type: 'text',
            key: 'invoice_full_number',
        },
        {
            title: t('customer'),
            type: 'object',
            key: 'customer',
            modifier: (customer => customer ? customer.full_name : '-')
        },
        {
            title: t('total'),
            type: 'object',
            key: 'grand_total',
            modifier: (grand_total => numberWithCurrencySymbol(grand_total)),
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

