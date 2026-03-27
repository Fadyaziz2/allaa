<template>
    <app-modal :modal-id="modalId" modal-size="large" :title="selectedUrl ? $t('update_category') : $t('add_category')"
               :preloader="preloader"
               @submit="submit" @close="closeModal">
        <template v-slot:body>
            <div class="mb-4">
                <app-input type="text" id="name" :label="$t('name')" label-required :placeholder="$t('name')"
                           v-model="formData.name" :errors="$errors(errors, 'name')"/>
            </div>
        </template>
    </app-modal>
</template>

<script setup>
import {useSubmitForm} from "@/core/global/composable/modal/useSubmitForm";
import {CATEGORIES} from "@services/endpoints/invoice";

const props = defineProps({
    modalId: String,
    tableId: String,
    selectedUrl: String,
})
const emit = defineEmits(['close'])
const {preloader, formData, errors, save, closeModal} = useSubmitForm(props, emit)
const submit = () => {
    let data = {...formData.value, type: 'category'}
    save(props.selectedUrl ? props.selectedUrl : CATEGORIES, data)
}
</script>


