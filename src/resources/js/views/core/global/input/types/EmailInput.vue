<template>
    <input type="email"
           :id="data.id"
           class="form-control"
           :value="value"
           v-bind="$attrs">
</template>

<script setup>
const props = defineProps({
    value: {},
    data: {}
})

</script>

