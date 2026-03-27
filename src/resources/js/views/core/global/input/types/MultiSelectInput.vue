<template>
    <div class="dropdown keep-dropdown-open">
        <div :id="`multiSelect-${dropDownId}`"
             data-bs-toggle="dropdown"
             aria-expanded="false"
             class="multi-select-control dropdown-toggle">
            <template v-if="selectedOptions.length">
                <span @click.prevent="$event.stopPropagation()"
                      v-for="(item, index) in selectedOptions"
                      class="badge me-2">
                {{ item[data.listValueField] }}
                <a href="#" class="ms-2" @click.prevent="deleteChips($event, item)">
                    <i class="bi bi-x"/>
                </a>
            </span>
            </template>
            <span v-else>{{ data.chooseLabel }}</span>
        </div>

        <ul class="dropdown-menu custom-scrollbar overflow-auto" :id="dropDownId" :aria-labelledby="`multiSelect-${dropDownId}`">
            <li class="mx-2">
                <div class="search-input" @click.stop="()=> 0">
                    <i class="bi bi-search search-icon"/>
                    <input v-model="searchValue" placeholder="Search" class="form-control">
                </div>
            </li>
            <li v-for="(option, index) in options" :key="index">
                <a href="#" @click.prevent="addChips(option)"
                   :class="{'active disabled': isChipSelected(option[data.listKeyField])}"
                   class="dropdown-item d-inline-flex justify-content-between">
                    {{ option[data.listValueField] }}
                    <i v-if="isChipSelected(option[data.listKeyField])" class="bi bi-check2-circle"/>
                </a>
            </li>
            <li v-if="!options.length">
                <div class="text-center text-muted text-size-13 py-2">
                    {{ hintText }}
                </div>
            </li>
        </ul>
    </div>
</template>

<script setup>
import {ref, computed, watch} from "vue"

const props = defineProps({
    value: {},
    data: {}
})
const emit = defineEmits(['addedId', 'deletedId', 'multiSelect'])

const searchValue = ref()
const multiSelectValue = ref([])
const activeIndex = ref(0)

watch(props.value, (newValue) => {
    multiSelectValue.value = Array.isArray(newValue) ? newValue : [];
}, {immediate: true})

const dropDownId = computed(() => `${props.data.id}-multi-select`)

const options = computed(() => {
    activeIndex.value = -1;
    if (searchValue.value) {
        return props.data.options.filter(option => {
            return option[props.data.listValueField].toLowerCase().includes(searchValue.value.toLowerCase());
        });
    } else return props.data.options;
})

const selectedOptions = computed(() => {
    let chipsList = [];
    multiSelectValue.value.forEach(item => {
        let tempChip = props.data.options.find(chip => chip[props.data.listKeyField] === item);
        if (tempChip) chipsList.push(tempChip)
    })
    return chipsList;
})

const hintText = computed(() => {
    return !props.data.options.length ? 'no_options_found' : (!options.length ? 'did_not_match_anything' : '');

})

const isChipSelected = (value) => {
    return multiSelectValue.value.includes(value);
}
const addChips = (chip) => {
    multiSelectValue.value.push(chip[props.data.listKeyField]);
    emit('addedId', chip[props.data.listKeyField]);
    changed();
    searchValue.value = '';
}
const deleteChips = (event, chip) => {
    event.stopPropagation();
    let index = multiSelectValue.value.indexOf(chip[props.data.listKeyField])
    multiSelectValue.value.splice(index, 1);
    emit('deletedId', chip[props.data.listKeyField]);
    changed();
}
const changed = () => {
    emit('multiSelect', multiSelectValue.value);
}

</script>
