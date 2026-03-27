<template>
    <div class="note p-3">
        {{ message }}
    </div>
</template>
<script setup>
defineProps({
    message: String,
});
</script>
<style>
.note {
    border-radius: var(--round-default);
    background-color: var(--note-bg-color);
    color: var(--font-color);
    display: inline-flex;
    border: 1px solid var(--border-color);
}
</style>
