<template>
    <app-modal :modal-id="modalId"
               modal-size="large"
               :title="selectedUrl ? $t('update_tax') : $t('add_tax')"
               :preloader="preloader"
               @submit="submit"
               @close="closeModal">
        <template v-slot:body>
            <div class="mb-4">
                <app-input type="text" id="name" :label="$t('name')" label-required :placeholder="$t('name')"
                           v-model="formData.name" :errors="$errors(errors, 'name')"/>
            </div>

            <div class="mb-4">
                <app-input type="number" id="tax_rate" :label="$t('tax_rate')" label-required
                           :placeholder="$t('tax_rate')"
                           v-model="formData.rate" :errors="$errors(errors, 'rate')"/>
            </div>
        </template>
    </app-modal>
</template>

<script setup>
import {useSubmitForm} from "@/core/global/composable/modal/useSubmitForm";
import {TAXES} from "@services/endpoints/invoice";

const props = defineProps({
    modalId: String,
    tableId: String,
    selectedUrl: String,
})
const emit = defineEmits(['close'])
const {preloader, formData, errors, save, closeModal} = useSubmitForm(props, emit)
const submit = () => {
    save(props.selectedUrl ? props.selectedUrl : TAXES, formData.value)
}
</script>


