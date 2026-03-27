<template>
    <app-datatable :id="tableId" :options="options" @action="actionTiger"/>

    <notes-modal v-if="isModalActive"
                 modal-id="notes-modal"
                 :table-id="tableId"
                 :selected-url="selectedData"
                 @close="closeModal"
    />

    <app-delete-modal v-if="isDeleteModal"
                      :table-id="tableId"
                      :selected-url="deleteUrl"
                      @cancelled="cancelled"/>

</template>

<script setup>
import {ref, onMounted, onBeforeUnmount} from "vue";
import {useI18n} from "vue-i18n";
import NotesModal from "@/invoice/setting/notes/NotesModal.vue";
import useEmitter from "@/core/global/composable/useEmitter";
import {useOpenModal} from "@/core/global/composable/modal/useOpenModal";
import {NOTES} from "@services/endpoints/invoice";
import {useDeleteModal} from "@/core/global/composable/modal/useDeleteModal";
import usePermission from "@/core/global/composable/usePermission";
const { canAccess } = usePermission();

const emitter = useEmitter()

const props = defineProps({
    id: {}
})

const {isModalActive, selectedData, closeModal} = useOpenModal()
const {deleteUrl, isDeleteModal, cancelled} = useDeleteModal()

const tableId = ref('note-table')
const {t} = useI18n();
const options = ref({
    url: NOTES,
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
            title: t('name'),
            type: 'text',
            key: 'name'
        },
        {
            title: t('type'),
            type: 'object',
            key: 'type',
            modifier: (type => t(type))
        },
        {
            title: t('action'),
            type: 'action',
            align: 'right'
        },
    ],
    actions: [
        {
            title: t('edit'),
            icon: 'bi bi-pencil-square',
            type: 'edit',
            modifier: () => !!canAccess('update_notes')
        },
        {
            title: t('delete'),
            icon: 'bi bi-trash3',
            type: 'delete',
            modifier: () => !!canAccess('delete_notes')
        }
    ],
})

const actionTiger = (row, action) => {
    if (action.type === 'edit') {
        isModalActive.value = true
        selectedData.value = `${NOTES}/${row.id}`
    } else if (action.type === 'delete') {
        isDeleteModal.value = true
        deleteUrl.value = `${NOTES}/${row.id}`
    }
}
onMounted(() => {
    emitter.on('headerButtonTiger-' + props.id, () => {
        isModalActive.value = true
    });
})
onBeforeUnmount(() => {
    emitter.off('headerButtonTiger-' + props.id)
})

</script>

