<template>
    <div class="content-wrapper">
        <app-breadcrumb :page-title="$t('recurring_invoices')">
        </app-breadcrumb>

        <app-datatable :id="tableId" :options="options" @action="actionTiger"/>

        <admin-invoice-due-payment-modal
            v-if="isModalActive"
            :table-id="tableId"
            modal-id="admin-invoice-due-modal"
            :invoice-data="invoiceInfo"
            @close="closeModal"
        />

        <customer-invoice-due-payment-modal
            v-if="isCustomerPaymentModalActive"
            :table-id="tableId"
            modal-id="customer-invoice-due-modal"
            :invoice-data="invoiceInfo"
            @close="closeCustomerDueModal"
        />

        <app-delete-modal
            v-if="cloneInvoiceConfirmModal"
            modal-id="clone-invoice-confirm-modal"
            modal-class="text-success"
            icon="bi bi-c-circle"
            :title="$t('are_you_sure')"
            :message="$t('this_invoice_will_be_cloned_into_a_new_invoice')"
            :show-footer="false"
            :table-id="tableId"
            :selected-url="deleteUrl"
        >
            <template v-slot:footer>
                <a
                    href="#"
                    class="btn btn-primary-outline me-2 fw-bold d-inline-flex align-items-center"
                    data-dismiss="modal"
                    @click.prevent="cancelInvoiceCloneModal"
                >
                    {{ $t("cancel") }}
                </a>
                <a
                    href="#"
                    class="btn btn-primary fw-bold d-inline-flex align-items-center"
                    data-dismiss="modal"
                    @click.prevent="confirmInvoiceClone"
                >
                    <app-button-loader v-if="preloader"/>
                    <i class="bi-download me-1"></i> {{ $t("yes") }}
                </a>
            </template>
        </app-delete-modal>
    </div>
</template>

<script setup>
import {useI18n} from "vue-i18n";
import {ref} from "vue";
import {
    CLONE_INVOICE,
    DOWNLOAD_INVOICE,
    INVOICES,
    RECURRING_INVOICES,
    SELECTED_CUSTOMER,
    SEND_INVOICE_ATTACHMENT,
} from "@services/endpoints/invoice";
import {
    formatDateToLocal,
    numberWithCurrencySymbol,
} from "@utilities/helpers";
import {useOpenModal} from "@/core/global/composable/modal/useOpenModal";
import AdminInvoiceDuePaymentModal from "@/invoice/Invoice/AdminInvoiceDuePaymentModal.vue";
import CustomerInvoiceDuePaymentModal from "@/invoice/Invoice/CustomerInvoiceDuePaymentModal.vue";
import router from "@router";
import Axios from "@services/axios";
import {useToast} from "vue-toastification";
import useEmitter from "@/core/global/composable/useEmitter";
import {Modal} from "bootstrap";
import {urlGenerator} from "@utilities/urlGenerator";
import {canAccess} from "@utilities/permission";

const {t} = useI18n();
const tableId = ref("invoice-table");
const options = ref({
    url: RECURRING_INVOICES,
    pageSize: 5,
    rowLimit: 10,
    orderBy: "desc",
    showGridView: false,
    actionType: "dropdown",
    paginationType: "pagination",
    enableRowSelect: false,
    enableBulkSelect: false,
    showSearch: true,
    showFilter: canAccess("manage_global_access"),
    columns: [
        {
            title: t("invoice_number"),
            type: "text",
            key: "invoice_full_number",
        },
        {
            title: t("customer"),
            type: "object",
            key: "customer",
            modifier: (customer) => (customer ? customer.full_name : "-"),
            permission: canAccess('manage_global_access'),
        },
        {
            title: t("issue_date"),
            type: "object",
            key: "issue_date",
            modifier: (issue_date) => formatDateToLocal(issue_date),
        },
        {
            title: t("due_date"),
            type: "object",
            key: "due_date",
            modifier: (due_date) => formatDateToLocal(due_date),
        },
        {
            title: t("cycle"),
            type: "object",
            key: "recurring_type",
            modifier: (recurringType) => recurringType ? recurringType.original_name : "-",
        },

        {
            title: t("total"),
            type: "object",
            key: "grand_total",
            modifier: (total_amount) => numberWithCurrencySymbol(total_amount),
        },
        {
            title: t("paid"),
            type: "object",
            key: "received_amount",
            modifier: (total_amount) => numberWithCurrencySymbol(total_amount),
        },
        {
            title: t("due"),
            type: "object",
            key: "due_amount",
            modifier: (total_amount) => numberWithCurrencySymbol(total_amount),
        },
        {
            title: t("status"),
            type: "custom-html",
            key: "status",
            modifier: (value) => {
                return `<span class="badge-square-fill bg-${value.class} mr-2">${value.translated_name}</span>`;
            },
        },
        {
            title: t("action"),
            type: "action",
            align: "right",
        },
    ],
    filters: [
        {
            label: t("customer"),
            type: "advance-search-select",
            key: "customer",
            listKeyField: "id",
            listValueField: "full_name",
            rowPerLoad: 10,
            fetchUrl: `${SELECTED_CUSTOMER}`,
            permission: canAccess("manage_global_access"),
        },
        {
            label: t("status"),
            type: "search-select",
            key: "status",
            options: [
                {id: 4, name: "Paid"},
                {id: 5, name: "Due"},
            ],
            listKeyField: "id",
            listValueField: "name",
            showSearch: false,
            permission: canAccess("manage_global_access"),
        },
    ],
    actions: [
        {
            title: t("payment"),
            type: "admin_payment",
            icon: "bi bi-credit-card-2-front-fill",
            modifier: () => canAccess("due_payment_invoice"),
        },
        {
            title: t('payment'),
            type: 'customer_payment',
            icon: 'bi bi-credit-card-2-front-fill',
            modifier: () => canAccess('customer_due_invoice_payment')
        },
        {
            title: t("re_send"),
            type: "re_send",
            icon: "bi bi-arrow-up",
            modifier: () => canAccess("send_attachment_invoice"),
        },
        {
            title: t("clone_invoice"),
            type: "clone_invoice",
            icon: "bi bi-c-circle",
            modifier: () => canAccess("manage_invoice_clone"),
        },
        {
            title: t("download_invoice"),
            type: "download_invoice",
            icon: "bi bi-download",
        },
        {
            title: t("delete"),
            type: "delete",
            icon: "bi bi-trash3",
            modifier: () => canAccess("delete_invoices"),
        },
    ],
});

const invoiceInfo = ref({});
const cloneInvoiceConfirmModal = ref(false);
const actionTiger = (row, action) => {
    if (action.type === "delete") {
        isDeleteModal.value = true;
        deleteUrl.value = `${INVOICES}/${row.id}`;
    } else if (action.type === "admin_payment") {
        isModalActive.value = true;
        invoiceInfo.value = row;
    } else if (action.type === "customer_payment") {
        isCustomerPaymentModalActive.value = true;
        invoiceInfo.value = row;
    } else if (action.type === "clone_invoice") {
        cloneInvoiceConfirmModal.value = true;
        invoiceInfo.value = row;
    } else if (action.type === "download_invoice") {
        window.open(urlGenerator(`${DOWNLOAD_INVOICE}/${row.id}`));
    } else if (action.type === "re_send") {
        reSendInvoice(row);
    }
};

const preloader = ref(false);
const toast = useToast();
const emitter = useEmitter();
const confirmInvoiceClone = () => {
    preloader.value = true;
    Axios.post(`${CLONE_INVOICE}/${invoiceInfo.value.id}`, {
        recurring: 1
    })
        .then((response) => {
            toast.success(response?.data?.message);
            cancelInvoiceCloneModal();
            setTimeout(() => {
                router.push(`/edit/${response.data?.data?.id}/invoice`);
            });
        })
        .finally(() => (preloader.value = false));
};

const cancelInvoiceCloneModal = () => {
    cloneInvoiceConfirmModal.value = false;
    let modal = Modal.getInstance(
        document.getElementById("clone-invoice-confirm-modal")
    );
    modal.hide();
    invoiceInfo.value = {};
};

const reSendInvoice = (row) => {
    Axios.post(`${SEND_INVOICE_ATTACHMENT}/${row.id}`)
        .then(({data}) => {
            toast.success(data?.message);
        })
        .catch(({response}) => {
            if (response.status === 422) errors.value = response?.data?.errors;
            else {
                toast.error(response?.data?.message);
            }
        });
};

const {isModalActive, selectedData, closeModal} = useOpenModal();

const isCustomerPaymentModalActive = ref(false);
const closeCustomerDueModal = () => {
    isCustomerPaymentModalActive.value = false;
    invoiceInfo.value = {};
};
</script>
