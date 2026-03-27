<template>
    <div class="content-wrapper">
        <app-breadcrumb :page-title="$t('all_expenses')">
            <template #breadcrumb-actions>
                <button v-if="canAccess('create_expenses')" @click.prevent="isModalActive = true"
                        class=" btn btn-primary text-white">
                    {{ $t('add_expense') }}
                </button>
            </template>
        </app-breadcrumb>

        <app-datatable :id="tableId" :options="options" @action="actionTiger"/>

        <expense-modal v-if="isModalActive"
                       :table-id="tableId"
                       modal-id="expense-modal"
                       :selected-url="selectedData"
                       @close="closeModal"/>

        <app-delete-modal v-if="isDeleteModal"
                          :table-id="tableId"
                          :selected-url="deleteUrl"
                          @cancelled="cancelled"/>

    </div>
</template>

<script setup>
import {markRaw, ref} from "vue";
import {useI18n} from "vue-i18n";
import {CATEGORIES, EXPENSES, EXPENSES_EXPORT} from "@services/endpoints/invoice";
import ExpenseModal from "@/invoice/expense/ExpenseModal.vue";
import {useOpenModal} from "@/core/global/composable/modal/useOpenModal";
import {useDeleteModal} from "@/core/global/composable/modal/useDeleteModal";
import {formatDateToLocal, numberWithCurrencySymbol} from "@utilities/helpers";
import AttachmentsColumn from "@/invoice/common/component/AttachmentsColumn.vue";
import NoteColumn from "@/invoice/common/component/NoteColumn.vue";
import usePermission from '@/core/global/composable/usePermission';
import Axios from "@services/axios";

const {canAccess} = usePermission();

const {t} = useI18n();

const tableId = ref('expense-table')

const options = ref({
    url: EXPENSES,
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
    exportPermission: canAccess('expense_export'),
    exportData: () => expenseExport(),
    columns: [
        {
            title: t('title'),
            type: 'text',
            key: 'title',
        },
        {
            title: t('date'),
            type: 'object',
            key: 'date',
            modifier: (date => formatDateToLocal(date))
        },
        {
            title: t('category'),
            type: 'object',
            key: 'category',
            modifier: (category => category ? category.name : '-')
        },
        {
            title: t('amount'),
            type: 'object',
            key: 'amount',
            modifier: (amount => numberWithCurrencySymbol(amount))
        },
        {
            title: t('reference'),
            type: 'text',
            key: 'reference',
        },
        {
            title: t('attachments'),
            type: 'component',
            key: 'attachments',
            componentName: markRaw(AttachmentsColumn)
        }, {
            title: t('note'),
            type: 'component',
            key: 'note',
            componentName: markRaw(NoteColumn)
        },
        {
            title: t('action'),
            type: 'action',
            align: 'right'
        },
    ],
    filters: [
        {
            type: 'advance-search-select',
            key: 'category',
            label: t('category'),
            listKeyField: 'id',
            listValueField: 'name',
            rowPerLoad: 10,
            fetchUrl: `${CATEGORIES}?type=expense`,
            permission: true,
        },
        {
            label: t('date'),
            type: 'date-range',
            key: 'date',
            placeholder: t('select_a_range'),
            permission: canAccess('manage_global_access'),
        },
    ],
    actions: [
        {
            title: t('edit'),
            type: 'edit',
            icon: 'bi bi-pencil-square',
            modifier: () => canAccess("update_expenses"),
        },
        {
            title: t('delete'),
            type: 'delete',
            icon: 'bi bi-trash3',
            modifier: () => canAccess("delete_expenses"),
        }
    ],
})

const {isModalActive, selectedData, closeModal} = useOpenModal()
const {deleteUrl, isDeleteModal, cancelled} = useDeleteModal()


const actionTiger = (row, action) => {
    if (action.type === 'edit') {
        isModalActive.value = true
        selectedData.value = `${EXPENSES}/${row.id}`
    } else if (action.type === 'delete') {
        isDeleteModal.value = true
        deleteUrl.value = `${EXPENSES}/${row.id}`
    }
}
const expenseExport = () => {
    Axios.get(EXPENSES_EXPORT, {responseType: 'arraybuffer'}).then((response) => {
        let fileURL = window.URL.createObjectURL(new Blob([response.data]));
        let fileLink = document.createElement('a');
        fileLink.href = fileURL;
        fileLink.setAttribute('download', 'expenses_export.xlsx');
        document.body.appendChild(fileLink);
        fileLink.click();
    })
}
</script>


