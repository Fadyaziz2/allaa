<template>
  <app-modal :modal-id="modalId" :title="selectedUrl ? $t('update_unit') : $t('add_unit')" modal-size="large"
    :preloader="preloader" @submit="submit" @close="closeModal">
    <template v-slot:body>
      <div class="mb-4">
        <app-input type="text" id="name" :label="$t('name')" label-required :placeholder="$t('name')"
          v-model="formData.name" :errors="$errors(errors, 'name')" />
      </div>
      <div class="mb-4">
        <app-input type="text" id="short_name" :label="$t('short_name')" label-required :placeholder="$t('short_name')"
          v-model="formData.short_name" :errors="$errors(errors, 'short_name')" />
      </div>
    </template>
  </app-modal>
</template>

<script setup>
import {useSubmitForm} from "@/core/global/composable/modal/useSubmitForm";
import {UNITS} from "@services/endpoints/invoice";

const props = defineProps({
    modalId: String,
    tableId: String,
    selectedUrl: String,
})
const emit = defineEmits(['close'])
const {preloader, formData, errors, save, closeModal} = useSubmitForm(props, emit)
const submit = () => {
    save(props.selectedUrl ? props.selectedUrl : UNITS, formData.value)
}
</script>


