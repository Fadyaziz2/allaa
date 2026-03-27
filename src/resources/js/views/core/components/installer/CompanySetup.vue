<template>
    <div class="container py-5 my-5 installer-container">
        <div class="overflow-auto custom-scrollbar text-center">
            <ul class="multi-steps text-nowrap p-0">
                <li>Server Requirement</li>
                <li>Database Configure</li>
                <li>Admin Information</li>
                <li class="is-active">Company information</li>
                <li>Email setup</li>
            </ul>
        </div>
        <div class="card col-12 col-lg-7 mt-5 mb-4 d-block mx-auto">
            <div class="card-body">
                <div class="mb-4 mt-4">
                    <app-input
                        type="text"
                        id="companyName"
                        label="Company name"
                        label-required
                        placeholder="Company name"
                        v-model="formData.company_name"
                        :errors="$errors(errors, 'company_name')"
                    />
                </div>
                <div class="mb-4">
                    <app-input
                        type="text"
                        id="phone"
                        label="Phone number"
                        label-required
                        placeholder="Phone number"
                        v-model="formData.company_phone"
                        :errors="$errors(errors, 'company_phone')"
                    />
                </div>
                <div class="mb-4">
                    <app-input
                        type="text"
                        id="address"
                        label="Address"
                        label-required
                        placeholder="Address"
                        v-model="formData.company_address"
                        :errors="$errors(errors, 'company_address')"
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
                <!-- <div class="mb-4 d-flex align-items-center flex-wrap gap-3">
                    <app-input
                        type="image-uploader"
                        id="companyLogo"
                        label="Company logo"
                        label-required
                        v-model="formData.company_logo"
                        :generate-file-url="false"
                        :errors="$errors(errors, 'company_logo')"
                        @changeFile="changeCompanyLogo($event)"
                    />
                    <p class="mt-4 px-2">
                        {{ $t("logo_recommended_size") }}
                        <br />
                        {{ $t("setting_file_size") }}
                    </p>
                </div>
                <div class="mb-4 d-flex align-items-center flex-wrap gap-3">
                    <app-input
                        type="image-uploader"
                        id="companyIcon"
                        label="Company icon"
                        label-required
                        :generate-file-url="false"
                        v-model="formData.company_icon"
                        :errors="$errors(errors, 'company_icon')"
                        @changeFile="changeCompanyIcon($event)"
                    />
                    <p class="mt-4 px-2">
                        {{ $t("icon_recommended_size") }}
                        <br />
                        {{ $t("setting_file_size") }}
                    </p>
                </div>

                <div class="mb-4 d-flex align-items-center flex-wrap gap-3">
                    <app-input
                        type="image-uploader"
                        id="companyBanner"
                        label="Company banner"
                        label-required
                        v-model="formData.company_banner"
                        :generate-file-url="false"
                        :errors="$errors(errors, 'company_banner')"
                        @changeFile="changeCompanyBanner($event)"
                    />
                    <p class="mt-4">
                        {{ $t("banner_recommended_size") }}
                        <br />
                        {{ $t("setting_file_size") }}
                    </p>
                </div> -->

                <div class="d-flex justify-content-center gap-3">
                    <button
                        type="button"
                        class="btn btn-primary btn-sm py-3 px-5 text-center installer_btn"
                        @click.prevent="submit"
                        :disabled="preloader"
                    >
                        <app-button-loader v-if="preloader"/>
                        <span v-else>Next</span>
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
.installer_btn:active {
    color: #fff !important;
}
</style>
<script setup>
import {ref} from "vue";
import {formDataAssigner} from "@utilities/helpers";
import router from "@router/index";
import {urlGenerator} from "@utilities/urlGenerator";
import Attachment from "@/core/global/input/uploader/Attachment.vue";

const formData = ref({});
const errors = ref({});
const preloader = ref(false);
const changeCompanyLogo = (file) => {
    formData.value.company_logo = file;
};
const changeCompanyIcon = (file) => {
    formData.value.company_icon = file;
};
const changeCompanyBanner = (file) => {
    formData.value.company_banner = file;
};
const submit = () => {
    preloader.value = true;
    let data = formDataAssigner(new FormData(), formData.value);
    axios
        .post(urlGenerator("api/company-store"), data, {
            headers: {
                Accept: "application/json",
                "Content-Type": "multipart/form-data",
            },
        })
        .then((response) => {
            router.push({name: "emailSetup"});
        })
        .catch(({response}) => {
            if (response?.status === 422) {
                errors.value = response.data.errors;
            }
        })
        .finally(() => (preloader.value = false));
};
</script>
