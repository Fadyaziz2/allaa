<template>
  <app-modal :modal-id="modalId" modal-size="large" :title="$t('test_mail')" :save-button-label="$t('send')"
    :preloader="preloader" @submit="submit" @close="closeModal">

    <template v-slot:body>
      <div class="row mb-5">
        <div class="col-md-6">
          <app-input type="email" id="email_address" :label="$t('email_address')" label-required
            :placeholder="$t('email_address')" v-model="formData.email_address"
            :errors="$errors(errors, 'email_address')" />
        </div>
        <div class="col-md-6">
          <app-input type="text" id="subject" :label="$t('subject')" label-required :placeholder="$t('subject')"
            v-model="formData.subject" :errors="$errors(errors, 'subject')" />
        </div>
        <div class="col-md-12">
          <app-input type="textarea" id="message" :label="$t('message')" label-required :placeholder="$t('message')"
            v-model="formData.message" :errors="$errors(errors, 'message')" />
        </div>
      </div>
    </template>
  </app-modal>
</template>

<script setup>
import {useSubmitForm} from "@/core/global/composable/modal/useSubmitForm";
import {SEND_TEST_MAIL} from "@services/endpoints";

const props = defineProps({
    modalId: {}
})

const emit = defineEmits(['close'])

const {preloader, formData, errors, save, closeModal} = useSubmitForm(props, emit)

const submit = () => {
    save(SEND_TEST_MAIL, formData.value)
}
</script>

