<template>
    <app-datatable id="recent-invoice" :options="options" @action="actionTiger"/>
</template>

<script setup>
import {RECENT_EXPENSES} from "@services/endpoints/invoice";
import {ref} from "vue";
import {useI18n} from "vue-i18n";
import {formatDateToLocal, numberWithCurrencySymbol} from "@utilities/helpers";

const {t} = useI18n();
const options = ref({
    url: RECENT_EXPENSES,
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
            title: t('title'),
            type: 'text',
            key: 'title',
        },
        {
            title: t('date'),
            type: 'object',
            key: 'date',
            modifier: (date => formatDateToLocal(date))
        },
        {
            title: t('amount'),
            type: 'object',
            key: 'amount',
            modifier: (amount => numberWithCurrencySymbol(amount))
        },
        {
            title: t('reference'),
            type: 'text',
            key: 'reference',
        },

    ],
    actions: [],
})

const actionTiger = (row, action) => {

}
</script>

