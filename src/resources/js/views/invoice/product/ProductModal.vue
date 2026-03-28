<template>
    <app-modal :modal-id="modalId"
               :title="selectedUrl ? $t('update_product') : $t('add_product')"
               modal-size="large"
               :preloader="preloader"
               @submit="submit"
               @close="closeModal">
        <template v-slot:body>
            <app-loader v-if="pageLoader"></app-loader>
            <form v-else>
                <div class="mb-4">
                    <app-input type="text" id="name" :label="$t('name')" label-required :placeholder="$t('name')"
                               v-model="formData.name" :errors="$errors(errors, 'name')"/>
                </div>
                <div class="mb-4">
                    <app-input type="number" id="price" :label="$t('price')" label-required :placeholder="$t('price')"
                               v-model="formData.price" :errors="$errors(errors, 'price')"/>
                </div>
                <div class="mb-4 d-flex align-items-end gap-2">
                    <div class="w-100">
                        <app-input type="text" id="sku" :label="$t('sku')" label-required :placeholder="$t('sku')"
                                   v-model="formData.sku" :errors="$errors(errors, 'sku')"/>
                    </div>
                    <button type="button" class="btn btn-outline-secondary mb-1" @click="generateSku">
                        {{ $t('generate') }}
                    </button>
                </div>

                <div class="mb-4">
                    <app-input type="advance-search-select" id="units" :label="$t('unit')" listValueField="name"
                               list-key-field="id"
                               v-model="formData.unit_id" :loading-length="10" :fetch-url="SELECTED_UNITS"
                               :choose-label="$t('choose_a_unit')"/>
                </div>

                <div class="mb-4">
                    <app-input type="advance-search-select"
                        id="categories"
                        :label="$t('category')"
                        listValueField="name"
                        list-key-field="id"
                        v-model="formData.category_id"
                        :loading-length="10"
                        :fetch-url="SELECTED_CATEGORY"
                        :choose-label="$t('choose_a_category')"
                    />
                </div>

                <div class="mb-4">
                    <app-input type="textarea" id="description" :label="$t('description')" v-model="formData.description"
                               :errors="$errors(errors, 'description')"/>
                </div>
            </form>
        </template>
    </app-modal>
</template>

<script setup>
import {useSubmitForm} from "@/core/global/composable/modal/useSubmitForm";
import {SELECTED_UNITS, SELECTED_CATEGORY, PRODUCTS} from "@services/endpoints/invoice";

const props = defineProps({
    modalId: String,
    tableId: String,
    selectedUrl: String,
})
const emit = defineEmits(['close'])
const {preloader, pageLoader, formData, errors, save, closeModal} = useSubmitForm(props, emit)

const generateSku = () => {
    const seed = `${Date.now()}-${Math.random().toString(36).substring(2, 7)}`
    formData.value.sku = `SKU-${seed}`.toUpperCase()
}

const submit = () => {
    formData.value.code = formData.value.sku
    save(props.selectedUrl ? props.selectedUrl : PRODUCTS, formData.value)
}
</script>
