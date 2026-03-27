<template>
    <div class="container pb-5 my-5 custom-scrollbar installer-container">
        <div class="overflow-auto custom-scrollbar text-center">
            <ul class="multi-steps text-nowrap p-0">
                <li>Server Requirement</li>
                <li>Database Configure</li>
                <li class="is-active">Admin Information</li>
                <li>Company information</li>
                <li>Email setup</li>
            </ul>
        </div>
        <div class="card col-12 col-lg-7 mt-5 mb-4 d-block mx-auto">
            <div class="card-body shadow">
                <form @submit.prevent="submit">
                    <div class="mb-4">
                        <app-input
                            type="text"
                            id="first_name"
                            label="First name"
                            label-required
                            placeholder="First name"
                            v-model="formData.first_name"
                            :errors="$errors(errors, 'first_name')"
                        />
                    </div>
                    <div class="mb-4">
                        <app-input
                            type="text"
                            id="last_name"
                            label="Last name"
                            label-required
                            placeholder="Last name"
                            v-model="formData.last_name"
                            :errors="$errors(errors, 'last_name')"
                        />
                    </div>
                    <div class="mb-4">
                        <app-input
                            type="email"
                            id="email"
                            label="Email"
                            label-required
                            placeholder="Email"
                            v-model="formData.email"
                            :errors="$errors(errors, 'email')"
                        />
                    </div>
                    <div class="mb-4">
                        <app-input
                            type="password"
                            id="password"
                            label="Password"
                            label-required
                            placeholder="Password"
                            v-model="formData.password"
                            :show-password="true"
                            :errors="$errors(errors, 'password')"
                        />
                    </div>
                    <div class="mb-2">
                        <app-note :message="$t('password_user_gide_message')" />
                    </div>
                    <div class="d-flex justify-content-center gap-3">
                        <button
                            type="submit"
                            class="btn btn-primary py-3 px-5 text-center installer_btn"
                            :disabled="preloader"
                        >
                            <app-button-loader v-if="preloader" />
                            <span>Next</span>
                        </button>
                    </div>
                </form>
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
import {ref} from "vue"
import {urlGenerator} from "@utilities/urlGenerator";
import router from "@router/index";

const formData = ref({})
const errors = ref({})
const preloader = ref(false)
const submit = () => {
    preloader.value = true
    axios.post(urlGenerator(`api/user-store`), formData.value, {
        headers: {
            Accept: "application/json",
            "Content-Type": "application/json",

        },
    }).then(({data}) => {
        router.push({name: 'companySetup'});
    }).catch(({response}) => {
        if (response?.status === 422) {
            errors.value = response.data.errors;
        }
    }).finally(() => preloader.value = false)
}

</script>
