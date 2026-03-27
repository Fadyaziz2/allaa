<template>
    <app-modal
        :modal-id="modalId"
        :title="$t('choose_template')"
        modal-size="extra-large"
        :preloader="preloader"
        @submit="submit"
        @close="closeModal"
        :save-button-label="$t('select_template')"
        save-button-icon="bi-check-circle fs-4"
    >
        <template v-slot:body>
            <div class="row">
                <template v-for="temp in invoiceTemplates" :key="temp.id">
                    <div class="col-12 col-sm-6 col-md-4">
                        <input
                            v-model="formData.selected_template"
                            :value="temp.id"
                            type="radio"
                            class="btn-check"
                            :id="`btn-check-invoice-temp${temp.id}`"
                            :checked="formData.id == temp.id"
                            autocomplete="off"
                        />
                        <label
                            class="border border-1 rounded-0 cursor-pointer"
                            :for="`btn-check-invoice-temp${temp.id}`"
                        >
                            <img
                                class="width-full"
                                :src="urlGenerator(temp.image)"
                                :alt="temp.name"
                            />
                            <div
                                class="w-100 p-2 text-center border-top"
                                :class="
                                    formData.selected_template == temp.id
                                        ? 'bg-primary text-white'
                                        : 'bg-gray-300'
                                "
                            >
                                {{ temp.name }}
                            </div>
                        </label>
                    </div>
                </template>
            </div>
        </template>
    </app-modal>
</template>

<script setup>
import { useSubmitForm } from "@/core/global/composable/modal/useSubmitForm";
import { urlGenerator } from "@utilities/urlGenerator";
import { watch } from "vue";

const props = defineProps({
    modalId: String,
    tableId: String,
    invoiceTemplates: {},
    modelValue: {},
});
const emit = defineEmits(["close", "update:modelValue"]);
const { preloader, formData, closeModal } = useSubmitForm(props, emit);

watch(
    () => props.modelValue,
    (value) => {
        formData.value.selected_template = value;
    },
    { immediate: true, deep: true }
);

const submit = () => {
    emit("update:modelValue", formData.value.selected_template);
    closeModal();
};
</script>
