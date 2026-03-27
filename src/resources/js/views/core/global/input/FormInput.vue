<template>
    <div>
        <label v-if="label" :for="id" :class="labelClass">
            {{ label }} <span v-if="labelRequired" class="text-danger">*</span>
            <i
                v-if="labelHint"
                class="bi bi-info-circle-fill ms-1"
                data-bs-toggle="tooltip"
                data-bs-html="true"
                data-bs-placement="top"
                :title="labelHint"
            />
        </label>

        <input
            v-if="type === 'text'"
            type="text"
            :value="modelValue"
            class="form-control"
            @input="$emit('update:modelValue', $event.target.value)"
            v-bind="$attrs"
        />

        <input
            v-if="type === 'email'"
            type="email"
            class="form-control"
            :value="modelValue"
            @input="$emit('update:modelValue', $event.target.value)"
            v-bind="$attrs"
        />

        <input
            v-if="type === 'number'"
            type="number"
            class="form-control"
            :value="modelValue"
            @input="$emit('update:modelValue', $event.target.value)"
            v-bind="$attrs"
        />

        <input
            v-if="type === 'tel'"
            type="tel"
            class="form-control"
            :value="modelValue"
            @input="$emit('update:modelValue', $event.target.value)"
            v-bind="$attrs"
        />

        <template v-if="type === 'phone-number'">
            <phone-number-input
                v-bind="$attrs"
                :model-value="modelValue"
                @update:modelValue="
                    (details) => emit('update:modelValue', details)
                "
            />
        </template>

        <textarea
            v-if="type === 'textarea'"
            class="form-control"
            :value="modelValue"
            @input="$emit('update:modelValue', $event.target.value)"
            v-bind="$attrs"
        />

        <password-input
            v-if="type === 'password'"
            :value="modelValue"
            :data="$props"
            @input="$emit('update:modelValue', $event.target.value)"
            v-bind="$attrs"
        />

        <radio-input
            v-else-if="type === 'radio'"
            :value="modelValue"
            :data="$props"
            @radioOption="radioOption($event)"
            v-bind="$attrs"
        />

        <checkbox-input
            v-else-if="type === 'checkbox'"
            :value="modelValue"
            :data="$props"
            @checkboxOption="(value) => $emit('update:modelValue', value)"
            v-bind="$attrs"
        />

        <image-uploader
            v-else-if="type === 'image-uploader'"
            ref="imageUploader"
            :key="'image-uploader'"
            :data="$props"
            :value="modelValue"
            @getFile="(value) => $emit('changeFile', value)"
            v-bind="$attrs"
        />

        <multi-image-uploader
            v-else-if="type === 'multi-image-uploader'"
            :key="'multi-image-uploader'"
            @getFiles="(files) => $emit('changeFile', files)"
            v-bind="$attrs"
            :max-length="maxLength"
            :after-upload-success="afterUploadSuccess"
        />

        <select-input
            v-if="type === 'select'"
            :value="modelValue"
            :data="$props"
            @selectInput="(value) =>$emit('update:modelValue',value ? value[listKeyField] : null)"
            v-bind="$attrs"
        />

        <multi-select-input
            v-if="type === 'multi-select'"
            :value="modelValue"
            :data="$props"
            @multiSelect="(value) => $emit('update:modelValue', value)"
            v-bind="$attrs"
        />

        <advance-search-select
            v-if="type === 'advance-search-select'"
            :value="modelValue"
            :data="$props"
            @searchSelect="
                (value) =>
                    $emit(
                        'update:modelValue',
                        value ? value[listKeyField] : null
                    )
            "
            v-bind="$attrs"
        />

        <advance-multiselect
            v-if="type === 'advance-multi-select'"
            :value="modelValue"
            :data="$props"
            @advanceMultiSelect="(value) => $emit('update:modelValue', value)"
            v-bind="$attrs"
        />

        <vue-date-picker
            v-else-if="type === 'date'"
            v-bind="$attrs"
            :model-value="modelValue"
            @update:model-value="handleDate"
        />

        <VueDatePicker
            v-else-if="type === 'daterange'"
            v-bind="$attrs"
            :model-value="modelValue"
            :format="dateTimeFormat"
            @update:model-value="handleDateRange"
            range
            :preset-ranges="presetRanges"
        >
            <template #yearly="{ label, range, presetDateRange }">
                <span @click="presetDateRange(range)">{{ label }}</span>
            </template>
        </VueDatePicker>

        <quill-editor
            v-else-if="type === 'editor'"
            ref="quill"
            v-model:content="contentData"
            contentType="html"
            @textChange="$emit('update:modelValue', contentData)"
            v-bind="$attrs"
        />

        <!--Validation message-->
        <div
            v-if="!isUndefined(error.errors) && error.errors?.length"
            :key="'error'"
            class="mt-2"
        >
            <small class="text-danger validation-error">
                {{ error.errors }}
            </small>
        </div>
    </div>
</template>

<script setup>
import {ref, watch, computed} from "vue";
import {format} from "date-fns";
import PasswordInput from "@/core/global/input/types/PasswordInput.vue";
import PhoneNumberInput from "@/core/global/input/types/PhoneNumberInput.vue";
import SelectInput from "@/core/global/input/types/SelectInput.vue";
import MultiSelectInput from "@/core/global/input/types/MultiSelectInput.vue";
import AdvanceSearchSelect from "@/core/global/input/types/AdvanceSearchSelect.vue";
import AdvanceMultiselect from "@/core/global/input/types/AdvanceMultiselect.vue";
import RadioInput from "@/core/global/input/types/RadioInput.vue";
import CheckboxInput from "@/core/global/input/types/CheckboxInput.vue";
import ImageUploader from "@/core/global/input/types/ImageUploader.vue";
import MultiImageUploader from "@/core/global/input/types/MultiImageUploader.vue";
import {QuillEditor} from "@vueup/vue-quill";
import "@vueup/vue-quill/dist/vue-quill.snow.css";
import {useCoreAppFunction} from "@/core/global/helpers/CoreLibrary";
import {
    endOfMonth,
    endOfYear,
    startOfMonth,
    startOfYear,
    subMonths,
} from "date-fns";
import VueDatePicker from "@vuepic/vue-datepicker";
import "@vuepic/vue-datepicker/dist/main.css";

const props = defineProps({
    id: {
        type: String,
        require: true,
    },
    label: {
        type: String,
        require: false,
    },
    labelClass: {
        type: String,
        default: "mb-2",
    },
    labelRequired: {
        type: Boolean,
        default: false,
    },
    labelHint: {
        type: String,
    },
    modelValue: {},

    type: {
        type: String,
        default: "text",
    },
    //Password
    showHideEffect: {
        type: Boolean,
        default: true,
    },
    keyboardNavigation: {
        type: Boolean,
        default: false,
    },
    radioCheckboxName: String,
    chooseLabel: {
        type: String,
        default: function () {
            return "select_an_item";
        },
    },
    showSearch: {
        type: Boolean,
        default: false,
    },
    options: {
        type: Array,
    },
    listValueField: {
        type: String,
        default: "value",
    },
    listKeyField: {
        type: String,
        default: "id",
    },

    formCheckInline: {
        type: Boolean,
        default: true,
    },
    formCheckBoxed: {
        type: Boolean,
        default: true,
    },
    customEvent: {
        type: Boolean,
        default: false,
    },
    // Advance
    selectedDisable: {
        type: Boolean,
        default: true,
    },
    fetchUrl: String,
    loadingLength: {
        type: Number,
        default: 50,
        // length must be getter than 10
        validator: (val) => val >= 10,
    },
    queryAttributeName: {
        type: String,
        default: "selected",
    },
    showType: {
        type: String,
        default: "input-field", // user 'filter' if needed.
    },
    generateFileUrl: {
        type: Boolean,
        default: true,
    },
    dateTimeFormat: {
        type: String,
        default: "yyyy-MM-dd",
    },
    phoneDetails: {
        type: Object,
        default: {
            phone_country: "BD",
        },
    },
    maxLength: {
        type: Number,
        default: 1,
    },
    afterUploadSuccess: {
        type: Boolean,
    },
    errors: String,
});
const error = computed(() => {
    return {errors: props.errors};
});
const emit = defineEmits(["update:modelValue", "changeRadio", "changeFile"]);
const presetRanges = ref([
    {label: "Today", range: [new Date(), new Date()]},
    {
        label: "This month",
        range: [startOfMonth(new Date()), endOfMonth(new Date())],
    },
    {
        label: "Last month",
        range: [
            startOfMonth(subMonths(new Date(), 1)),
            endOfMonth(subMonths(new Date(), 1)),
        ],
    },
    {
        label: "This year",
        range: [startOfYear(new Date()), endOfYear(new Date())],
    },
]);
const {isUndefined} = useCoreAppFunction();
const contentData = ref("");
const radioOption = (event) => {
    emit("update:modelValue", event);
    emit("changeRadio", event);
    error.value.errors = "";
};
const quill = ref();
watch(
    () => props.modelValue,
    (newValue) => {
        error.value.errors = "";
        if (newValue) {
            contentData.value = newValue;
        } else {
            contentData.value = "<p></p>";
        }
    },
    {immediate: true, deep: true}
);
const handleDate = (event) => {
    emit("update:modelValue", event);
};
const handleDateRange = (event) => {
    if (!event) {
        emit("update:modelValue", []);
        return;
    }
    emit("update:modelValue", [
        format(event[0], props.dateTimeFormat),
        format(event[1], props.dateTimeFormat),
    ]);
};
const imageUploader = ref();
defineExpose({
    quill,
    imageUploader,
});
</script>
