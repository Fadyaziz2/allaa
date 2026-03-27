<template>

    <app-datatable :id="tableId" :options="options" @action="actionTiger"/>

    <tax-modal v-if="isModalActive"
               :table-id="tableId"
               modal-id="tax-modal"
               :selected-url="selectedData"
               @close="closeModal"/>

    <app-delete-modal v-if="isDeleteModal"
                      :table-id="tableId"
                      :selected-url="deleteUrl"
                      @cancelled="cancelled"/>

</template>

<script setup>
import {ref, onMounted, onBeforeUnmount} from "vue";
import {useI18n} from "vue-i18n";
import {TAXES} from "@services/endpoints/invoice";
import TaxModal from "@/invoice/setting/tax/TaxModal.vue";
import {useOpenModal} from "@/core/global/composable/modal/useOpenModal";
import {useDeleteModal} from "@/core/global/composable/modal/useDeleteModal";
import useEmitter from "@/core/global/composable/useEmitter";
import usePermission from "@/core/global/composable/usePermission";
const { canAccess } = usePermission();
const {t} = useI18n();

const props = defineProps({
    id: {}
})
const tableId = ref('tax-table')

const options = ref({
    url: TAXES,
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
            key: 'name',
        },
        {
            title: t('tax_rate'),
            type: 'text',
            key: 'rate',
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
            type: 'edit',
            icon: 'bi bi-pencil-square',
            modifier: () => !!canAccess('update_taxes')
        },
        {
            title: t('delete'),
            type: 'delete',
            icon: 'bi bi-trash3',
            modifier: () => !!canAccess('delete_taxes')
        }
    ],
})

const {isModalActive, selectedData, closeModal} = useOpenModal()
const {deleteUrl, isDeleteModal, cancelled} = useDeleteModal()


const actionTiger = (row, action) => {
    if (action.type === 'edit') {
        isModalActive.value = true
        selectedData.value = `${TAXES}/${row.id}`
    } else if (action.type === 'delete') {
        isDeleteModal.value = true
        deleteUrl.value = `${TAXES}/${row.id}`
    }
}

const emitter = useEmitter()

onMounted(() => {
    emitter.on('headerButtonTiger-' + props.id, () => {
        isModalActive.value = true
    });
})
onBeforeUnmount(() => {
    emitter.off('headerButtonTiger-' + props.id)
})

</script>


