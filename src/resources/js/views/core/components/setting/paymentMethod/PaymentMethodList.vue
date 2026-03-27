<template>
    <app-datatable v-if="canAccess('view_payment_methods')" :id="tableId" :options="options" @action="actionTiger"/>

    <payment-method-modal v-if="isModalActive"
                          modal-id="payment-method-modal"
                          :table-id="tableId"
                          :selected-url="selectedData"
                          @close="closeModal"/>

    <app-delete-modal v-if="isDeleteModal"
                      :selected-url="deleteUrl"
                      :table-id="tableId"
                      @cancelled="cancelled"/>
</template>

<script setup>
import {ref, onMounted, onBeforeUnmount} from "vue";
import {useI18n} from "vue-i18n";
import PaymentMethodModal from "@/core/components/setting/paymentMethod/PaymentMethodModal.vue";
import useEmitter from "@/core/global/composable/useEmitter";
import {useOpenModal} from "@/core/global/composable/modal/useOpenModal";
import {useDeleteModal} from "@/core/global/composable/modal/useDeleteModal";
import {PAYMENT_METHODS} from "@services/endpoints/invoice";
import usePermission from "@/core/global/composable/usePermission";

const {canAccess} = usePermission();

const emitter = useEmitter()

const props = defineProps({
    id: {}
})

const {isModalActive, selectedData, closeModal} = useOpenModal()
const {deleteUrl, isDeleteModal, cancelled} = useDeleteModal();


const tableId = ref('payment-method-table')
const {t} = useI18n();
const options = ref({
    url: PAYMENT_METHODS,
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
            modifier: () => !!canAccess('update_payment_methods')
        },
        {
            title: t('delete'),
            icon: 'bi bi-trash3',
            type: 'delete',
            modifier: () => !!canAccess('delete_payment_methods')
        }
    ],
})

const actionTiger = (row, action) => {
    if (action.type === 'edit') {
        isModalActive.value = true
        selectedData.value = `${PAYMENT_METHODS}/${row.id}`
    } else if (action.type === 'delete') {
        isDeleteModal.value = true
        deleteUrl.value = `${PAYMENT_METHODS}/${row.id}`
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

