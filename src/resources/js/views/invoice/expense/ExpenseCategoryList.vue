<template>
  <div class="content-wrapper">
    <app-breadcrumb :page-title="$t('expense_category')">
      <template #breadcrumb-actions>
        <button v-if="canAccess('create_categories')" @click.prevent="isModalActive = true" class=" btn btn-primary text-white">
          {{ $t('add_expense_category') }}
        </button>
      </template>
    </app-breadcrumb>

    <app-datatable :id="tableId" :options="options" @action="actionTiger" />

    <expense-category-modal v-if="isModalActive" :table-id="tableId" modal-id="category-modal"
      :selected-url="selectedData" @close="closeModal" />

    <app-delete-modal v-if="isDeleteModal" :table-id="tableId" :selected-url="deleteUrl" @cancelled="cancelled" />

  </div>
</template>

<script setup>
import {ref} from "vue";
import {useI18n} from "vue-i18n";
import {CATEGORIES} from "@services/endpoints/invoice";
import ExpenseCategoryModal from "@/invoice/expense/ExpenseCategoryModal.vue";
import {useOpenModal} from "@/core/global/composable/modal/useOpenModal";
import {useDeleteModal} from "@/core/global/composable/modal/useDeleteModal";
import usePermission from '@/core/global/composable/usePermission';
import {formatDateToLocal} from "@utilities/helpers";

const { canAccess } = usePermission();

const {t} = useI18n();

const tableId = ref('unit-table')

const options = ref({
    url: `${CATEGORIES}?type=expense`,
    pageSize: 5,
    rowLimit: 10,
    orderBy: 'desc',
    showGridView: false,
    actionType: 'dropdown',
    paginationType: 'pagination',
    enableRowSelect: false,
    enableBulkSelect: false,
    showSearch: true,
    showFilter: false,
    columns: [
        {
            title: t('name'),
            type: 'text',
            key: 'name',
        },
        {
            title: t('created_at'),
            type: 'object',
            key: 'created_at',
            modifier: (created_at => formatDateToLocal(created_at))
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
            icon:'bi bi-pencil-square',
            modifier: () => canAccess("update_categories"),
        },
        {
            title: t('delete'),
            type: 'delete',
            icon:'bi bi-trash3',
            modifier: () => canAccess("delete_categories"),
        }
    ],
})

const {isModalActive, selectedData, closeModal} = useOpenModal()
const {deleteUrl, isDeleteModal, cancelled} = useDeleteModal()


const actionTiger = (row, action) => {
    if (action.type === 'edit') {
        isModalActive.value = true
        selectedData.value = `${CATEGORIES}/${row.id}`
    } else if (action.type === 'delete') {
        isDeleteModal.value = true
        deleteUrl.value = `${CATEGORIES}/${row.id}`
    }
}
</script>


