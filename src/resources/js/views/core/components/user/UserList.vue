<template>
    <div class="content-wrapper">
        <app-breadcrumb :page-title="$t('users_management')">
            <template #breadcrumb-actions>
                    <button v-if="canAccess('manage_user_invite')" @click.prevent="isModalActive=true"
                            class="btn btn-primary text-white">
                        {{ $t('invite_user') }}
                    </button>
            </template>
        </app-breadcrumb>

        <app-datatable v-if="canAccess('view_users')" :id="tableId" :options="options" @action="actionTiger"/>

        <user-invite-modal v-if="isModalActive"
                           modal-id="user-invite-modal"
                           :table-id="tableId"
                           @close="isModalActive = false"/>

        <app-delete-modal v-if="isDeleteModal"
                          :table-id="tableId"
                          :selected-url="deleteUrl"
                          @cancelled="cancelled"/>
    </div>

</template>

<script setup>
import {ref, markRaw} from "vue"
import {useI18n} from 'vue-i18n';
import {SELECTED_ROLE, USERS} from "@services/endpoints";
import UserInviteModal from "@/core/components/user/UserInviteModal.vue";
import UserAvatarComponent from "@/core/components/user/UserAvatarComponent.vue";
import {useDeleteModal} from "@/core/global/composable/modal/useDeleteModal";
import Axios from "@services/axios";
import useEmitter from "@/core/global/composable/useEmitter";
import {useToast} from "vue-toastification";
import usePermission from '@/core/global/composable/usePermission';

const { canAccess } = usePermission();
const {t} = useI18n();
const tableId = ref('user-table')
const isModalActive = ref(false)

const options = ref({
    url: USERS,
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
    columns: [
        {
            title: t('name'),
            type: 'component',
            key: 'full_name',
            componentName: markRaw(UserAvatarComponent)
        },
        {
            title: t('email'),
            type: 'text',
            key: 'email'
        },
        {
            title: t('role'),
            type: 'object',
            key: 'role',
            modifier: (role => role ? role.name : '-')
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
            align: 'right'
        },
    ],
    filters:[
        // {
        //     type: 'date-range',
        //     key: 'daterange',
        //     placeholder: t('select_range'),
        //     permission: true,
        // },
        {
            label: t('status'),
            type: 'search-select',
            key: 'status',
            options: [{id: 1, name: t('active')}, {id: 2, name: t('de_activate')}, {id: 3, name: t('status_invited')}],
            listKeyField: 'id',
            listValueField: 'name',
            showSearch: false,
            permission: true,
        },
        {
            type: 'advance-search-select',
            key: 'role',
            label: 'role',
            listKeyField: 'id',
            listValueField: 'name',
            rowPerLoad: 10,
            fetchUrl: `${SELECTED_ROLE}`,
            permission: true,
        }
    ],
    actions: [
        {
            title: t('active'),
            icon:'bi bi-record-circle-fill',
            type: 'active',
            modifier: (row => !row.is_admin && row.status.name !== "status_invited" && row.status.name != "status_active")
        },
        {
            title: t('inactive'),
            icon:'bi bi-slash-circle-fill',
            type: 'de_activate',
            modifier: (row => !row.is_admin && row.status.name !== "status_invited" && row.status.name != "status_inactive" ? true : false)
        },
        {
            title: t('delete'),
            icon:'bi bi-trash3',
            type: 'delete',
            modifier: (row => !row.is_admin)
        }
    ],
})

const {deleteUrl, isDeleteModal, cancelled} = useDeleteModal()
const actionTiger = (row, action) => {
    if (action.type === 'active') {
        userUpdateStatus(row, 'status_active')
    } else if (action.type === 'de_activate'){
        userUpdateStatus(row, 'status_inactive')
    }else if (action.type === 'delete') {
        isDeleteModal.value = true
        deleteUrl.value = `${USERS}/${row.id}`
    }
}
const emitter = useEmitter()
const toast = useToast()
const userUpdateStatus = (row, status) => {
    Axios.patch(`${USERS}/${row.id}`, {
        'status_name': status
    }).then((response) => {
        toast.success(response?.data?.message);
        emitter.emit('reload-' + tableId.value);
    }).catch(({response}) => {
        if (response.status === 403) {
            toast.error(response?.data?.message);
        }
    })
}
</script>

