<template>
    <div class="dropdown search-select-filter">
        <div
            v-if="data.showType === 'input-field'"
            class="multi-select-control dropdown-toggle d-flex justify-content-between align-items-center cursor-pointer text-truncate"
            :id="`advanceSearch-${dropDownId}`"
            data-bs-toggle="dropdown"
            aria-expanded="false"
            :aria-disabled="!!(value && data.selectedDisable)"
            :disabled="!!(value && data.selectedDisable)"
            @click="getOptionsByClick"
        >
            <span>
                {{
                    selectedOption[data.listValueField] && value
                        ? selectedOption[data.listValueField]
                        : data.chooseLabel
                }}</span
            >

            <div
                v-if="
                    !isUndefined(value) &&
                    !isUndefined(selectedOption) &&
                    Object.keys(selectedOption).length > 0 &&
                    data.selectedDisable
                "
                class="close-search"
                @click="clearOption($event)"
            >
                <i class="bi bi-x-circle"></i>
            </div>
            <i v-else class="bi bi-chevron-down close-search"></i>
        </div>
        <button
            v-else
            class="btn text-capitalize dropdown-toggle"
            :class="{ 'bg-brand': value }"
            type="button"
            :id="`advanceSearch-${dropDownId}`"
            data-bs-toggle="dropdown"
            aria-expanded="false"
            @click="getOptionsByClick"
        >
            {{ data.chooseLabel }}
            <i v-if="value" @click="clearFilter($event)" class="bi bi-x ms-2" />
        </button>
        <ul
            class="dropdown-menu custom-scrollbar overflow-auto"
            :id="dropDownId"
            :aria-labelledby="`advanceSearch-${dropDownId}`"
        >
            <li class="search-wrapper" @click.stop="() => 0">
                <div class="search-input">
                    <i class="bi bi-search search-icon" />
                    <input
                        v-model="search"
                        @input="getSearchValue"
                        :placeholder="$t('search')"
                        class="form-control"
                    />
                </div>
            </li>

            <li
                class="filter-options-wrapper custom-scrollbar"
                :id="`options-${dropDownId}`"
                ref="dropdownScroll"
            >
                <ul class="p-0 m-0">
                    <li v-for="(option, index) in options" :key="index">
                        <a
                            href="#"
                            class="dropdown-item text-capitalize d-inline-flex justify-content-between"
                            :class="{
                                'bg-base': value == option[data.listKeyField],
                            }"
                            @click.prevent="changeSelectFilter(option)"
                        >
                            {{ option[data.listValueField] }}
                            <i
                                v-if="value == option[data.listKeyField]"
                                class="bi bi-check2-circle"
                            />
                        </a>
                    </li>
                    <li v-if="preloader">
                        <app-loader class="py-4 w-100" />
                    </li>
                </ul>
            </li>
        </ul>
    </div>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeMount } from "vue";
import { debounce as _debounce } from "lodash";
import Axios from "@services/axios";
import { useCoreAppFunction } from "@/core/global/helpers/CoreLibrary";

const props = defineProps({
    data: {},
    value: {},
});

const emit = defineEmits(["searchSelect"]);
const { isUndefined } = useCoreAppFunction();

const options = ref([]);
const search = ref("");
const currentPage = ref(1);
const loadingLength = ref(props.data.loadingLength);
const getSearchValue = _debounce(() => {
    afterSearch();
}, 500);
const totalRow = ref(0);
const preloader = ref(false);
const selectedOption = ref({});
const initialOption = ref([]);

const dropDownId = computed(() => `${props.data.id}-multi-select`);
const getOptionsByClick = () => {
    if (options.value.length === 0) {
        getOptions();
    }
};
const loadMore = () => {
    currentPage.value++;
    getOptions();
};

const afterSearch = () => {
    currentPage.value = 1;
    getOptions(null);
};

const getInitialOption = () => {
    if (!props.data.fetchUrl) {
        console.warn("You should give fetch-url in advance search");
        return;
    }
    Axios.get(props.data.fetchUrl, {
        params: {
            [props.data.queryAttributeName]: props.value,
        },
    }).then((res) => {
        selectedOption.value = res.data.data.find(
            (item) => props.value == item[props.data.listKeyField]
        );
        initialOption.value = [selectedOption.value];
        options.value = [...initialOption.value];
    });
};

const getOptions = (getType = "loadmore") => {
    preloader.value = true;
    if (!props.data.fetchUrl) {
        console.warn("You should give fetch-url in advance search");
        return;
    }
    let url = props.data.fetchUrl,
        requestData = {};
    requestData.params = {
        search: search.value,
        page: currentPage.value,
        per_page: loadingLength.value,
    };
    Axios.get(url, requestData).then((res) => {
        if (getType === "loadmore") {
            options.value = [...options.value, ...res.data.data];
        } else {
            options.value = [...res.data.data];
        }
        totalRow.value = res.data.total;
        preloader.value = false;
    });
};

const changeSelectFilter = (option) => {
    selectedOption.value = option;
    emit("searchSelect", option);
};
const clearOption = (e) => {
    clearFilter(e);
};
const clearFilter = (e) => {
    search.value = "";
    selectedOption.value = {};
    emit("searchSelect", "");
    currentPage.value = 1;
    getOptions(null);
    e.stopPropagation();
};
const dropdownScroll = ref();

const dropdownOnScroll = () => {
    dropdownScroll.value.addEventListener("scroll", () => {
        if (
            dropdownScroll.value.scrollTop +
                dropdownScroll.value.clientHeight >=
            dropdownScroll.value.scrollHeight
        ) {
            if (options.value.length < totalRow.value && !preloader.value) {
                loadMore();
            }
        }
    });
};
onMounted(() => {
    dropdownOnScroll();
});

onBeforeMount(() => {
    if (props.value && props.data.showType !== "filter") {
        getInitialOption();
    }
});
</script>

<style lang="scss">
.close-search {
    position: absolute;
    right: 10px;
    top: 8px;
    font-size: 1.3rem;
    color: var(--font-color);
    cursor: pointer;
    opacity: 0.5;

    &:hover {
        opacity: 1;
    }
}

#advanceSearch-users-multi-select {
    cursor: pointer;
    &[aria-expanded="true"] {
        .bi-chevron-down {
            transform: rotate(180deg);
        }
    }
}
</style>
