<template>
    <app-modal :modal-id="modalId"
               modal-size="large"
               :title="$t('add_wastage')"
               :preloader="preloader"
               @submit="submit"
               @close="closeModal">
        <template #body>
            <div class="mb-4">
                <app-input type="advance-search-select" id="product_id"
                           :label="$t('product')"
                           label-required
                           listValueField="name"
                           list-key-field="id"
                           v-model="formData.product_id"
                           :loading-length="10"
                           :fetch-url="SELECTED_PRODUCT"
                           :choose-label="$t('choose_a_product')"
                           :errors="$errors(errors, 'product_id')"/>
            </div>

            <div class="mb-4">
                <app-input type="number" id="quantity"
                           :label="$t('deduct_quantity')"
                           label-required
                           :placeholder="$t('deduct_quantity')"
                           v-model="formData.quantity"
                           :errors="$errors(errors, 'quantity')"/>
            </div>

            <div class="mb-4">
                <app-input type="textarea" id="note"
                           :label="$t('note')"
                           :placeholder="$t('note')"
                           v-model="formData.note"
                           :errors="$errors(errors, 'note')"/>
            </div>
        </template>
    </app-modal>
</template>

<script setup>
import {useSubmitForm} from "@/core/global/composable/modal/useSubmitForm";
import {SELECTED_PRODUCT, WASTAGES} from "@services/endpoints/invoice";

const props = defineProps({
    modalId: String,
    tableId: String,
});

const emit = defineEmits(['close']);
const {preloader, formData, errors, save, closeModal} = useSubmitForm(props, emit);

const submit = () => {
    save(WASTAGES, formData.value);
};
</script>
