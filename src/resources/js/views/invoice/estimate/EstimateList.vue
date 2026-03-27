<template>
    <div class="content-wrapper">
        <app-breadcrumb :page-title="$t('estimate_list')">
            <template #breadcrumb-actions>
                <router-link v-if="canAccess('create_estimates')" to="create-quotation"
                             class="btn btn-primary text-white d-flex align-items-center">
                    {{ $t('add_estimate') }}
                </router-link>
            </template>
        </app-breadcrumb>

        <app-datatable :id="tableId" :options="options" @action="actionTiger"/>

        <app-delete-modal v-if="isDeleteModal" :table-id="tableId" :selected-url="deleteUrl" @cancelled="cancelled"/>

        <conformation-modal v-if="isConformationModal"
                            modal-id="estimateConfirmModal"
                            :message="$t('estimate_to_invoice_convert')"
                            :preloader="confirmLoader"
                            @cancel="cancel"
                            @confirm="confirmEstimateToInvoice"/>

        <conformation-modal v-if="isConformationResendModal"
                            modal-id="estimateResendConfirmModal"
                            icon="bi bi-envelope-at"
                            :message="$t('estimate_re_send_customer_mail')"
                            :preloader="confirmLoader"
                            @cancel="cancelEstimateResendModal"
                            @confirm="confirmEstimateResendMail"/>

    </div>
</template>

<script setup>

import {markRaw, ref} from "vue";
import {
    DOWNLOAD_ESTIMATE, DOWNLOAD_INVOICE,
    ESTIMATES,
    ESTIMATES_RESEND_MAIL, ESTIMATES_STATUS_CHANGE,
    ESTIMATES_TO_INVOICE_CONVERT,
    SELECTED_CUSTOMER
} from "@services/endpoints/invoice";
import {formatDateToLocal, numberWithCurrencySymbol} from "@utilities/helpers";
import {useI18n} from "vue-i18n";
import {useDeleteModal} from "@/core/global/composable/modal/useDeleteModal";
import router from "@router";
import Axios from "@services/axios";
import ConformationModal from "@/invoice/common/modal/ConformationModal.vue"
import {useToast} from "vue-toastification";
import useEmitter from "@/core/global/composable/useEmitter";
import {Modal} from "bootstrap";
import usePermission from '@/core/global/composable/usePermission';
import InvoiceNumber from "@/invoice/common/component/InvoiceNumber.vue";

const {canAccess} = usePermission();

const {t} = useI18n();
const tableId = ref('estimate-table')

const options = ref({
    url: ESTIMATES,
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
            title: t('estimate_number'),
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
            title: t('status'),
            type: 'custom-html',
            key: 'status',
            modifier: (value) => {
                return `<span class="badge-square-fill bg-${value.class} mr-2">${value.translated_name}</span>`
            }
        },
        {
            title: t('date'),
            type: 'object',
            key: 'date',
            modifier: (date => formatDateToLocal(date))
        },
        {
            title: t('total'),
            type: 'object',
            key: 'grand_total',
            modifier: (grand_total => numberWithCurrencySymbol(grand_total)),
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
            options: [{id: 6, name: t('status_pending')}, {id: 7, name: t('status_approved')}, {
                id: 8,
                name: t('status_reject')
            }],
            listKeyField: 'id',
            listValueField: 'name',
            showSearch: false,
            permission: canAccess('manage_global_access'),
        },
        {
            label: t('date'),
            type: 'date-range',
            key: 'date',
            placeholder: t('date'),
            permission: canAccess('manage_global_access'),
        },
    ],
    actions: [
        {
            title: t('edit'),
            type: 'edit',
            icon: 'bi bi-pencil-square',
            modifier: () => canAccess("update_estimates"),
        },
        {
            title: t('re_send'),
            type: 're_send',
            icon: 'bi bi-send',
            modifier: () => canAccess("resend_mail_estimate"),
        },
        {
            title: t('estimate_details'),
            type: 'estimate_details',
            icon: 'bi bi-file-earmark-pdf-fill',
            modifier: () => canAccess("download_estimate"),
        },
        {
            title: t('thermal_estimate'),
            type: 'thermal_estimate',
            icon: 'bi bi-printer-fill',
            modifier: () => canAccess("thermal_estimate"),
        },
        {
            title: t('convert_to_invoice'),
            type: 'convert_to_invoice',
            icon: 'bi bi-c-circle',
            modifier: () => canAccess("invoice_convert_estimate"),
        },
        {
            title: t('status_approved'),
            type: 'status_approved',
            icon: 'bi bi-check-circle',
            modifier: (row => canAccess('status_change_estimate') && row.status.name === "status_pending")

        }, {
            title: t('status_reject'),
            type: 'status_reject',
            icon: 'bi bi-x-circle',
            modifier: (row => canAccess('status_change_estimate') && row.status.name === "status_pending")
        },
        {
            title: t('download_estimate'),
            type: 'download_estimate',
            icon: 'bi bi-download',
            modifier: () => canAccess("download_estimate"),
        },
        {
            title: t('delete'),
            type: 'delete',
            icon: 'bi bi-trash3',
            modifier: () => canAccess("delete_estimates"),
        }
    ],
})

const {deleteUrl, isDeleteModal, cancelled} = useDeleteModal()

const isConformationModal = ref(false)
const estimateToInvoiceData = ref(null)
const isConformationResendModal = ref(false)
const estimateMailData = ref(false)
const actionTiger = (row, action) => {

    if (action.type === 'edit') {
        router.push(`/edit/${row.id}/quotation`);
    } else if (action.type === 'delete') {
        isDeleteModal.value = true
        deleteUrl.value = `${ESTIMATES}/${row.id}`
    }
    else if (action.type === 'thermal_estimate') {
        window.location.href = `/thermal-estimate/${row.id}`
    }
    else if (action.type === 'convert_to_invoice') {
        isConformationModal.value = true
        estimateToInvoiceData.value = row.id
    } else if (action.type === 're_send') {
        isConformationResendModal.value = true
        estimateMailData.value = row.id
    } else if (action.type === 'status_approved') {
        manageStatus(action.type, row)
    } else if (action.type === 'status_reject') {
        manageStatus(action.type, row)
    } else if (action.type === 'download_estimate') {
        Axios.get(`${DOWNLOAD_ESTIMATE}/${row.id}`, {responseType: 'arraybuffer'}).then(response => {
            const blob = new Blob([response.data], {type: 'application/pdf'});
            const link = document.createElement('a');
            link.href = window.URL.createObjectURL(blob);
            link.download = `quotation_${row.invoice_full_number}.pdf`;
            link.click();
        }).catch(error => {
            toast.error("Quotation download failed. Please try again later.");
        });

    } else if (action.type === 'estimate_details') {
        router.push(`/quotation/${row.id}/details`);
    }
}
const confirmLoader = ref(false)
const toast = useToast();
const emitter = useEmitter();
const confirmEstimateToInvoice = () => {
    confirmLoader.value = true
    Axios.get(`${ESTIMATES_TO_INVOICE_CONVERT}/${estimateToInvoiceData.value}`).then((response) => {
        toast.success(response.data.message);
        emitter.emit('reload-' + tableId.value);
        cancel()
    }).catch(({response}) => {
        if (response?.data?.message) toast.error(response.data.message);
    }).finally(() => confirmLoader.value = false)
}

const cancel = () => {
    let modal = Modal.getInstance(document.getElementById('estimateConfirmModal'));
    modal.hide();
    isConformationModal.value = false
    estimateToInvoiceData.value = null
}

const confirmEstimateResendMail = () => {
    confirmLoader.value = true
    Axios.get(`${ESTIMATES_RESEND_MAIL}/${estimateMailData.value}`).then((response) => {
        toast.success(response.data.message);
        emitter.emit('reload-' + tableId.value);
        cancelEstimateResendModal()
    }).catch(({response}) => {
        if (response?.data?.message) toast.error(response.data.message);
    }).finally(() => confirmLoader.value = false)
}

const cancelEstimateResendModal = () => {
    let modal = Modal.getInstance(document.getElementById('estimateResendConfirmModal'));
    modal.hide();
    isConformationResendModal.value = false
    estimateMailData.value = null
}

const manageStatus = (status, row) => {
    Axios.patch(`${ESTIMATES_STATUS_CHANGE}/${row.id}`, {
        'status': status
    }).then(({data}) => {
        toast.success(data.message);
        emitter.emit('reload-' + tableId.value);
    }).catch(({response}) => {
        if (response?.data?.message) toast.error(response.data.message);
    })
}
</script>


