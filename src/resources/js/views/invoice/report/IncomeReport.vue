<template>
    <div class="content-wrapper">
        <app-breadcrumb :page-title="$t('income_report')"></app-breadcrumb>

        <app-datatable :id="tableId" :options="options"/>

    </div>
</template>

<script setup>
import {ref} from "vue";
import {useI18n} from "vue-i18n";
import {
    SELECTED_CUSTOMER,
    INCOME_REPORT,
} from "@services/endpoints/invoice";
import {formatDateToLocal, numberWithCurrencySymbol} from "@utilities/helpers";
import usePermission from "@/core/global/composable/usePermission";

const {canAccess} = usePermission();
const {t} = useI18n();

const tableId = ref('income-report-table')

const options = ref({
    url: INCOME_REPORT,
    pageSize: 5,
    rowLimit: 10,
    orderBy: 'desc',
    showGridView: false,
    actionType: 'dropdown',
    paginationType: 'pagination',
    enableRowSelect: false,
    enableBulkSelect: false,
    showSearch: true,
    showFilter: canAccess('manage_global_access'),
    columns: [
        {
            title: t('invoice_number'),
            type: 'text',
            key: 'invoice_full_number',
        },
        {
            title: t('customer'),
            type: 'object',
            key: 'customer',
            modifier: (value => value ? value.full_name : '')
        },
        {
            title: t('issue_date'),
            type: 'object',
            key: 'issue_date',
            modifier: (date => formatDateToLocal(date))
        },
        {
            title: t('amount'),
            type: 'object',
            key: 'received_amount',
            accountAble : true,
            modifier: (amount => numberWithCurrencySymbol(amount))
        },
    ],
    filters: [
        {
            label: t('customer'),
            type: 'advance-search-select',
            key: 'customer',
            listKeyField: 'id',
            listValueField: 'full_name',
            rowPerLoad: 10,
            fetchUrl: `${SELECTED_CUSTOMER}`,
            permission: true,
        },
        {
            label: t('issue_date'),
            type: 'date-range',
            key: 'issue_date',
            placeholder: t('issue_date'),
            permission: true,
        }

    ],
    actions: [],
})

</script>
