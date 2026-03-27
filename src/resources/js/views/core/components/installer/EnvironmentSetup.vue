<template>
    <div class="container pb-5 px-4 my-5 installer-container">
        <div class="overflow-auto custom-scrollbar text-center">
            <ul class="multi-steps text-nowrap p-0">
                <li>Server Requirement</li>
                <li class="is-active">Database Configure</li>
                <li>Admin Information</li>
                <li>Company information</li>
                <li>Email setup</li>
            </ul>
        </div>

        <div class="card col-12 col-lg-7 mt-5 mb-4 d-block mx-auto">
            <div class="card-body shadow">
                <div class="my-4">
                    <app-input
                        type="select"
                        id="driver"
                        label="Driver"
                        label-required
                        :options="databaseProviderList"
                        list-value-field="name"
                        choose-label="Choose a driver"
                        v-model="formData.database_connection"
                        :errors="$errors(errors, 'database_connection')"
                    />
                </div>

                <div class="mb-4">
                    <app-input
                        type="text"
                        id="database_hostname"
                        label="Database hostname"
                        label-required
                        placeholder="Database hostname"
                        v-model="formData.database_hostname"
                        :errors="$errors(errors, 'database_hostname')"
                    />
                </div>

                <div class="mb-4">
                    <app-input
                        type="text"
                        id="database_port"
                        label="Database port"
                        label-required
                        placeholder="Database port"
                        v-model="formData.database_port"
                        :errors="$errors(errors, 'database_port')"
                    />
                </div>

                <div class="mb-4">
                    <app-input
                        type="text"
                        id="database_name"
                        label="Database name"
                        label-required
                        placeholder="Database name"
                        v-model="formData.database_name"
                        :errors="$errors(errors, 'database_name')"
                    />
                </div>

                <div class="mb-4">
                    <app-input
                        type="text"
                        id="database_username"
                        label="Database username"
                        label-required
                        placeholder="Database username"
                        v-model="formData.database_username"
                        :errors="$errors(errors, 'database_username')"
                    />
                </div>

                <div class="mb-4">
                    <app-input
                        type="password"
                        id="database_password"
                        label="Database password"
                        label-required
                        placeholder="Database password"
                        v-model="formData.database_password"
                        :show-password="true"
                        :errors="$errors(errors, 'database_password')"
                    />
                </div>
                <div class="mb-2">
                    <app-note message='Database name, username and password must not contain "#" or white spaces!'
                              class="m-0"/>
                </div>
                <div class="d-flex justify-content-center gap-3">
                    <button
                        type="button"
                        class="btn btn-primary btn-sm py-3 px-5 text-center installer_btn"
                        :disabled="preloader"
                        @click.prevent="submit">
                        <app-button-loader v-if="preloader"/>
                        <span>Next</span>
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
import axios from "axios";
import {urlGenerator} from "@utilities/urlGenerator";
import {useRoute} from "vue-router";
import router from "@router/index";
import coreAppFunction from "@/core/global/helpers/app/coreAppFunction";
import {useToast} from "vue-toastification";

const formData = ref({});
const errors = ref({});
const route = useRoute();
const databaseProviderList = ref([
    {id: "mysql", name: "Mysql"},
    {id: "sqlite", name: "Sqlite"},
    {id: "pgsql", name: "Pgsql"},
]);
const preloader = ref(false);
const toast = useToast();
const submit = () => {
    let data = {
        ...formData.value,
        app_url: coreAppFunction.baseUrl(),
    };
    preloader.value = true;
    axios
        .post(urlGenerator("api/connect/database"), data, {
            headers: {
                Accept: "application/json",
                "Content-Type": "application/json",
            },
        })
        .then((response) => {
            errors.value = {};
            router.push({name: "userInfoSetup"});
        })
        .catch(({response}) => {
            if (response.status === 422) {
                errors.value = response.data.errors;
            } else {
                errors.value = {};
                toast.error(response.data.message);
            }
        })
        .finally(() => (preloader.value = false));
};
</script>
