<template>
    <input type="number"
           :id="data.id"
           class="form-control"
           :value="value"
           v-bind="$attrs">
</template>

<script>
export default {
    name: "NumberInput",
    props: {
        value: {},
        data: {}
    },
}
</script>

