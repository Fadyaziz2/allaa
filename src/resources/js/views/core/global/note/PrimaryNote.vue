<template>
    <div class="primary-note rounded-default d-flex">
        <i class="bi bi-exclamation-circle text-danger lh-1"></i>
        <div>
            <div class="fw-semibold lh-1">{{ title }}</div>
            <slot>
                <div class="mt-3">{{ description }}</div>
            </slot>
        </div>
    </div>
</template>

<script setup>
defineProps({
    title: {
        type: String,
        required: true,
    },
    description: {
        type: String,
        required: true,
    },
});
</script>

<style>
.primary-note {
    background-color: var(--note-bg-color);
    column-gap: 10px;
}
</style>
