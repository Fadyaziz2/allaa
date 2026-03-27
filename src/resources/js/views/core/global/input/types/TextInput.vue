<template>
    <input type="text"
           :id="data.id"
           class="form-control"
           :value="value"
           v-bind="$attrs">
</template>

<script>
export default {
    name: "TextInput",
    props: {
        value: {},
        data: {}
    },
}
</script>

