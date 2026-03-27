<template>
    <div class="filter search-select-filter">
        <app-input
            type="advance-multi-select"
            show-type="filter"
            :id="`advance-multi-select-filter-${filterKey}`"
            :list-value-field="listValueField"
            :list-key-field="listKeyField"
            v-model="multiValue"
            @advanceMultiSelect="sendFilterValue"
            :loading-length="loadingLength"
            :fetch-url="fetchUrl"
            :choose-label="label"
            :show-search="showSearch"
        />
    </div>
</template>

<script setup>
import {ref, onMounted} from "vue"

const props = defineProps({
    label: {},
    filterKey: {},
    fetchUrl: {},
    loadingLength: {
        type: Number,
        default: 50
    },
    listValueField: {},
    listKeyField: {},
    active: {},
    showSearch: {
        type: Boolean,
        default: true
    },
})

const emit = defineEmits(['applyFilter'])


const isApplied = ref(false)
const multiValue = ref([])

const sendFilterValue = () => {
    let filterObj = {};
    filterObj[props.filterKey] = multiValue.value.toString();
    emit('applyFilter', filterObj)
}

onMounted(() => {
    if (props.active) {
        multiValue.value = props.active.split(',');
        isApplied.value = true;
    }
})

</script>

