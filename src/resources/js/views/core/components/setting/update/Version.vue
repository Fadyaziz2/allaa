<template>
    <div
        class="fw-semibold d-flex align-items-center justify-content-center gap-3 flex-wrap"
    >
        <div class="fs-4">{{ label }} :</div>
        <span
            class="badge rounded-pill px-4 fs-5 fw-500"
            :class="[type === 'current' ? 'bg-danger' : 'bg-primary']"
        >
            {{ versionNumber }}
        </span>
    </div>
</template>

<script setup>
defineProps({
    label: String,
    versionNumber: [Number, String],
    type: {
        type: String,
        default: () => "current",
        validator: (value) => ["current", "next"].includes(value),
    },
});
</script>
