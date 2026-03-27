<template>
    <label v-if="label" :class="labelClass">
        {{ label }} <span v-if="labelRequired" class="text-danger">*</span>
        <i
            v-if="labelHint"
            class="bi bi-info-circle-fill ms-1"
            data-bs-toggle="tooltip"
            data-bs-html="true"
            data-bs-placement="top"
            :title="labelHint"
        />
    </label>
</template>

<script setup>
const props = defineProps({
    label: String,
    labelClass: {
        type: String,
        default: "mb-2",
    },
    labelRequired: {
        type: Boolean,
        default: false,
    },
    labelHint: {
        type: String,
    },
});
</script>
