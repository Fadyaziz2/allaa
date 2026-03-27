<template>
    <div class="content-wrapper">
        <app-breadcrumb :page-title="$t('invoice_list')">
            <template #breadcrumb-actions>
                <router-link v-if="canAccess('create_invoices')" to="create-invoice"
                             class="btn btn-primary text-white d-flex align-items-center">
                    {{ $t('add_invoice') }}
                </router-link>
            </template>
        </app-breadcrumb>

        <app-datatable :id="tableId" :options="options" @action="actionTiger"/>

        <app-delete-modal v-if="isDeleteModal" :table-id="tableId" :selected-url="deleteUrl" @cancelled="cancelled"/>

        <admin-invoice-due-payment-modal v-if="isModalActive" :table-id="tableId" modal-id="admin-invoice-due-modal"
                                         :invoice-data="invoiceInfo" @close="closeModal"/>

        <customer-invoice-due-payment-modal v-if="isCustomerPaymentModalActive" :table-id="tableId"
                                            modal-id="customer-invoice-due-modal" :invoice-data="invoiceInfo"
                                            @close="closeCustomerDueModal"/>


        <conformation-modal v-if="cloneInvoiceConfirmModal"
                            modal-id="clone-invoice-confirm-modal"
                            modal-class="text-success"
                            icon="bi bi-c-circle"
                            :title="$t('are_you_sure')"
                            :message="$t('this_invoice_will_be_cloned_into_a_new_invoice')"
                            :table-id="tableId"
                            :preloader="preloader"
                            @cancel="cancelInvoiceCloneModal"
                            @confirm="confirmInvoiceClone"/>

        <conformation-modal v-if="reSendInvoiceModal"
                            modal-id="resend-invoice-confirm-modal"
                            modal-class="text-success"
                            icon="bi bi-envelope-check"
                            :title="$t('are_you_sure')"
                            :message="$t('send_invoice_attachment_to_the_customer_email')"
                            :table-id="tableId"
                            :preloader="preloader"
                            @cancel="cancelResendModal"
                            @confirm="reSendInvoice"/>

    </div>
</template>

<script setup>
import {useI18n} from "vue-i18n";
import {markRaw, onMounted, ref} from "vue";
import {
    CLONE_INVOICE,
    DOWNLOAD_INVOICE,
    INVOICES,
    SELECTED_CUSTOMER, SEND_INVOICE_ATTACHMENT
} from "@services/endpoints/invoice";
import {formatDateToLocal, numberWithCurrencySymbol} from "@utilities/helpers";
import {useDeleteModal} from "@/core/global/composable/modal/useDeleteModal";
import {useOpenModal} from "@/core/global/composable/modal/useOpenModal";
import AdminInvoiceDuePaymentModal from "@/invoice/Invoice/AdminInvoiceDuePaymentModal.vue";
import CustomerInvoiceDuePaymentModal from "@/invoice/Invoice/CustomerInvoiceDuePaymentModal.vue";
import ConformationModal from "@/invoice/common/modal/ConformationModal.vue";
import router from "@router";
import Axios from "@services/axios";
import {useToast} from "vue-toastification";
import useEmitter from "@/core/global/composable/useEmitter";
import {Modal} from "bootstrap";
import usePermission from '@/core/global/composable/usePermission';
const {canAccess} = usePermission();
import {useRoute} from "vue-router";
import InvoiceNumber from "@/invoice/common/component/InvoiceNumber.vue";

const {t} = useI18n();

const tableId = ref('invoice-table')

const options = ref({
    url: INVOICES,
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
            type: 'component',
            key: 'id',
            componentName : markRaw(InvoiceNumber)
        },
        {
            title: t('customer'),
            type: 'object',
            key: 'customer',
            modifier: (customer => customer ? customer.full_name : '-'),
            permission: canAccess('manage_global_access'),
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
        }, {
            title: t('recurring_cycle'),
            type: 'object',
            key: 'recurring_type',
            modifier: (recurringType => recurringType ? recurringType.original_name : '-'),
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
            title: t('due'),
            type: 'object',
            key: 'due_amount',
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
        {
            title: t('action'),
            type: 'action',
            align: 'right'
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
            label: t('status'),
            type: 'search-select',
            key: 'status',
            options: [{id: 4, name: t('status_paid')}, {id: 5, name: t('status_due')}],
            listKeyField: 'id',
            listValueField: 'name',
            showSearch: false,
            permission: canAccess('manage_global_access'),
        },
        {
            label: t('issue_date'),
            type: 'date-range',
            key: 'issue_date',
            placeholder: t('issue_date'),
            permission: canAccess('manage_global_access'),
        }, {
            label: t('due_date'),
            type: 'date-range',
            key: 'due_date',
            placeholder: t('due_date'),
            permission: canAccess('manage_global_access'),
        },
    ],
    actions: [
        {
            title: t('create_payment'),
            type: 'admin_payment',
            icon: 'bi bi-credit-card-2-front-fill',
            modifier: (row => !!(row.status && row.status.name === 'status_due' && canAccess("due_payment_invoice") && canAccess('manage_global_access'))),
        },
        {
            title: t('payment'),
            type: 'customer_payment',
            icon: 'bi bi-credit-card-2-front-fill',
            modifier: (row => !!(row.status && row.status.name === 'status_due' && canAccess('customer_due_invoice_payment') && !canAccess('manage_global_access'))),

        },
        {
            title: t('edit'),
            type: 'edit',
            icon: 'bi bi-pencil-square',
            modifier: () => canAccess("update_invoices"),
        },
        {
            title: t('invoice_details'),
            type: 'invoice_details',
            icon: 'bi bi-file-earmark-pdf-fill',
            modifier: () => canAccess("download_invoice"),
        },
        {
            title: t('thermal_invoice'),
            type: 'thermal_invoice',
            icon: 'bi bi-printer-fill',
            modifier: () => canAccess("thermal_invoice"),
        },
        {
            title: t('re_send'),
            type: 're_send',
            icon: 'bi bi-arrow-up',
            modifier: () => canAccess("send_attachment_invoice"),
        },
        {
            title: t('clone_invoice'),
            type: 'clone_invoice',
            icon: 'bi bi-c-circle',
            modifier: () => canAccess("manage_invoice_clone"),
        },
        {
            title: t('download_invoice'),
            type: 'download_invoice',
            icon: 'bi bi-download',
            modifier: () => canAccess("download_invoice"),
        },
        {
            title: t('delete'),
            type: 'delete',
            icon: 'bi bi-trash3',
            modifier: () => canAccess("delete_invoices"),
        }
    ],
})

const invoiceInfo = ref({})
const cloneInvoiceConfirmModal = ref(false)
const toast = useToast()
const actionTiger = (row, action) => {
    if (action.type === 'edit') {
        router.push(`/edit/${row.id}/invoice`);
    } else if (action.type === 'delete') {
        isDeleteModal.value = true
        deleteUrl.value = `${INVOICES}/${row.id}`
    } else if (action.type === 'admin_payment') {
        isModalActive.value = true
        invoiceInfo.value = row
    } else if (action.type === 'customer_payment') {
        isCustomerPaymentModalActive.value = true
        invoiceInfo.value = row
    } else if (action.type === 'clone_invoice') {
        cloneInvoiceConfirmModal.value = true
        invoiceInfo.value = row
    } else if (action.type === 'download_invoice') {
        Axios.get(`${DOWNLOAD_INVOICE}/${row.id}`, {responseType: 'arraybuffer'}).then(response => {
            const blob = new Blob([response.data], {type: 'application/pdf'});
            const link = document.createElement('a');
            link.href = window.URL.createObjectURL(blob);
            link.download = `invoice_${row.invoice_full_number}.pdf`;
            link.click();
        }).catch(error => {
            toast.error("Invoice download failed. Please try again later.");
        });
    } else if (action.type === 'invoice_details') {
        router.push(`/invoice/${row.id}/details`);
    }
    else if (action.type === 'thermal_invoice') {
       window.location.href = `/thermal-invoice/${row.id}`
    }
    else if (action.type === 're_send') {
        reSendInvoiceModal.value = true
        invoiceInfo.value = row
    }
}

const preloader = ref(false)
const emitter = useEmitter();
const confirmInvoiceClone = () => {
    preloader.value = true
    Axios.post(`${CLONE_INVOICE}/${invoiceInfo.value.id}`).then((response) => {
        toast.success(response?.data?.message);
        cancelInvoiceCloneModal()
        setTimeout(() => {
            router.push(`/edit/${response.data?.data?.id}/invoice`);
        })
    }).catch(({response}) => {
        toast.error(response?.data?.message);
    }).finally(() => preloader.value = false)
}

const cancelInvoiceCloneModal = () => {
    cloneInvoiceConfirmModal.value = false
    let modal = Modal.getInstance(document.getElementById('clone-invoice-confirm-modal'));
    modal.hide();
    invoiceInfo.value = {}
}

const reSendInvoiceModal = ref(false)
const reSendInvoice = () => {
    preloader.value = true
    Axios.post(`${SEND_INVOICE_ATTACHMENT}/${invoiceInfo.value?.id}`).then(({data}) => {
        toast.success(data?.message);
        cancelResendModal()
    }).catch(({response}) => {
        if (response.status === 422)
            errors.value = response?.data?.errors;
        else {
            toast.error(response?.data?.message);
        }
    }).finally(() => preloader.value = false)
}

const cancelResendModal = () => {
    cloneInvoiceConfirmModal.value = false
    let modal = Modal.getInstance(document.getElementById('resend-invoice-confirm-modal'));
    modal.hide();
    invoiceInfo.value = {}
}

const {isModalActive, selectedData, closeModal} = useOpenModal()
const {deleteUrl, isDeleteModal, cancelled} = useDeleteModal()

const isCustomerPaymentModalActive = ref(false)
const closeCustomerDueModal = () => {
    isCustomerPaymentModalActive.value = false
    invoiceInfo.value = {}
}
const route = useRoute();
onMounted(() => {
    if (route.query.payment === 'success') {
        toast.success(t('payment_has_been_successful'));
        router.replace({query: {page: 1, per_page: 10}})
    }

    if (route.query.payment === 'cancel') {
        toast.warning(t('payment_has_been_cancelled'));
        router.replace({query: {page: 1, per_page: 10}})
    }
    if (route.query.payment === 'error') {
        toast.error(t('payment_has_been_failed'));
        router.replace({query: {page: 1, per_page: 10}})
    }


})


</script>

