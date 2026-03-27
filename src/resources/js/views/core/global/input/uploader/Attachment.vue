<template>
    <div>
        <Label :label="label" :label-required="labelRequired" />
        <div class="d-flex align-items-center flex-wrap gap-3">
            <ImageUploader
                :data="$props"
                :value="modelValue"
                @getFile="getFile"
                v-bind="$attrs"
            />
            <slot>
                <p class="mt-4 px-2">
                    {{ recommendedSize }}
                    <br />
                    {{ recommendedFileSize }}
                </p>
            </slot>
        </div>
        <div class="text-danger validation-error mt-2">
            {{ localError || error }}
        </div>
    </div>
</template>

<script setup>
import ImageUploader from "@/core/global/input/types/ImageUploader.vue";
import Label from "@/core/components/ui/Label.vue";
import { useFile } from "~/composable/useFile";
import { useI18n } from "vue-i18n";

const { t } = useI18n();
const { errorMsg, error: localError, validateFileSize } = useFile();
const props = defineProps({
    label: String,
    modelValue: {
        require: true,
    },
    error: {
        type: String,
    },
    labelRequired: Boolean,
    fileSize: {
        type: Number,
        default: () => 1,
    },
    recommendedSize: {
        type: String,
    },
    recommendedFileSize: {
        type: String,
    },
});
const emit = defineEmits(["changeFile"]);
const getFile = (value) => {
    validateFileSize(value, props.fileSize);
    emit("changeFile", value);
};
</script>
