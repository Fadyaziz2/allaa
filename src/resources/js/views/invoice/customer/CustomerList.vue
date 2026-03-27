<template>
    <div class="content-wrapper">
        <app-breadcrumb :page-title="$t('customers')">
            <template #breadcrumb-actions>
                <button v-if="canAccess('create_customers')" @click.prevent="isModalActive = true"
                        class="btn btn-primary text-white">
                    {{ $t('add_customer') }}
                </button>
            </template>
        </app-breadcrumb>

        <app-datatable :id="tableId" :options="options" @action="actionTiger"/>

        <customer-modal v-if="isModalActive" :table-id="tableId" modal-id="customer-modal" :selected-url="selectedData"
                        @close="closeModal"/>

        <app-delete-modal v-if="isDeleteModal" :table-id="tableId" :selected-url="deleteUrl" @cancelled="cancelled"/>


        <conformation-modal v-if="resendPortalAccessModal"
                            modal-id="customerResendMail"
                            modal-class="text-success"
                            icon="bi bi-envelope-at-fill"
                            :title="$t('are_you_sure_you_want_to_send_customer_portal_access')"
                            :table-id="tableId"
                            :preloader="preloader"
                            :first-button-name="$t('send')"
                            :second-button-name="$t('cancel')"
                            @cancel="closePortalAccessModal"
                            @confirm="confirmSend"/>

    </div>
</template>

<script setup>
import {markRaw, ref} from "vue";
import {useI18n} from "vue-i18n";
import {CUSTOMER_EXPORT, CUSTOMERS, RE_SEND_CUSTOMER_PORTAL_ACCESS} from "@services/endpoints/invoice";
import CustomerModal from "@/invoice/customer/CustomerModal.vue";
import {useOpenModal} from "@/core/global/composable/modal/useOpenModal";
import {useDeleteModal} from "@/core/global/composable/modal/useDeleteModal";
import Axios from "@services/axios";
import {useToast} from "vue-toastification";
import CustomerAvatarComponent from "@/invoice/customer/CustomerAvatarComponent.vue";
import router from "@router";
import ConformationModal from "@/invoice/common/modal/ConformationModal.vue";
import {Modal} from "bootstrap";
import {USERS} from "@services/endpoints";
import useEmitter from "@/core/global/composable/useEmitter";
import usePermission from '@/core/global/composable/usePermission';

const {canAccess} = usePermission();

const {t} = useI18n();
const emitter = useEmitter()
const tableId = ref('customer-table')

const options = ref({
    url: CUSTOMERS,
    pageSize: 5,
    rowLimit: 10,
    orderBy: 'desc',
    showGridView: false,
    actionType: 'dropdown',
    paginationType: 'pagination',
    enableRowSelect: false,
    enableBulkSelect: false,
    showSearch: true,
    showFilter: true,
    exportPermission: canAccess('customer_export'),
    exportData: () => customerExport(),
    columns: [
        {
            title: t('name'),
            type: 'component',
            key: 'full_name',
            componentName: markRaw(CustomerAvatarComponent)
        },
        {
            title: t('email'),
            type: 'text',
            key: 'email',
        },
        {
            title: t('phone'),
            type: 'object',
            key: 'user_profile',
            modifier: (profile => profile ? profile.phone_number : '-')
        }, {
            title: t('tax_no'),
            type: 'object',
            key: 'user_profile',
            modifier: (profile => profile ? profile.tax_no : '-')
        },
        {
            title: t('status'),
            type: 'custom-html',
            key: 'status',
            modifier: (value) => {
                return `<span class="badge bg-${value.class}">${value.translated_name}</span>`
            }
        },
        {
            title: t('action'),
            type: 'action',
            align: 'right',
            permission: canAccess("details_view_customer") || canAccess("update_customers") || canAccess("customer_resend_portal_access") || canAccess("delete_customers")
        },
    ],

    filters: [
        {
            label: t('status'),
            type: 'search-select',
            key: 'status',
            options: [{id: 1, name: t('active')}, {id: 2, name: t('status_inactive')}],
            listKeyField: 'id',
            listValueField: 'name',
            showSearch: false,
            permission: true,
        },
    ],
    actions: [
        {
            title: t('view_details'),
            type: 'view_details',
            icon: 'bi bi-eye-fill',
            modifier: () => canAccess("details_view_customer"),
        },
        {
            title: t('edit'),
            type: 'edit',
            icon: 'bi bi-pencil-square',
            modifier: () => canAccess("update_customers"),
        },
        {
            title: t('send_portal_access'),
            type: 'portal_access',
            icon: 'bi bi-envelope-at-fill',
            modifier: () => canAccess("customer_resend_portal_access"),
        },
        {
            title: t('active'),
            icon: 'bi bi-record-circle-fill',
            type: 'active',
            modifier: (row => row.status.name !== "status_invited" && row.status.name !== "status_active")
        },
        {
            title: t('inactive'),
            icon: 'bi bi-slash-circle-fill',
            type: 'de_activate',
            modifier: (row => row.status.name !== "status_invited" && row.status.name !== "status_inactive")
        },
        {
            title: t('delete'),
            type: 'delete',
            icon: 'bi bi-trash3',
            modifier: () => canAccess("delete_customers"),
        }

    ],
})

const {isModalActive, selectedData, closeModal} = useOpenModal()
const {deleteUrl, isDeleteModal, cancelled} = useDeleteModal()

const resendPortalAccessModal = ref(false)
const actionTiger = (row, action) => {
    if (action.type === 'edit') {
        isModalActive.value = true
        selectedData.value = `${CUSTOMERS}/${row.id}`
    } else if (action.type === 'delete') {
        isDeleteModal.value = true
        deleteUrl.value = `${CUSTOMERS}/${row.id}`
    } else if (action.type === 'portal_access') {
        resendPortalAccessModal.value = true
        selectedData.value = row
    } else if (action.type === 'view_details') {
        router.push(`customer/${row.id}/details`)
    } else if (action.type === 'active') {
        userUpdateStatus(row, 'status_active')
    } else if (action.type === 'de_activate') {
        userUpdateStatus(row, 'status_inactive')
    }
}

const preloader = ref(false)
const toast = useToast()
const confirmSend = () => {
    preloader.value = true
    Axios.patch(`${RE_SEND_CUSTOMER_PORTAL_ACCESS}/${selectedData.value?.id}`, {
        portal_access: 1
    }).then((response) => {
        toast.success(response?.data?.message);
        closePortalAccessModal()
    }).finally(() => preloader.value = false)
}

const closePortalAccessModal = () => {
    resendPortalAccessModal.value = false
    let modal = Modal.getInstance(document.getElementById('customerResendMail'));
    modal.hide();
    selectedData.value = null
}
const userUpdateStatus = (row, status) => {
    Axios.patch(`${USERS}/${row.id}`, {
        'status_name': status
    }).then((response) => {
        toast.success(response?.data?.message);
        emitter.emit('reload-' + tableId.value);
    }).catch(({response}) => {
        if (response.status === 422) {
            toast.error(response?.data?.errors);
        } else {
            toast.error(response?.data?.message);
        }
    })
}
const customerExport = () => {
    Axios.get(CUSTOMER_EXPORT, {responseType: 'arraybuffer'}).then((response) => {
        let fileURL = window.URL.createObjectURL(new Blob([response.data]));
        let fileLink = document.createElement('a');
        fileLink.href = fileURL;
        fileLink.setAttribute('download', 'customers_export.xlsx');
        document.body.appendChild(fileLink);
        fileLink.click();
    })
}
</script>


