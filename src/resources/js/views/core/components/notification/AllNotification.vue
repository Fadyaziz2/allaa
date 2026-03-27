<template>
    <div>
        <app-breadcrumb :page-title="t('all_notifications')"/>

        <app-datatable v-if="canAccess('view_all_notifications')"
                       id="aLl-notification-table"
                       :options="options"
                       @action="actionTiger"/>
    </div>
</template>

<script setup>
import { ref } from 'vue';
import {NOTIFICATIONS} from '@services/endpoints';
import { useI18n } from 'vue-i18n';
import usePermission from '@/core/global/composable/usePermission';
import {formatDateTimeToLocal} from "@utilities/helpers";
import Axios from "@services/axios";
import {urlGenerator} from "@utilities/urlGenerator";
import useEmitter from "@/core/global/composable/useEmitter";

const { canAccess } = usePermission();
const { t } = useI18n();
const emitter = useEmitter()
import {useToast} from "vue-toastification";
import store from "@store/index";

const options = ref({
    url: NOTIFICATIONS,
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
            title: t('subject'),
            type: 'object',
            key: 'data',
            modifier: (data => data.message)
        },
        {
            title: t('status'),
            type: 'custom-html',
            key: 'read_at',
            modifier: (value) => {
                if (value){
                    return `<span class="badge-square-fill bg-success mr-2">${t('read')}</span>`
                }else{
                    return `<span class="badge-square-fill bg-info mr-2">${t('un_read')}</span>`
                }

            }
        },
        {
            title: t('read_at'),
            type: 'object',
            key: 'read_at',
            modifier: (read_at => read_at ? formatDateTimeToLocal(read_at) : null)
        },

        {
            title: t('action'),
            type: 'action',
            align: 'right'
        },

    ],
    filters:[
        {
            label: t('status'),
            type: 'search-select',
            key: 'status',
            options: [{id: 'read', name: t('read')}, {id: 'unread', name: t('un_read')}],
            listKeyField: 'id',
            listValueField: 'name',
            showSearch: false,
            permission: true,
        },
    ],
    actions: [
        {
            title: t('read'),
            icon:'bi bi-check2-circle',
            type: 'read',
            modifier: (row => !row.read_at)
        },
        {
            title: t('un_read'),
            icon:'bi bi-file-x',
            type: 'un_read',
            modifier: (row => row.read_at)
        },
    ],
})

const actionTiger = (row, action) => {
    if (action.type === 'read') {
        manageRead(row)
    }else if (action.type === 'un_read'){
        manageUnRead(row)
    }
}
const toast = useToast()
const manageRead = (row) => {
    Axios.patch(urlGenerator(`api/app/user/read-notifications/${row.id}`)).then(({data}) => {
        toast.success(data?.message);
        store.dispatch('notification/getNotificationData')
        emitter.emit('reload-aLl-notification-table');
    })
}
const manageUnRead = (row) => {
    Axios.patch(urlGenerator(`api/app/user/un-read-notifications/${row.id}`)).then(({data}) => {
        toast.success(data?.message);
        emitter.emit('reload-aLl-notification-table');
        store.dispatch('notification/getNotificationData')
    })
}
</script>

