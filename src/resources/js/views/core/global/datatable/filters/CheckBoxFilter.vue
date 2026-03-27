<template>
    <div class="filter search-select-filter">
        <div class="dropdown keep-dropdown-open">
            <button
                class="btn btn-filter dropdown-toggle"
                :class="{ 'bg-brand': checkedValues.length }"
                type="button"
                :id="`searchAndSelectFilter-${dropDownId}`"
                data-bs-toggle="dropdown"
                aria-expanded="false"
            >
                {{ label }}
                <i
                    v-if="checkedValues.length"
                    @click="clearFilter($event)"
                    class="bi bi-x ms-2"
                />
            </button>
            <div
                class="dropdown-menu custom-scrollbar overflow-auto"
                :id="dropDownId"
                :aria-labelledby="`searchAndSelectFilter-${dropDownId}`"
            >
                <div class="p-4">
                    <div class="checkboxfilter">
                        <div
                            class="form-check mb-1 d-flex gap-3 checkboxfilterinputfield"
                            v-for="(option, index) in filterOptions"
                            :key="'checkbox-filter-' + index"
                        >
                            <input
                                class="form-check-input"
                                type="checkbox"
                                :value="option.id"
                                :id="option.id"
                                v-model="checkedValues"
                            />
                            <label
                                class="form-check-label fw-semibold fs-5 checkboxfilterinputlabel"
                                :for="option.id"
                            >
                                {{ option.name }}
                            </label>
                        </div>
                    </div>

                    <div
                        class="d-flex align-items-center justify-content-between mt-4"
                    >
                        <button
                            type="button"
                            class="btn btn-sm btn-secondary"
                            @click.prevent="clearFilter"
                        >
                            {{ $t("cancel") }}
                        </button>
                        <button
                            type="button"
                            class="btn btn-sm btn-primary"
                            @click.prevent="applyFilter"
                        >
                            {{ $t("apply") }}
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";

const props = defineProps({
    label: {},
    filterKey: {},
    filterOptions: {},
    active: {},
});

const emit = defineEmits(["applyFilter"]);

const isApplied = ref(false);
const checkedValues = ref([]);

const dropDownId = computed(() => `${props.filterKey}-${props.label}`);

const changeFilter = () => {
    let filterObj = {},
        value = checkedValues.value.toString();
    filterObj[props.filterKey] = value;
    emit("applyFilter", filterObj);
    let dropDownMenu = document.getElementById(dropDownId.value),
        button = document.getElementById(
            `searchAndSelectFilter-${dropDownId.value}`
        );
    dropDownMenu.classList.remove("show");
    button.classList.remove("show");
};
const clearFilter = () => {
    checkedValues.value = [];
    isApplied.value = false;
    changeFilter();
};
const applyFilter = () => {
    isApplied.value = true;
    changeFilter();
};

onMounted(() => {
    if (props.active) {
        checkedValues.value = props.active.split(",");
        isApplied.value = true;
    }
});
</script>
