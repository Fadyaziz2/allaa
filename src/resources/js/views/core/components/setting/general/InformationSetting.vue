<template>
    <app-loader class="mt-4" v-if="getPreloader" />
    <form v-else>
        <div class="mb-4">
            <app-input
                type="text"
                id="companyName"
                :label="$t('company_name')"
                label-required
                :placeholder="$t('company_name')"
                v-model="formData.company_name"
                :errors="$errors(errors, 'company_name')"
            />
        </div>

        <div class="mb-4">
            <app-input
                type="text"
                id="phone_number"
                :label="$t('phone_number')"
                :placeholder="$t('phone_number')"
                v-model="formData.company_phone"
                :errors="$errors(errors, 'company_phone')"
            />
        </div>

        <div class="mb-4">
            <app-input
                type="text"
                id="address"
                :label="$t('address')"
                :placeholder="$t('address')"
                v-model="formData.company_address"
                :errors="$errors(errors, 'company_address')"
            />
        </div>

        <div class="mb-4">
            <app-input
                type="text"
                id="company_tax_id"
                :label="$t('tax_id')"
                :placeholder="$t('tax_id')"
                v-model="formData.company_tax_id"
                :errors="$errors(errors, 'company_tax_id')"
            />
        </div>
        <div class="mb-4">
            <app-input
                type="text"
                id="company_website"
                :label="$t('website')"
                :placeholder="$t('website')"
                v-model="formData.company_website"
                :errors="$errors(errors, 'company_website')"
            />
        </div>

        <div class="mb-4">
            <Attachment
                :label="$t('change_logo')"
                label-required
                v-model="formData.company_logo"
                @changeFile="changeCompanyLogo($event)"
                :error="$errors(errors, 'company_logo')"
                :recommended-size="$t('logo_recommended_size')"
                :recommended-file-size="$t('setting_file_size')"
            />
        </div>

        <div class="mb-4">
            <Attachment
                :label="$t('change_icon')"
                label-required
                v-model="formData.company_icon"
                @changeFile="changeCompanyIcon($event)"
                :error="$errors(errors, 'company_icon')"
                :recommended-size="$t('icon_recommended_size')"
                :recommended-file-size="$t('setting_file_size')"
            />
        </div>
        <div class="mb-4">
            <Attachment
                :label="$t('change_banner')"
                label-required
                v-model="formData.company_banner"
                @changeFile="changeCompanyBanner($event)"
                :error="$errors(errors, 'company_banner')"
                :recommended-size="$t('banner_recommended_size')"
                :recommended-file-size="$t('setting_file_size')"
            />
        </div>

        <button
            v-if="canAccess('update_setting')"
            type="button"
            :disabled="preloader"
            class="btn btn-primary shadow mt-3"
            @click.prevent="submit"
        >
            <app-button-loader v-if="preloader" />
            <i class="bi bi-download"></i>
            {{ $t("update") }}
        </button>
    </form>
</template>

<script setup>
import { ref, onMounted } from "vue";
import Axios from "@services/axios";
import { SETTING } from "@services/endpoints";
import { formDataAssigner } from "@utilities/helpers";
import { useToast } from "vue-toastification";
import usePermission from "@/core/global/composable/usePermission";
import Attachment from "@/core/global/input/uploader/Attachment.vue";
const { canAccess } = usePermission();

const props = defineProps({
    id: {}
})

const formData = ref({});
const preloader = ref(false);
const companyLogo = ref(false);
const companyIcon = ref(false);
const companyBanner = ref(false);
const changeCompanyLogo = (file) => {
    companyLogo.value = true;
    formData.value.company_logo = file;
};
const changeCompanyIcon = (file) => {
    companyIcon.value = true;
    formData.value.company_icon = file;
};
const changeCompanyBanner = (file) => {
    companyBanner.value = true;
    formData.value.company_banner = file;
};
const toast = useToast();
const errors = ref({});
const submit = () => {
    preloader.value = true;
    let customData = formData.value;
    customData.company_phone = formData.value.company_phone
        ? formData.value.company_phone
        : "";
    customData.company_address = formData.value.company_address
        ? formData.value.company_address
        : "";
    customData.company_tax_id = formData.value.company_tax_id
        ? formData.value.company_tax_id
        : "";
    customData.company_website = formData.value.company_website
        ? formData.value.company_website
        : "";
    let data = formDataAssigner(new FormData(), customData);
    Axios.post(SETTING, data, {
        headers: {
            "Content-Type": "multipart/form-data",
        },
    })
        .then((response) => {
            toast.success(response.data.message);
            window.location.reload();
        })
        .catch(({ response }) => {
            if (response.status === 422) {
                errors.value = response.data.errors;
            } else {
                errors.value = {};
                toast.error(response.data.message);
            }
        })
        .finally(() => (preloader.value = false));
};

const getPreloader = ref(false);
const getSetting = () => {
    getPreloader.value = true;
    Axios.get(SETTING)
        .then(({ data }) => {
            formData.value = data;
        })
        .finally(() => (getPreloader.value = false));
};
onMounted(() => {
    getSetting();
});
</script>
