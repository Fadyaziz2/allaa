<template>
    <div class="container pb-5 my-5 installer-container">
        <div class="overflow-auto custom-scrollbar text-center">
            <ul class="multi-steps text-nowrap p-0">
                <li>Server Requirement</li>
                <li class="is-active">Purchase Code</li>
                <li>Database Configure</li>
                <li>Admin Information</li>
                <li>Company information</li>
                <li>Email setup</li>
            </ul>
        </div>
        <div class="card col-12 col-lg-7 mt-5 mb-4 d-block mx-auto">
            <div class="card-body shadow">
            <h4 class="mt-5 fw-bolder mb-3">
                {{ $t("purchase_code") }} <span class="text-danger">*</span>
            </h4>
            <app-input
                type="text"
                id="purchases_code"
                :placeholder="$t('purchase_code')"
                v-model="formData.purchase_code"
                :errors="$errors(errors, 'purchase_code')"
            />
            <small class="text-danger" v-if="errors.purchase_key">{{
                    errors.purchase_key[0]
                }}</small>
        </div>

        <div class="d-flex justify-content-center gap-3">
            <a
                href="/installation"
                class="btn btn-secondary btn-sm py-3 px-5 text-center text-white mb-5"
            >
                <span>Go Back</span>
            </a>
            <button
                type="button"
                class="btn btn-primary btn-sm py-3 px-5 text-center installer_btn mb-5"
                :disabled="preloader"
                @click.prevent="submit"
            >
                <app-button-loader v-if="preloader"/>
                <span>Next</span>
            </button>
        </div>
    </div>
    </div>
</template>
<style scoped>
.installer_btn:active {
    color : #fff !important;
}
</style>
<script setup>
import {ref} from "vue";
import router from "@router/index";
import {urlGenerator} from "@utilities/urlGenerator";
import {useToast} from "vue-toastification";

const formData = ref({
    purchase_code: "",
});
const errors = ref({});
const preloader = ref(false);
const toast = useToast();
const submit = () => {
    delete axios.defaults.headers.common["X-Requested-With"];
    delete axios.defaults.headers.common["X-CSRF-TOKEN"];
    preloader.value = true;

    axios.post(urlGenerator('api/purchase-code/check'), formData.value).then((response) => {
        if (response?.data.message === "success") {
            preloader.value = true;
            axios.get(response?.data.url)
                .then((res) => {
                    if (res?.data?.message === "verified") {
                        toast.success('Purchase code verified successfully');
                        router.push({
                            name: "environmentSetup",
                            query: {
                                purchase_code: formData.value.purchase_code,
                            },
                        });
                    }
                }).catch(({response}) => {
                if (response?.status === 422) {
                    errors.value = response?.data?.errors;
                } else {
                    toast.error(response?.data?.message);
                }
            }).finally(() => (preloader.value = false));
        }
        errors.value = {};
    }).catch(({response}) => {
        if (response?.status === 422) {
            errors.value = response.data.errors;
        }
        preloader.value = false
    })
};
</script>
