<template>
    <div class="content-wrapper">
        <app-breadcrumb :page-title="$t('expense_report')"></app-breadcrumb>

        <app-datatable :id="tableId" :options="options"/>

    </div>
</template>

<script setup>
import {ref} from "vue";
import {useI18n} from "vue-i18n";
import {
    CATEGORIES,
    EXPENSE_REPORT,
    EXPENSES_EXPORT,
} from "@services/endpoints/invoice";
import {formatDateToLocal, numberWithCurrencySymbol} from "@utilities/helpers";
import usePermission from "@/core/global/composable/usePermission";
import {value} from "lodash/seq";
import {it} from "date-fns/locale";

const {canAccess} = usePermission();
const {t} = useI18n();

const tableId = ref('expense-report-table')

const options = ref({
    url: EXPENSE_REPORT,
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
            title: t('name'),
            type: 'text',
            key: 'title',
        },
        {
            title: t('category'),
            type: 'object',
            key: 'category',
            modifier: (value => value ? value.name : '')
        },
        {
            title: t('issue_date'),
            type: 'object',
            key: 'date',
            modifier: (date => formatDateToLocal(date))
        },
        {
            title: t('amount'),
            type: 'object',
            key: 'amount',
            accountAble : true,
            modifier: (amount => numberWithCurrencySymbol(amount))
        },
    ],
    filters: [
        {
            label: t('category'),
            type: 'advance-search-select',
            key: 'category',
            listKeyField: 'id',
            listValueField: 'name',
            rowPerLoad: 10,
            fetchUrl: `${CATEGORIES}?type=expense`,
            permission: true,
        },
        {
            label: t('date'),
            type: 'date-range',
            key: 'date',
            placeholder: t('select_a_range'),
            permission: true,
        },

    ],
    actions: [],
})

</script>
