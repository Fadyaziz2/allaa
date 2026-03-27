<template>
    <div class="container pb-5 my-5 installer-container">
        <div class="overflow-auto custom-scrollbar text-center">
            <ul class="multi-steps text-nowrap p-0">
                <li>Server Requirement</li>
                <li>Database Configure</li>
                <li>Admin Information</li>
                <li>Company information</li>
                <li class="is-active">Email setup</li>
            </ul>

        </div>
        <div class="card col-12 col-lg-7 mt-5 mb-4 d-block mx-auto">
            <div class="card-body shadow">
                <div class="mb-4 mt-5">
                    <app-input
                        type="select"
                        id="provider"
                        label="Provider"
                        label-required
                        :options="providerList"
                        list-value-field="name"
                        choose-label="Choose a provider"
                        v-model="formData.provider"
                        :errors="$errors(errors, 'provider')"
                    />
                </div>

                <div class="mb-4">
                    <app-input
                        type="text"
                        id="from_name"
                        label="From name"
                        label-required
                        placeholder="From name"
                        v-model="formData.from_name"
                        :errors="$errors(errors, 'from_name')"
                    />
                </div>
                <div class="mb-4">
                    <app-input
                        type="email"
                        id="from_email"
                        label="From email"
                        label-required
                        placeholder="From email"
                        v-model="formData.from_email"
                        :errors="$errors(errors, 'from_email')"
                    />
                </div>

                <template v-if="formData.provider === 'smtp'">

                    <div class="mb-4">
                        <app-input
                            type="text"
                            id="host"
                            label="Smtp host"
                            label-required
                            placeholder="Smtp host"
                            v-model="formData.smtp_host"
                            :errors="$errors(errors, 'smtp_host')"
                        />
                    </div>
                    <div class="mb-4">
                        <app-input
                            type="text"
                            id="smtp_port"
                            label="Smtp port"
                            label-required
                            placeholder="Smtp port"
                            v-model="formData.smtp_port"
                            :errors="$errors(errors, 'smtp_port')"
                        />
                    </div>
                    <div class="mb-4">
                        <app-input
                            type="text"
                            id="smtp_username"
                            label="Smtp username"
                            label-required
                            placeholder="Smtp username"
                            v-model="formData.smtp_username"
                            :errors="$errors(errors, 'smtp_username')"
                        />
                    </div>
                    <div class="mb-4">
                        <app-input
                            type="text"
                            id="email_password"
                            label="Email password"
                            label-required
                            placeholder="Email password"
                            v-model="formData.email_password"
                            :errors="$errors(errors, 'email_password')"
                        />
                    </div>
                    <div class="mb-4">
                        <app-input
                            type="text"
                            id="encryption_type"
                            label="Encryption type"
                            label-required
                            placeholder="Encryption type"
                            v-model="formData.encryption_type"
                            :errors="$errors(errors, 'encryption_type')"
                        />
                    </div>

                </template>
                <div class="d-flex justify-content-center gap-3">
                    <button type="button"
                            class="btn btn-info btn-sm py-3 px-5 text-center"
                            :disabled="skipLoader"
                            @click.prevent="skip">
                        <app-button-loader v-if="skipLoader"/>
                        <span>Skip</span>
                    </button>
                    <button type="button"
                            class="btn btn-primary btn-sm py-3 px-5 text-center installer_btn"
                            :disabled="preloader"
                            @click.prevent="submit">
                        <app-button-loader v-if="preloader"/>
                        <span>Finish</span>
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
import {ref} from "vue"
import {useI18n} from 'vue-i18n';
import {urlGenerator} from "@utilities/urlGenerator";
import router from "@router/index";

const {t} = useI18n();
const formData = ref({})
const errors = ref({})
const preloader = ref(false)

const submit = () => {
    preloader.value = true
    axios.post(urlGenerator('api/email-store'), formData.value, {
        headers: {
            Accept: "application/json",
            "Content-Type": "application/json",
        }
    }).then((response) => {
        location.replace(urlGenerator('/'))
    }).catch(({response}) => {
        if (response.status === 422) {
            errors.value = response.data.errors;
        }
    }).finally(() => preloader.value = false)
}

const skipLoader = ref(false)
const skip = () => {
    skipLoader.value = true
    axios.post(urlGenerator('api/setup-skip'), formData.value, {
        headers: {
            Accept: "application/json",
            "Content-Type": "application/json",
        }
    }).then((response) => {
        location.replace(urlGenerator('/'))
    }).catch(({response}) => {
        if (response.status === 422) {
            errors.value = response.data.errors;
        }
    }).finally(() => skipLoader.value = false)
}

const providerList = ref([
    {
        id: 'sendmail',
        name: t('sendmail')
    },
    {
        id: 'smtp',
        name: t('smtp')
    }
])

</script>
