<template>
    <v-date-picker :value="value"
                   :min-date="data.minDate"
                   :max-date="data.maxDate"
                   :color="data.dateColor"
                   :mode="dateMode"
                   :isDark="store.state.theme.darkMode"
                   :isRange="isRange"
                   :is24hr="store.state.settings.timeFormat == 24"
                   :masks="{
                       input:[store.state.settings.dateFormat],
                       inputDateTime:[store.state.settings.dateFormat+' h:mm A'],
                       inputDateTime24hr:[store.state.settings.dateFormat+' HH:mm'],
                       inputTime:['h:mm A'],
                       inputTime24hr:['HH:mm']
                   }"
                   :popover="{visibility: 'click', placement: data.popoverPosition}"
                   @dayclick="handleDate($event)">


        <template v-slot="{ inputValue, inputEvents }">
            <div class="date-picker-input" :class="{'date-picker-input-group':borderGroup}">
                <div class="input-group"
                     :class="{'disabled':data.disabled}"
                     @focusin="borderGroup=true"
                     @focusout="borderGroup=false">
                    <template v-if="isRange">
                        <input :value="inputValue.start || inputValue.end ? inputValue.start+' - '+inputValue.end: ''"
                               :placeholder="data.placeholder"
                               readonly
                               v-on="inputEvents.start || inputEvents.end"
                               class="form-control"
                               v-bind="$attrs"/>
                    </template>
                    <template v-else>
                        <input :value="inputValue ? inputValue : ''"
                               v-bind="$attrs"
                               v-on="inputEvents"
                               class="form-control"
                        />
                    </template>
                </div>
            </div>
        </template>
    </v-date-picker>
</template>

<script setup>
import {ref, computed} from "vue"
import store from "@store/index";
import {useCoreAppFunction} from "@/core/global/helpers/CoreLibrary";

const props = defineProps({
    value: {},
    data: {}
})

const emit = defineEmits(['datePickerChange'])


const borderGroup = ref(false)

const {isUndefined} = useCoreAppFunction()

const isRange = computed(() => {
    if (props.data.dateMode === 'range') {
        return true
    }
    return isUndefined(props.data.isRange) ? false : props.data.isRange;
})

const dateMode = computed(() => {
    if (props.data.dateMode === 'range' || isUndefined(props.data.dateMode)) {
        return 'date';
    } else return props.data.dateMode;
})
const handleDate = (context) => {
    emit('datePickerChange', context.date);
}
</script>

