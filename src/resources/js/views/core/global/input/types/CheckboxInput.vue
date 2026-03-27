<template>
    <div class="form-check d-flex gap-3 align-items-center" v-for="(option, index) in data.options" :key="index">
        <input class="form-check-input"
               type="checkbox"
               :value="option[data.listKeyField]"
               :id="`${data.id}-${option[data.listKeyField]}`"
               v-model="inputValue"
               v-bind="$attrs">
        <label class="form-check-label fw-semibold fs-5" :for="`${data.id}-${option[data.listKeyField]}`">
            {{ option[data.listValueField] }}
        </label>
    </div>
</template>

<script setup>
import {ref, watch} from "vue"

const props = defineProps({
    data: {},
    value: {
        type: Array,
        default: []
    }
})

const emit = defineEmits(['checkboxOption'])

const inputValue = ref([...props.value])

watch(inputValue, (newValue) => {
    emit('checkboxOption', newValue)
})

</script>

