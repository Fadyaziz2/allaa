<template>
    <div class="filter search-select-filter">
        <app-input
            type="advance-search-select"
            show-type="filter"
            :id="`advance-filter-${filterKey}`"
            :list-value-field="listValueField"
            :list-key-field="listKeyField"
            v-model="filterValue"
            @searchSelect="sendFilterValue"
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

const filterValue = ref("")

const sendFilterValue = () => {
    let filterObj = {};
    filterObj[props.filterKey] = filterValue.value;
    emit('applyFilter', filterObj)
}

onMounted(() => {
    if (props.active) {
        filterValue.value = props.active;
    }
})
</script>
