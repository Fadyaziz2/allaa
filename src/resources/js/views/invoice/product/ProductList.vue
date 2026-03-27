<template>
    <div class="content-wrapper">
        <app-breadcrumb :page-title="$t('product_list')">
            <template #breadcrumb-actions>
                <button v-if="canAccess('create_products')" @click.prevent="isModalActive = true"
                        class="btn btn-primary text-white">
                    {{ $t('add_product') }}
                </button>
            </template>
        </app-breadcrumb>

        <app-datatable :id="tableId" :options="options" @action="actionTiger"/>

        <product-modal v-if="isModalActive" :table-id="tableId" modal-id="product-modal" :selected-url="selectedData"
                       @close="closeModal"/>

        <app-delete-modal v-if="isDeleteModal" :table-id="tableId" :selected-url="deleteUrl" @cancelled="cancelled"/>

    </div>
</template>

<script setup>
import {ref} from "vue";
import {useI18n} from "vue-i18n";
import {PRODUCT_EXPORT, PRODUCTS, SELECTED_BRAND, SELECTED_CATEGORY, SELECTED_UNITS} from "@services/endpoints/invoice";
import ProductModal from "@/invoice/product/ProductModal.vue";
import {useOpenModal} from "@/core/global/composable/modal/useOpenModal";
import {useDeleteModal} from "@/core/global/composable/modal/useDeleteModal";
import {numberWithCurrencySymbol} from "@utilities/helpers";
import usePermission from '@/core/global/composable/usePermission';
import Axios from "@services/axios";

const {canAccess} = usePermission();

const {t} = useI18n();

const tableId = ref('product-table')

const options = ref({
    url: PRODUCTS,
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
    exportPermission: canAccess('product_export'),
    exportData: () => productExport(),
    columns: [
        {
            title: t('name'),
            type: 'text',
            key: 'name',
        },
        {
            title: t('price'),
            type: 'object',
            key: 'price',
            modifier: (price => numberWithCurrencySymbol(price))
        },
        {
            title: t('code'),
            type: 'text',
            key: 'code',
        },
        {
            title: t('unit'),
            type: 'object',
            key: 'unit',
            modifier: (unit => unit ? unit.name : '-')
        },
        {
            title: t('category'),
            type: 'object',
            key: 'category',
            modifier: (category => category ? category.name : '-')
        },
        {
            title: t('action'),
            type: 'action',
            align: 'right'
        },
    ],
    filters: [
        {
            label: t('category'),
            type: 'advance-search-select',
            key: 'category',
            listKeyField: 'id',
            listValueField: 'name',
            rowPerLoad: 10,
            fetchUrl: `${SELECTED_CATEGORY}?type=category`,
            permission: true
        },
        {
            type: 'advance-search-select',
            key: 'unit',
            label: t('unit'),
            listKeyField: 'id',
            listValueField: 'name',
            rowPerLoad: 10,
            fetchUrl: `${SELECTED_UNITS}`,
            permission: true,
        }
    ],
    actions: [
        {
            title: t('edit'),
            type: 'edit',
            icon: 'bi bi-pencil-square',
            modifier: () => canAccess("update_products"),
        },
        {
            title: t('delete'),
            type: 'delete',
            icon: 'bi bi-trash3',
            modifier: () => canAccess("delete_products"),
        }
    ],
})

const {isModalActive, selectedData, closeModal} = useOpenModal()
const {deleteUrl, isDeleteModal, cancelled} = useDeleteModal()


const actionTiger = (row, action) => {
    if (action.type === 'edit') {
        isModalActive.value = true
        selectedData.value = `${PRODUCTS}/${row.id}`
    } else if (action.type === 'delete') {
        isDeleteModal.value = true
        deleteUrl.value = `${PRODUCTS}/${row.id}`
    }
}

const productExport = () => {
    Axios.get(PRODUCT_EXPORT, {responseType: 'arraybuffer'}).then((response) => {
        let fileURL = window.URL.createObjectURL(new Blob([response.data]));
        let fileLink = document.createElement('a');
        fileLink.href = fileURL;
        fileLink.setAttribute('download', 'products_export.xlsx');
        document.body.appendChild(fileLink);
        fileLink.click();
    })
}
</script>


