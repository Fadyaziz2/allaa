<template>
    <app-modal :modal-id="modalId"
               modal-size="large"
               :title="$t('invite_user')"
               :preloader="preloader"
               @submit="submit"
               @close="closeModal">
        <template v-slot:body>
            <div class="mb-4">
                <app-input
                    type="email"
                    id="email"
                    :label="$t('email')"
                    label-required
                    :placeholder="$t('email')"
                    v-model="formData.email"
                    :errors="$errors(errors, 'email')"
                />
            </div>
            <div class="mb-4">
                <app-input type="advance-search-select"
                           id="role"
                           listValueField="name"
                           list-key-field="id"
                           :label="$t('role')"
                           label-required
                           v-model="formData.role"
                           :loading-length="10"
                           :fetch-url="`${SELECTED_ROLE}`"
                           :choose-label="$t('choose_a_role')"
                           :errors="$errors(errors, 'role')"/>

            </div>
        </template>
    </app-modal>
</template>

<script setup>
import {SELECTED_ROLE, USER_INVITE} from "@services/endpoints";
import {useSubmitForm} from "@/core/global/composable/modal/useSubmitForm";
const props = defineProps({
    modalId: String,
    tableId: String
})

const emit = defineEmits(['close'])
const {preloader, formData, errors, save, closeModal} = useSubmitForm(props, emit, 'no')
const submit = () => {
    save(USER_INVITE, formData.value)
}

</script>

