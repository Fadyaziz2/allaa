<template>
    <div class="content-wrapper">
        <app-breadcrumb :page-title="$t('payment_report')"></app-breadcrumb>

        <app-datatable :id="tableId" :options="options"/>

    </div>
</template>

<script setup>
import {ref} from "vue";
import {useI18n} from "vue-i18n";
import {
    EXPENSES_EXPORT,
    PAYMENT_EXPORT,
    PAYMENT_REPORT,
    SELECTED_CUSTOMER,
    SELECTED_PAYMENT_METHOD
} from "@services/endpoints/invoice";
import {formatDateToLocal, numberWithCurrencySymbol} from "@utilities/helpers";
import usePermission from "@/core/global/composable/usePermission";
import Axios from "@services/axios";

const {canAccess} = usePermission();
const {t} = useI18n();

const tableId = ref('payment-report-table')

const options = ref({
    url: PAYMENT_REPORT,
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
    exportPermission: canAccess('payment_export'),
    exportData: () => paymentExport(),
    columns: [
        {
            title: t('payment_number'),
            type: 'text',
            key: 'invoice_full_number',
        },
        {
            title: t('payment_date'),
            type: 'object',
            key: 'received_on',
            modifier: (date => formatDateToLocal(date))
        },
        {
            title: t('customer_name'),
            type: 'object',
            key: 'customer',
            modifier: (customer => customer ? customer.full_name : ''),
            permission: canAccess('manage_global_access'),
        },
        {
            title: t('reference_invoice_number'),
            type: 'object',
            key: 'invoice',
            modifier: (invoice => invoice ? invoice.invoice_full_number : '-')
        },

        {
            title: t('payment_method'),
            type: 'object',
            key: 'payment_method',
            modifier: (payment_method => payment_method ? payment_method.name : '')
        },
        {
            title: t('amount'),
            type: 'object',
            key: 'amount',
            accountAble: true,
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
            permission: canAccess('manage_global_access'),
        },
        {
            label: t('payment_method'),
            type: 'advance-search-select',
            key: 'payment_method',
            listKeyField: 'id',
            listValueField: 'name',
            rowPerLoad: 10,
            fetchUrl: `${SELECTED_PAYMENT_METHOD}`,
            permission: canAccess('manage_global_access'),
        },
        {
            label: t('date'),
            type: 'date-range',
            key: 'date',
            placeholder: t('select_a_range'),
            permission: canAccess('manage_global_access'),
        },

    ],
    actions: [],
})

const paymentExport = () => {
    Axios.get(PAYMENT_EXPORT, {responseType: 'arraybuffer'}).then((response) => {
        let fileURL = window.URL.createObjectURL(new Blob([response.data]));
        let fileLink = document.createElement('a');
        fileLink.href = fileURL;
        fileLink.setAttribute('download', 'payment_export.xlsx');
        document.body.appendChild(fileLink);
        fileLink.click();
    })
}
</script>


