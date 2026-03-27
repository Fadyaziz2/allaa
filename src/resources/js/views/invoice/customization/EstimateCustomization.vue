<template>
    <app-loader class="mt-4" v-if="getPreloader" />
    <form v-else>
        <div class="mb-4">
            <app-input
                type="text"
                id="invoicePrefix"
                :label="$t('estimate_prefix')"
                label-required
                :placeholder="$t('estimate_prefix')"
                v-model="formData.estimate_prefix"
                :errors="$errors(errors, 'estimate_prefix')"
            />
        </div>

        <div class="mb-4">
            <app-input
                type="text"
                id="invoice_serial_start"
                :label="$t('estimate_serial_start')"
                label-required
                :placeholder="$t('estimate_serial_start')"
                v-model="formData.estimate_serial_start"
                :errors="$errors(errors, 'estimate_serial_start')"
            />
        </div>


        <div class="mb-3">
            <input-label
                label-id="decimal_separator"
                :label="$t('thermal_printer')"
                :required="true"
            />
            <app-input
                type="radio"
                id="thermal_printer"
                radio-checkbox-name="thermal_printer"
                list-value-field="name"
                v-model="formData.thermal_printer"
                :options="thermalPrinterHandle"/>
        </div>

        <div class="mb-4">
            <Attachment
                :label="$t('estimate_logo')"
                label-required
                v-model="formData.estimate_logo"
                @changeFile="changeInvoiceLogo($event)"
                :error="$errors(errors, 'estimate_logo')"
                :recommended-size="$t('logo_recommended_size')"
                :recommended-file-size="$t('setting_file_size')"
            />
        </div>
        <button
            type="button"
            class="btn btn-primary shadow mt-3"
            @click.prevent="submit"
            v-if="canAccess('estimate_setting_update')"
            :disabled="preloader"
        >
            <app-button-loader v-if="preloader" />
            <i class="bi bi-download"></i>
            {{ $t("update") }}
        </button>
    </form>
</template>

<script setup>
import { ref, onMounted, watch } from "vue";
import Axios from "@services/axios";
import {useI18n} from "vue-i18n";
import { CUSTOMIZATIONS, ESTIMATE_SETTING } from "@services/endpoints/invoice";
import { formDataAssigner } from "@utilities/helpers";
import { useToast } from "vue-toastification";
import usePermission from "@/core/global/composable/usePermission";
import Attachment from "@/core/global/input/uploader/Attachment.vue";
import InputLabel from "@/core/global/input/label/InputLabel.vue";
const { canAccess } = usePermission();
const formData = ref({});
const preloader = ref(false);
const invoiceLogo = ref(false);
const {t} = useI18n();
const thermalPrinterHandle = ref([
    {
        id : 'enable',
        name: t("enable"),
    },
    {
        id : 'disable',
        name: t("disable"),
    }
])


const changeInvoiceLogo = (file) => {
    invoiceLogo.value = true;
    formData.value.estimate_logo = file;
};
const toast = useToast();
const errors = ref({});
watch(formData, () => {
    errors.value = {};
});
const submit = () => {
    preloader.value = true;
    if (invoiceLogo.value === false) {
        delete formData.value.estimate_logo;
    }

    let data = formDataAssigner(new FormData(), formData.value);
    Axios.post(ESTIMATE_SETTING, data, {
        headers: {
            "Content-Type": "multipart/form-data",
        },
    })
        .then((response) => {
            toast.success(response.data.message);
            getInvoiceSetting();
        })
        .catch((err) => {
            errors.value = err.response?.data?.errors;
        })
        .finally(() => (preloader.value = false));
};

const getPreloader = ref(false);
const getInvoiceSetting = () => {
    getPreloader.value = true;
    Axios.get(CUSTOMIZATIONS, {
        params: {
            type: "estimate",
        },
    })
        .then(({ data }) => {
            formData.value = data;
        })
        .finally(() => (getPreloader.value = false));
};
onMounted(() => {
    getInvoiceSetting();
});
</script>
