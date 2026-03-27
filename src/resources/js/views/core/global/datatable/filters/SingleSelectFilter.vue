<template>
    <div class="filter search-select-filter">
        <div class="dropdown keep-dropdown-open">
            <button class="btn btn-filter text-capitalize dropdown-toggle" :class="{'bg-brand' : isApplied}"
                    type="button"
                    :id="`searchAndSelectFilter-${dropDownId}`"
                    data-bs-toggle="dropdown"
                    aria-expanded="false">
                {{ selectedOption.name ? selectedOption.name : label }}
                <i v-if="isApplied" @click="clearFilter($event)" class="bi bi-x ms-2"/>
            </button>
            <ul class="dropdown-menu custom-scrollbar overflow-auto" :id="dropDownId" :aria-labelledby="`searchAndSelectFilter-${dropDownId}`">
                <li v-if="showSearch" class="search-wrapper">
                    <div class="search-input">
                        <i class="bi bi-search search-icon"/>
                        <input v-model="search" placeholder="Search" class="form-control">
                    </div>
                </li>

                <li class="filter-options-wrapper custom-scrollbar">
                    <ul>
                        <li v-for="(option, index) in options" :key="index">
                            <a href="#" class="dropdown-item" :class="{'active': selectedOption.id === option.id}"
                               @click.prevent="changeSelectFilter(option)">
                                {{ option.name }}
                            </a>
                        </li>
                    </ul>
                </li>

            </ul>
        </div>
    </div>
</template>

<script setup>
import {ref, computed, onMounted} from "vue"

const props = defineProps({
    label: {},
    filterKey: {},
    filterOptions: {},
    showSearch: {
        type: Boolean,
        default: true
    },
    active: {}
})

const emit = defineEmits(['applyFilter'])

const search = ref('')
const isApplied = ref(false)
const selectedOption = ref({})

const dropDownId = computed(() => `${props.filterKey}-${props.label}`)
const options = computed(() => search.value ? props.filterOptions.filter(item => item.name.toLowerCase().includes(search.value.toLowerCase())) : props.filterOptions)

const changeSelectFilter = (option) => {
    selectedOption.value = option;
    let filterObj = {};
    filterObj[props.filterKey] = option.id ? option.id : '';
    emit('applyFilter', filterObj)
    isApplied.value = true;
    let dropDownMenu = document.getElementById(dropDownId.value),
        button = document.getElementById(`searchAndSelectFilter-${dropDownId.value}`);
    dropDownMenu.classList.remove('show');
    button.classList.remove('show');
}
const clearFilter = (e) => {
    e.stopPropagation();
    selectedOption.value = {}
    let filterObj = {};
    filterObj[props.filterKey] = '';
    emit('applyFilter', filterObj)
    isApplied.value = false;
    let dropDownMenu = document.getElementById(dropDownId.value),
        button = document.getElementById(`searchAndSelectFilter-${dropDownId.value}`);
    dropDownMenu.classList.remove('show');
    button.classList.remove('show');
}

onMounted(() => {
    if (props.active) {
        selectedOption.value = {...props.filterOptions.find(item => item.id === props.active)};
        isApplied.value = true;
    }
})
</script>


