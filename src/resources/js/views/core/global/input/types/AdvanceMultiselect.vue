<template>
    <div class="dropdown search-select-filter keep-dropdown-open">
        <div
            v-if="data.showType === 'input-field'"
            :id="`advanceMultiSelect-${dropDownId}`"
            data-bs-toggle="dropdown"
            aria-expanded="false"
            class="multi-select-control dropdown-toggle cursor-pointer"
            @click="getOptionsByClick"
        >
            <template v-if="multiSelectValue.length">
        <span
            @click.prevent="$event.stopPropagation()"
            v-for="(item, index) in multiSelectValue"
            class="badge p-1 px-2 me-2 mb-2"
        >
          {{ item[data.listValueField] }}
          <a
              href="#"
              class="ms-2 fs-5 d-flex align-items-center"
              @click.prevent="deleteItems($event, item)"
          >
            <i class="bi bi-x" />
          </a>
        </span>
            </template>
            <span v-else>{{ data.chooseLabel }}</span>
        </div>
        <button
            v-else
            class="btn text-capitalize dropdown-toggle"
            :class="{ 'bg-primary': multiSelectValue.length }"
            type="button"
            :id="`advanceMultiSelect-${dropDownId}`"
            data-bs-toggle="dropdown"
            aria-expanded="false"
        >
            {{ data.chooseLabel }}
            <i
                v-if="multiSelectValue.length"
                @click="clearFilter($event)"
                class="bi bi-x ms-2"
            />
        </button>
        <ul
            class="dropdown-menu"
            :id="dropDownId"
            :aria-labelledby="`advanceMultiSelect-${dropDownId}`"
        >
            <li class="search-wrapper" @click.stop="() => 0">
                <div class="search-input">
                    <i class="bi bi-search search-icon" />
                    <input
                        v-model="search"
                        @input="getSearchValue"
                        placeholder="Search"
                        class="form-control"
                    />
                </div>
            </li>

            <li class="filter-options-wrapper" :id="`options-${dropDownId}`">
                <ul class="p-0 m-0">
                    <li v-for="(option, index) in uniqBy(options, 'id')">
                        <a
                            href="#"
                            class="dropdown-item text-capitalize d-inline-flex justify-content-between"
                            :class="{ 'bg-base': isSelected(option[data.listKeyField]) }"
                            @click.prevent="changeSelectFilter(option)"
                        >
                            {{ option[data.listValueField] }}
                            <i
                                v-if="isSelected(option[data.listKeyField])"
                                class="bi bi-check2-circle"
                            />
                        </a>
                    </li>
                    <li v-if="preloader">
                        <app-loader class="py-4 w-100" />
                    </li>
                    <observer @intersect="fetchData" />
                </ul>
            </li>
        </ul>
    </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { debounce as _debounce } from "lodash";
import Observer from "@/core/global/helpers/component/Observer.vue";
import Axios from "@services/axios";
import { uniqBy } from "lodash";

const props = defineProps({
    data: {},
    value: {},
});

const emit = defineEmits(["advanceMultiSelect"]);

const options = ref([]);
const search = ref("");
const currentPage = ref(1);
const multiSelectValue = ref([]);
const loadingLength = ref(props.data.loadingLength);
const getSearchValue = _debounce(() => {
    afterSearch();
}, 500);
const totalRow = ref(0);
const preloader = ref(false);
const initialOption = ref([]);

const dropDownId = computed(() => `${props.data.id}-multi-select`);

const isSelected = (item) => {
    return (
        multiSelectValue.value.findIndex(
            (e) => e[props.data.listKeyField] == item
        ) !== -1
    );
};
const getOptionsByClick = () => {
    if (
        (props.value && props.value.length === options.value.length) ||
        options.value.length === 0
    ) {
        getOptions();
    }
};
const loadMore = () => {
    currentPage.value++;
    getOptions();
};
const afterSearch = () => {
    currentPage.value = 1;
    options.value = [...initialOption.value];
    getOptions();
};

const getInitialOption = () => {
    if (!props.data.fetchUrl) {
        console.warn("You should give fetch-url in advance search");
        return;
    }

    return Axios.get(props.data.fetchUrl, {
        params: {
            [props.data.queryAttributeName]: props.value.toString(),
        },
    }).then((res) => {
        initialOption.value = [...res.data.data];
        multiSelectValue.value = [...initialOption.value];
        options.value = [...initialOption.value];
        return res;
    });
};
const getOptions = async () => {
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
        if (props.value) {
            options.value = [
                ...options.value,
                ...res.data.data.filter((item) => {
                    return !initialOption.value.find(
                        (e) => e[props.data.listKeyField] == item[props.data.listKeyField]
                    );
                }),
            ];
        } else options.value = [...options.value, ...res.data.data];
        totalRow.value = res.data.total;
        preloader.value = false;
    });
};

const fetchData = () => {
    if (options.value.length < totalRow.value && !preloader.value) {
        loadMore();
    }
};
const changeSelectFilter = (option) => {
    let elementIndex = multiSelectValue.value.findIndex(
        (e) => e[props.data.listKeyField] == option[props.data.listKeyField]
    );
    if (elementIndex === -1) multiSelectValue.value.push(option);
    else multiSelectValue.value.splice(elementIndex, 1);
    sendEvent();
    removeDropdownShow();
};

const deleteItems = (e, item) => {
    e.stopPropagation();
    changeSelectFilter(item);
};

const clearFilter = (e) => {
    search.value = "";
    multiSelectValue.value = [];
    sendEvent();
    afterSearch();
    e.stopPropagation();
    removeDropdownShow();
};

const sendEvent = () => {
    emit(
        "advanceMultiSelect",
        multiSelectValue.value.map((e) => e[props.data.listKeyField])
    );
};

const removeDropdownShow = () => {
    let dropDownMenu = document.getElementById(dropDownId.value),
        button = document.getElementById(`advanceMultiSelect-${dropDownId.value}`);
    dropDownMenu.classList.remove("show");
    button.classList.remove("show");
};

onMounted(() => {
    if (props.value && props.value.length > 0) {
        getInitialOption();
    }
});
</script>
