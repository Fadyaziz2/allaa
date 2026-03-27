<template>
    <div class="datatable-wrapper">
        <div class="filters-wrapper">
            <div
                class="d-flex flex-wrap align-items-start justify-content-between"
            >
                <div
                    class="search-input flex-shrink-0 mb-3 search-and-filter-btn"
                    v-if="options.showSearch"
                >
                    <i class="bi bi-search fs-6 search-icon"/>
                    <input
                        :placeholder="$t('search')"
                        v-model="searchValue"
                        @input="getSearchValue($event)"
                        class="form-control form-control-sm bg-card border-transparent shadow-default rounded-default"
                    />
                </div>
                <div class="d-flex flex-wrap align-items-start">
                    <button
                        v-if="options.showGridView"
                        type="button"
                        class="btn btn-white flex-shrink-0 mb-2 me-2"
                    >
                        <template v-if="!gridView">
                            <i class="bi bi-grid fs-6 me-1"/>
                            {{ $t("grid_view") }}
                        </template>
                        <template v-else>
                            <i class="bi bi-list-task fs-6 me-1"/>
                            {{ $t("list_view") }}
                        </template>
                    </button>
                    <div v-if="options.showFilter" @click="updateQuery">
                        <button
                            type="button"
                            class="btn btn-white flex-shrink-0 search-and-filter-btn mb-3"
                            data-bs-toggle="collapse"
                            data-bs-target="#filterCollapse"
                            aria-expanded="false"
                            aria-controls="filterCollapse"
                        >
                            <i class="bi bi-funnel fs-6 me-1"/>
                            {{ $t("filter") }}
                        </button>
                    </div>
                    <button
                        v-if="!isUndefined(options.exportData) && options.exportPermission"
                        @click.prevent="options.exportData"
                        type="button"
                        class="btn btn-white flex-shrink-0 search-and-filter-btn mb-3 ms-2"
                    >
                        <i class="bi bi-box-arrow-up-right fs-6 me-1"/>
                        {{ $t("export") }}
                    </button>
                    <button
                        v-if="!isUndefined(options.importData)"
                        @click.prevent="options.importData"
                        type="button"
                        class="btn btn-white flex-shrink-0 mb-2"
                    >
                        <i class="bi bi-box-arrow-in-down-left fs-6 me-1"/>
                        {{ $t("import") }}
                    </button>
                </div>
            </div>
            <div
                class="collapse mb-3"
                :class="{
                    show: $route.query.filter === 'open',
                }"
                id="filterCollapse"
                v-if="options.showFilter"
            >
                <app-filter
                    :filters="options.filters"
                    @applyFilter="applyFilter"
                />
            </div>
        </div>
        <div
            v-if="
                dataSetList.data &&
                selectedRows.length === dataSetList.data.length &&
                options.enableBulkSelect
            "
            class="text-secondary text-center card-bg"
        >
            <p v-if="!isBulkSelect">
                <a href="#" @click.prevent="afterBulkSelect">
                    {{ $t("select_all") }} {{ totalRow }} {{ $t("items") }}
                </a>
            </p>
            <template v-else>
                <p class="text-primary">
                    {{ $t("selected") }} {{ totalRow }} {{ $t("items") }} |
                    <a href="#" @click.prevent="clearAllSelection">
                        {{ $t("clear_all_selection") }}
                    </a>
                </p>
            </template>
        </div>
        <div class="data-wrapper">
            <div
                class="table-responsive position-relative rounded-default custom-scrollbar"
                :class="{
                    'd-flex align-items-center justify-content-center': loading,
                }"
                :style="[
                    !isUndefined(options.boxShadow) &&
                    options.boxShadow === false
                        ? 'box-shadow:none'
                        : 'box-shadow: var(--box-shadow)',
                ]"
            >
                <app-loader v-if="loading"/>
                <table
                    v-else
                    class="table text-nowrap"
                    :class="{ 'table-striped': options.stripedTable }"
                >
                    <thead>
                    <tr>
                        <th style="width: 2rem" v-if="rowSelectEnable">
                            <i
                                v-if="
                                        selectedRows.length ===
                                        dataSetList.data.length
                                    "
                                @click.prevent="selectedRows = []"
                                class="cursor-pointer bi bi-check2-circle"
                            >
                            </i>
                            <i
                                v-else
                                @click.prevent="
                                        selectedRows = [...dataSetList.data]
                                    "
                                class="cursor-pointer bi bi-circle"
                            >
                            </i>
                        </th>
                        <template
                            v-for="(manageColumn, index) in options.columns"
                            :key="index"
                        >
                            <th
                                v-if="manageColumn.permission !== false"
                                :class="{
                                        'text-start':
                                            manageColumn.align === 'left',
                                        'text-center':
                                            manageColumn.align === 'center',
                                        'text-end':
                                            manageColumn.align === 'right',
                                    }"
                            >
                                {{ manageColumn.title }}
                            </th>
                        </template>
                    </tr>
                    </thead>
                    <tbody>
                    <template
                        v-if="
                                dataSetList.data && dataSetList.data.length > 0
                            "
                    >
                        <tr
                            v-if="dataSetList.data.length > 0"
                            v-for="(row, rowIndex) in dataSetList.data"
                            :key="'row' + rowIndex"
                        >
                            <td v-if="rowSelectEnable">
                                <i
                                    v-if="isSelected(row)"
                                    @click.prevent="
                                            removeFromSelection(row)
                                        "
                                    class="cursor-pointer bi bi-check2-circle"
                                ></i>
                                <i
                                    v-else
                                    @click.prevent="selectedRows.push(row)"
                                    class="cursor-pointer bi bi-circle"
                                ></i>
                            </td>
                            <template
                                v-for="(
                                        column, columnIndex
                                    ) in options.columns"
                            >
                                <td
                                    v-if="column.permission !== false"
                                    :key="'column' + rowIndex + columnIndex"
                                    :class="{
                                            'text-start':
                                                column.align === 'left',
                                            'text-end':
                                                column.align === 'right',
                                            'text-center':
                                                column.align === 'center',
                                            'pt-0 border-top-0':
                                                options.showHeader === false &&
                                                rowIndex === 0,
                                        }"
                                >
                                    <!-- Text Type Column -->
                                    <span
                                        v-if="column.type === 'text'"
                                        :key="`text-${rowIndex}${columnIndex}`"
                                    >
                                            {{ row[column.key] }}
                                        </span>

                                    <!-- Link Type Column -->
                                    <span
                                        v-if="column.type === 'link'"
                                        :key="`link-${rowIndex}${columnIndex}`"
                                    >
                                            <a
                                                :href="
                                                    getAppUrl(
                                                        column.modifier(
                                                            row[column.key],
                                                            row
                                                        )
                                                    )
                                                "
                                            >
                                                {{ row[column.key] }}
                                            </a>
                                        </span>

                                    <!-- Object Type Column -->
                                    <span
                                        v-else-if="column.type === 'object'"
                                        :key="`object-${rowIndex}${columnIndex}`"
                                    >
                                            {{
                                            column.modifier(
                                                row[column.key],
                                                row
                                            )
                                        }}
                                        </span>

                                    <!-- Custom Component Type Column -->
                                    <span
                                        v-else-if="
                                                column.type === 'component'
                                            "
                                        :key="`component-${rowIndex}${columnIndex}`"
                                    >
                                            <component
                                                :is="column.componentName"
                                                :value="row[column.key]"
                                                :row-data="row"
                                                :table-id="id"
                                                :index="columnIndex"
                                            />
                                        </span>

                                    <!-- Custom HTML Type Column -->
                                    <span
                                        v-else-if="
                                                column.type === 'custom-html'
                                            "
                                        :key="
                                                'custom-html-' +
                                                rowIndex +
                                                columnIndex
                                            "
                                        v-html="
                                                column.modifier(
                                                    row[column.key],
                                                    row
                                                )
                                            "
                                    >
                                        </span>

                                    <!-- Custom Class Type Column -->
                                    <span
                                        v-else-if="
                                                column.type === 'custom-class'
                                            "
                                        :key="
                                                'custom-class-' +
                                                rowIndex +
                                                columnIndex
                                            "
                                        :class="
                                                column.modifier(
                                                    row[column.key],
                                                    row
                                                )
                                            "
                                    >
                                            {{ row[column.key] }}
                                        </span>

                                    <!-- Button Type Column -->
                                    <span
                                        v-else-if="column.type === 'button'"
                                        :key="
                                                'column-button-' +
                                                rowIndex +
                                                columnIndex
                                            "
                                    >
                                            <button
                                                v-if="
                                                    column.modifier(
                                                        row[column.key],
                                                        row
                                                    ) !== false
                                                "
                                                :class="[
                                                    column.className
                                                        ? column.className
                                                        : 'btn btn-primary',
                                                ]"
                                                @click="
                                                    getButtonValue(row, column)
                                                "
                                            >
                                                {{ column.label }}
                                                <!--                                        <icon v-if="column.icon" :name="column.icon"/>-->
                                                {{
                                                    column.modifier(
                                                        row[column.key],
                                                        row
                                                    )
                                                }}
                                            </button>
                                        </span>

                                    <!--                                Action Type Column-->
                                    <span
                                        v-else-if="column.type === 'action'"
                                        :key="
                                                'column-action-' +
                                                rowIndex +
                                                columnIndex
                                            "
                                    >
                                            <dropdown-action
                                                v-if="
                                                    options.actionType ===
                                                    'dropdown'
                                                "
                                                :key="
                                                    options.actionType +
                                                    columnIndex
                                                "
                                                :actions="options.actions"
                                                :row-data="row"
                                                @action="bothAction"
                                            />
                                        </span>
                                </td>
                            </template>
                        </tr>
                    </template>

                    <template
                        v-if="
                                isAnyAccountableColumns &&
                                dataSetList.data.length
                            "
                    >
                        <!-- Total -->
                        <tr>
                            <td v-if="options.enableRowSelect"></td>
                            <td
                                v-for="(
                                        column, columnIndex
                                    ) in IsAccountableColumnsFilter"
                                class="datatable-td"
                                :key="'total-column' + columnIndex"
                            >
                                    <span
                                        v-if="column.accountAble"
                                        class="fw-bold"
                                    >
                                        {{
                                            numberFormatter(columnTotal(column))
                                        }}
                                    </span>
                                <span class="d-block text-left" v-else>
                                        {{
                                        columnIndex === 0 ? $t("total") : ""
                                    }}
                                    </span>
                            </td>
                        </tr>
                        <!-- Grand total -->
                        <tr>
                            <td v-if="options.enableRowSelect"></td>

                            <td
                                class="datatable-td"
                                v-for="(
                                        column, columnIndex
                                    ) in IsAccountableColumnsFilter"
                                :key="'grand-total-column' + columnIndex"
                            >
                                    <span
                                        v-if="column.accountAble"
                                        class="fw-bold"
                                    >
                                        {{
                                            numberFormatter(
                                                grandTotal[column.key]
                                            )
                                        }}
                                    </span>
                                <span class="d-block text-left" v-else>
                                        {{
                                        columnIndex === 0
                                            ? $t("grand_total")
                                            : ""
                                    }}
                                    </span>
                            </td>
                        </tr>
                    </template>
                    </tbody>
                </table>
                <empty-message
                    v-if="
                        dataSetList.data &&
                        dataSetList.data.length === 0 &&
                        !loading
                    "
                />
            </div>
        </div>

        <div
            class="mt-5 footer-paginate d-flex gap-3 justify-content-center justify-content-lg-between align-items-center"
            v-if="totalRow > options.rowLimit && dataSetList.data.length && options.showPagination !== false"
        >
            <div class="text-center text-sm-start">
                {{ $t("showing") }} {{ dataSetList.from }} {{ $t("to") }}
                {{ dataSetList.to }} {{ $t("of") }} {{ totalRow }}
                {{ $t("entries") }}
            </div>
            <div class="right-portion text-nowrap gap-3 mt-md-0">
                <div
                    class="pages-infos d-flex flex-wrap text-nowrap gap-3 justify-content-center"
                >
                    <div class="items">
                        <label for="" class="me-2"
                        >{{ $t("show_per_page") }}:</label
                        >
                        <select class="page-input" @change="getByPerPage">
                            <option
                                v-for="(perPage, i) in perPageValues"
                                :value="perPage"
                                :key="i"
                            >
                                {{ perPage }}
                            </option>
                        </select>
                    </div>
                    <div class="items">
                        <label for="" class="me-2"
                        >{{ $t("go_to_page") }}:</label
                        >
                        <input
                            type="number"
                            class="page-input"
                            @input="goToPage"
                        />
                    </div>
                    <paginate
                        :current-page="activePaginationPage"
                        :total-pages="dataSetList.last_page"
                        @paginate="getPaginateData"
                    />
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import {ref, watch, computed, onMounted, onBeforeMount} from "vue";
import {
    objectToQueryString,
    queryStringToObject,
} from "@/core/global/helpers/QueryHelper";
import useEmitter from "@/core/global/composable/useEmitter";
import {debounce as _debounce} from "lodash";
import {useCoreAppFunction} from "@/core/global/helpers/CoreLibrary";
import Paginate from "@/core/global/datatable/Paginate.vue";
import EmptyMessage from "@/core/global/datatable/EmptyMessage.vue";
import DropdownAction from "@/core/global/datatable/DropdownAction.vue";
import Axios from "@services/axios";
import LoaderDataTable from "@/core/global/loader/LoaderDataTable.vue";
import {numberWithCurrencySymbol} from "@utilities/helpers";

const props = defineProps({
    id: {
        required: true,
        type: String,
    },
    options: {
        required: true,
        type: Object,
    },
});

const emit = defineEmits(["afterRowSelect", "action"]);

const emitter = useEmitter();
const loading = ref(false);
const dataSetList = ref([]);
const filterValues = ref({});
const activePaginationPage = ref(1);
const totalRow = ref(0);
const searchValue = ref("");
const gridView = ref(false);

const getSearchValue = _debounce(() => {
    emitter.emit("reload-" + props.id);
}, 500);
const selectedRows = ref([]);
const isBulkSelect = ref(false);
const grandTotal = ref({});

const {isUndefined, getAppUrl} = useCoreAppFunction();
const rowSelectEnable = computed(
    () =>
        !isUndefined(props.options.enableRowSelect) &&
        props.options.enableRowSelect
);
const isAnyAccountableColumns = computed(() =>
    props.options.columns
        ? props.options.columns.filter(
            (column) => column.permission !== false && column.accountAble
        ).length
        : 0
);

const IsAccountableColumnsFilter = computed(() => {
    return props.options.columns.filter(
        (column) => column.permission !== false
    );
});

watch(selectedRows.value, (newValue) => {
    isBulkSelect.value = false;
    afterRowSelection();
});

const afterBulkSelect = () => {
    isBulkSelect.value = true;
    afterRowSelection();
};

const clearAllSelection = () => {
    isBulkSelect.value = false;
    selectedRows.value = [];
};
const removeFromSelection = (row) => {
    let index = selectedRows.value.indexOf(row);
    selectedRows.value.splice(index, 1);
};

const isSelected = (row) => {
    return selectedRows.value.includes(row);
};
const afterRowSelection = () => {
    emit("afterRowSelect", {
        rows: selectedRows.value,
        all: isBulkSelect.value,
    });
};
const getServerData = () => {
    let URL = props.options.url,
        filter = filterValues.value,
        requestData = {};
    filter.page = activePaginationPage.value;
    filter.per_page = filterValues.value.per_page || 10;
    filter.filter = filterValues.value.filter || "close";
    filter.search = searchValue.value;

    if (filterValues.value.date) {
        filter.date =
            typeof filterValues.value.date == "string"
                ? JSON.parse(filterValues.value.date)
                : filterValues.value.date;
    }

    let query = objectToQueryString(filter),
        pageTitle = document.title;
    requestData.params = filter;
    history.replaceState({...history.state}, pageTitle, `?${query}`);
    loading.value = true;
    Axios.get(URL, requestData)
        .then((response) => {
            dataSetList.value = response.data;
            totalRow.value = response.data.total;
            grandTotal.value = response.data.grand_total;
            selectedRows.value = [];
        })
        .finally(() => (loading.value = false));
};

const getPaginateData = (page) => {
    activePaginationPage.value = page;
    getServerData();
};

const reloadDataTable = () => {
    emitter.on("reload-" + props.id, (value = true) => {
        if (value) {
            let queryObj = queryStringToObject();
            if (queryObj.page) {
                if (dataSetList.value.data?.length - 1 > 0) {
                    activePaginationPage.value = Number(queryObj.page);
                } else {
                    activePaginationPage.value =
                        Number(queryObj.page) === 1
                            ? Number(queryObj.page)
                            : Number(queryObj.page - 1);
                }
            }

            getServerData();
        }
    });
};
const bothAction = (row, action, index) => {
    emit("action", row, action, index);
};

const getButtonValue = (row, column) => {
    emit("action", row, column, true);
};
const applyFilter = (values) => {
    filterValues.value = {...filterValues.value, ...values};

    let o = Object.fromEntries(
        Object.entries(filterValues.value).filter(([_, v]) => !!v)
    );
    filterValues.value.filter = Object.keys(o).length > 3 ? "open" : "close";
    setTimeout(() => {
        emitter.emit("reload-" + props.id);
    });
};
const initState = () => {
    let queryObj = queryStringToObject();
    if (queryObj.search) searchValue.value = queryObj.search;
    if (queryObj.page) activePaginationPage.value = Number(queryObj.page);
    filterValues.value = {...queryObj};
    for (const [key, value] of Object.entries(queryObj)) {
        let filter = props.options?.filters?.find((item) => item.key === key);
        if (filter) filter.active = value;
    }
    getServerData();
};

const columnTotal = (column) => {
    let isNotAccountAble = isNaN(dataSetList.value.data[0][column.key]);
    if (isNotAccountAble) {
        console.warn(column.key, "Impossible to Sum");
        return "";
    } else {
        return dataSetList.value.data.reduce(
            (total, current) => (total += Number(current[column.key])),
            0
        );
    }
};
const numberFormatter = (value) => numberWithCurrencySymbol(value);

const perPageValues = ref([10, 30, 50, 100, 200]);
const getByPerPage = (e) => {
    activePaginationPage.value = 1;
    filterValues.value.per_page = parseInt(e.currentTarget.value);
    getServerData();
};
const toPage = ref(1);
const goToPage = (e) => {
    toPage.value = parseInt(e.currentTarget.value);
    updatePage();
};
const updatePage = _debounce(() => {
    if (
        toPage.value &&
        toPage.value > 0 &&
        toPage.value <= dataSetList.value.last_page
    ) {
        activePaginationPage.value = toPage.value;
        getServerData();
    }
}, 500);

const updateQuery = () => {
    if ((filterValues.value.filter = "open")) {
        filterValues.value.filter = "close";
    }

    let query = objectToQueryString(filterValues.value),
        pageTitle = document.title;
    history.replaceState({...history.state}, pageTitle, `?${query}`);
};

onMounted(() => {
    let keepOpenDropdowns = document.querySelectorAll(
        ".keep-dropdown-open .dropdown-menu"
    );
    keepOpenDropdowns.forEach((item) => {
        item.addEventListener("click", (e) => {
            e.stopPropagation();
        });
    });

    reloadDataTable();
});

onBeforeMount(() => {
    initState();
});
</script>
