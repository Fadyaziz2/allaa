<template>
    <app-modal :modal-id="modalId"
               modal-size="large"
               :title="selectedUrl ? $t('update_note') : $t('add_note')"
               :preloader="preloader"
               @submit="submit"
               @close="closeModal">
        <template v-slot:body>
            <div class="mb-4">
                <app-input
                    type="text"
                    id="Name"
                    :label="$t('name')"
                    label-required
                    :label-required="true"
                    v-model="formData.name"
                    :errors="$errors(errors, 'name')"
                />
            </div>
            <div class="mb-4">
                <app-input
                    type="select"
                    id="Type"
                    :options="noteTypes"
                    list-value-field="title"
                    :label="$t('type')"
                    label-required
                    v-model="formData.type"
                    :choose-label="$t('choose_a_type')"
                    :errors="$errors(errors, 'type')"
                />
            </div>
            <div class="mb-4">
                <app-input
                    type="editor"
                    id="Notes"
                    label-required
                    :label="$t('notes')"
                    v-model="formData.note"
                    :errors="$errors(errors, 'note')"
                />
            </div>

        </template>
    </app-modal>
</template>

<script setup>
import {useSubmitForm} from "@/core/global/composable/modal/useSubmitForm";
import {useI18n} from "vue-i18n";
import {NOTES} from "@services/endpoints/invoice";

const props = defineProps({
    modalId: String,
    tableId: String,
    selectedUrl: String
})
const {t} = useI18n();

const noteTypes = [
    {
        id: 'invoice',
        title: t('invoice'),
    },
    {
        id: 'estimate',
        title: t('estimate'),
    }
]
const emit = defineEmits(['close']);


const {preloader,formData, errors, save, closeModal} = useSubmitForm(props, emit)
const submit = () => {
    save(props.selectedUrl ? props.selectedUrl : NOTES, formData.value)
}
</script>

