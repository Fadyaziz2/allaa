<template>
  <app-datatable :id="tableId" :options="options" @action="actionTiger" />
</template>

<script setup>
import {ref} from "vue"
import {NOTIFICATION_TYPE} from "@services/endpoints";
import {useI18n} from 'vue-i18n';

const tableId = ref('notification-table')
const {t} = useI18n();
const options = ref({
    url: NOTIFICATION_TYPE,
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
    boxShadow: false,
    columns: [
        {
            title: t('notification_type'),
            type: 'text',
            key: 'name'
        },
        {
            title: t('action'),
            type: 'action',
            align: 'right'
        },
    ],
    actions: [
        {
            title: 'edit',
            type: 'edit'
        }
    ],
})

const actionTiger = (row, action) => {

}

</script>

