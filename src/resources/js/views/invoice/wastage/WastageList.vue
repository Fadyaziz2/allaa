<template>
    <div class="content-wrapper">
        <app-breadcrumb :page-title="$t('all_wastages')">
            <template #breadcrumb-actions>
                <button v-if="canAccess('create_products')" @click.prevent="isModalActive = true" class="btn btn-primary text-white">
                    {{ $t('add_wastage') }}
                </button>
            </template>
        </app-breadcrumb>

        <app-datatable :id="tableId" :options="options"/>

        <wastage-modal v-if="isModalActive" :table-id="tableId" modal-id="wastage-modal" @close="closeModal"/>
    </div>
</template>

<script setup>
import {ref} from "vue";
import {useI18n} from "vue-i18n";
import {formatDateToLocal} from "@utilities/helpers";
import {SELECTED_CATEGORY, SELECTED_PRODUCT, WASTAGES} from "@services/endpoints/invoice";
import WastageModal from "@/invoice/wastage/WastageModal.vue";
import {useOpenModal} from "@/core/global/composable/modal/useOpenModal";
import usePermission from "@/core/global/composable/usePermission";

const {canAccess} = usePermission();
const {t} = useI18n();
const tableId = ref('wastage-table');

const options = ref({
    url: WASTAGES,
    pageSize: 5,
    rowLimit: 10,
    orderBy: 'desc',
    showGridView: false,
    actionType: 'default',
    paginationType: 'pagination',
    enableRowSelect: false,
    enableBulkSelect: false,
    showSearch: false,
    showFilter: true,
    columns: [
        {title: t('product'), type: 'object', key: 'product', modifier: (product) => product?.name || '-'},
        {title: t('category'), type: 'object', key: 'product', modifier: (product) => product?.category?.name || '-'},
        {title: t('deduct_quantity'), type: 'object', key: 'quantity_change', modifier: (q) => Math.abs(Number(q || 0))},
        {title: t('note'), type: 'text', key: 'note'},
        {title: t('wastage_date'), type: 'object', key: 'movement_date', modifier: (d) => formatDateToLocal(d)},
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
            permission: true,
        },
        {
            label: t('product'),
            type: 'advance-search-select',
            key: 'product',
            listKeyField: 'id',
            listValueField: 'name',
            rowPerLoad: 10,
            fetchUrl: SELECTED_PRODUCT,
            permission: true,
        },
    ],
});

const {isModalActive, closeModal} = useOpenModal();
</script>
