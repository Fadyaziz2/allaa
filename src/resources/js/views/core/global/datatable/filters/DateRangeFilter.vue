<template>
    <div class="date-range-filter">
            <app-input
                type="daterange"
                :id="`date-range-filter-${filterKey}`"
                v-model="filterValue"
                :enable-time-picker="false"
                v-bind="$attrs"
                auto-apply
                multi-calendars
                @cleared="emit('applyFilter', {})"
            />
    </div>
</template>
<script setup>
import {ref, onMounted, watch} from "vue";
import { useRoute } from "vue-router";
const props = defineProps({
    active: {},
    filterKey: {},
})
const emit = defineEmits(['applyFilter'])

const route = useRoute();

const filterValue = ref()
let filterObj = [];

watch(filterValue, (newValue)=>{
    filterObj[props.filterKey] = newValue ? newValue : '';
    emit('applyFilter', filterObj)
});

onMounted(() => {
    if (props.active) {
        filterValue.value = props.active;
    }
    if (route.query[props.filterKey]) {
        filterValue.value = JSON.parse(route.query[props.filterKey]);
    }
})
</script>
<style lang="scss" scoped>
.date-range-filter{
    &::v-deep .dp__pointer.dp__input_readonly.dp__input.dp__input_icon_pad.dp__input_reg{
        max-height: 35px;
    }

}
</style>
