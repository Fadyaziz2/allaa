<template>
    <div :id="data.id" class="custom-form-select" v-click-outside="hideDropdown">
        <div class="selected position-relative" :class="{open: open}" @click="open = !open">
            {{ selectedOption ? selectedOption[data.listValueField] : data.chooseLabel }}

            <div class="close-search" v-if="!isUndefined(selectedOption) && data.selectedDisable" @click.prevent="clearOption()"><i
                class="bi bi-x-circle"></i>
            </div>
            <i v-else class="bi bi-chevron-down"/>

        </div>
        <div class="select-dropdown" :class="{'d-none': !open}">
            <div v-if="data.showSearch" class="item-search-wrapper mt-2">
                <div class="search-input">
                    <i class="bi bi-search search-icon ms-3"/>
                    <input :placeholder="$t('search')" class="form-control rounded-default px-3 ps-5"
                           v-model="searchQuery">
                </div>
            </div>
            <div class="items-wrapper custom-scrollbar">
                <div class="item"
                     :class="{'active-item': i === activeIndex}"
                     v-for="(option, i) of searchResultQuery" :key="i"
                     @click="selectItem(option, i)">
                    {{ option[data.listValueField] || $t('no_label') }}
                </div>
                <div v-if="searchResultQuery.length === 0"
                     class="item text-center">
                    {{ $t('no_match_found') }}
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import {ref, computed, onUnmounted, onBeforeMount} from "vue"
import {useCoreAppFunction} from "@/core/global/helpers/CoreLibrary";

const props = defineProps({
    value: {},
    data: {}
})

const emit = defineEmits(['selectInput'])

const {isUndefined} = useCoreAppFunction()

const searchQuery = ref('')
const activeIndex = ref(0)

const selectedOption = computed(() => props.data.options.find(item => item[props.data.listKeyField] === props.value))

const searchResultQuery = computed(() => {
        if (searchQuery.value) {
            return props.data.options.filter(item => {
                activeIndex.value = 0;
                return item[props.data.listValueField].toLowerCase().includes(searchQuery.value.toLowerCase());
            });
        } else {
            return props.data.options;
        }
    }
)

const clearOption = () => {
    emit('selectInput', '');
    searchQuery.value = ''
    hideDropdown()
}

const open = ref(false)
const hideDropdown = () => {
    open.value = false
}

const selectItem = (item, i) => {
    emit('selectInput', item);
    open.value = false;
    activeIndex.value = i;
}

const navigateItem = (e) => {
    if (e.keyCode === 38 && activeIndex.value > 0) {
        activeIndex.value--
    } else if (e.keyCode === 40) {
        if (activeIndex.value < searchResultQuery.length - 1) {
            activeIndex.value++
        }
    } else if (e.keyCode === 13) {
        e.preventDefault();
        selectItem(searchResultQuery[activeIndex.value])
    }
}
onBeforeMount(() => {
    if (typeof window !== 'undefined' && props.data.keyboardNavigation) {
        document.addEventListener('keyup', navigateItem);
    }
})
onUnmounted(() => {
    if (typeof window !== 'undefined' && props.data.keyboardNavigation) {
        document.removeEventListener('keyup', navigateItem);
    }
});
</script>


<style lang="scss">
.close-search {
    position: absolute;
    right: 7px;
    top: 7px;
    font-size: 1.3rem;
    color: var(--font-color);
    cursor: pointer;
    opacity: 0.5;

    &:hover {
        opacity: 1;
    }

}
</style>
