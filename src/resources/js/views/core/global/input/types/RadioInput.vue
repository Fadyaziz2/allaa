<template>
    <label
        class="form-check form-check-radio me-2 mb-2"
        :class="{
            'form-check-inline': data.formCheckInline,
            'form-check-boxed': data.formCheckBoxed,
        }"
        v-for="(option, index) in data.options"
        :for="data.id + '-' + index"
    >
        <input
            class="form-check-input"
            type="radio"
            :id="data.id + '-' + index"
            :disabled="option.disabled || data.disabled"
            :checked="option[data.listKeyField] == value"
            :value="option[data.listKeyField]"
            v-bind="$attrs"
            @change="radioOption(option[data.listKeyField])"
        />
        <span class="form-check-label">
            {{ option[data.listValueField] }}
        </span>
    </label>
</template>

<script setup>
const props = defineProps({
    data: {},
    value: {},
});
const emit = defineEmits(["radioOption"]);

const radioOption = (value) => {
    emit("radioOption", value);
};
</script>
