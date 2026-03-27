<template>
    <div class="pb-5 my-5 installer-container">
        <div class="overflow-auto custom-scrollbar text-center">
            <ul class="multi-steps list-unstyled">
                <li class="is-active">Server Requirement</li>
                <li>Database Configure</li>
                <li>Admin Information</li>
                <li>Company information</li>
                <li>Email setup</li>
            </ul>
        </div>

        <div class="card col-12 col-lg-7 mt-3 mb-4 d-block mx-auto">
            <div class="card-header">
                <h6>Server Requirement</h6></div>
            <div class="card-body">
                <div class="installation_notice mb-3">
                    <div class="card-body px-5">
                        Make sure that your server meets the required PHP version,
                        all the extensions, and file permission mentioned below
                        before attempting to install the application.
                        <a href="https://invoicex.theme29.com/documentation/" target="_blank"
                        >Check documentation</a>
                    </div>
                </div>
                <div class="mt-2 mw-100 table-responsive custom-scrollbar">
                    <table class="installation_status_table table-striped">
                        <thead>
                        <tr>
                            <th></th>
                            <th class="text-center">Required</th>
                            <th class="text-center">Current</th>
                            <th class="text-center">Status</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr v-if="checkPhpVersion">
                            <td>PHP version</td>
                            <td class="text-center">
                                {{ checkPhpVersion.minimum_version }}
                            </td>
                            <td class="text-center">
                                {{ checkPhpVersion.current_version }}
                            </td>
                            <td class="text-center">
                                <i v-if="checkPhpVersion.status"
                                   class="bi bi-check-circle text-primary"></i>

                                <i v-else class="bi bi-x-circle text-danger"></i>
                            </td>
                        </tr>

                        <tr v-if="checkMysqlVersion">
                            <td>MySql version</td>
                            <td class="text-center">{{ checkMysqlVersion.minimum_version }}</td>
                            <td class="text-center">{{ checkMysqlVersion.current_version }}</td>
                            <td class="text-center">
                                <i
                                    v-if="checkMysqlVersion.status"
                                    class="bi bi-check-circle text-primary"
                                ></i>

                                <i v-else class="bi bi-x-circle text-danger"></i>
                            </td>
                        </tr>

                        <template v-if="phpRequirements">
                            <tr v-for="(phpRequirement, index) in phpRequirements">
                                <td>{{ index }}</td>
                                <td class="text-center">Enabled</td>
                                <td class="text-center">
                                    <template v-if="phpRequirement">
                                        Enabled
                                    </template>
                                    <template v-else>Disable</template>
                                </td>
                                <td class="text-center">
                                    <i
                                        v-if="phpRequirement"
                                        class="bi bi-check-circle text-primary"
                                    ></i>

                                    <i
                                        v-else
                                        class="bi bi-x-circle text-danger"
                                    ></i>
                                </td>
                            </tr>
                        </template>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="card col-12 col-lg-7 mt-3 mb-4 d-block mx-auto">
            <div class="card-header">
                <h6>File/Folder Permission</h6>
            </div>
            <div class="card-body">
                <div class="mt-2 table-responsive custom-scrollbar">
                    <table class="installation_status_table">
                        <thead>
                        <tr>
                            <th>File/Path Permission</th>
                            <th class="text-center">Required</th>
                            <th class="text-center">Status</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr v-for="folderPermission in folderPermissions">
                            <td>
                                {{ folderPermission.folder }}
                            </td>
                            <td class="text-center">{{ folderPermission.permission }}</td>
                            <td class="text-center">
                                <i
                                    :class="[
                                    folderPermission.isSet
                                        ? 'bi bi-check-circle text-primary'
                                        : 'bi bi-x-circle text-danger',
                                ]"
                                ></i>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="card col-12 col-lg-7 mt-3 mb-4 d-block mx-auto">
            <div class="card-header">Symlink Requirement</div>
            <div class="card-body">
                <table class="installation_status_table table-striped">
                    <thead>
                    <tr>
                        <th class="text-center">Requirement</th>
                        <th class="text-center">Enable</th>
                        <th class="text-center">Status</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td class="text-center">Symlink</td>
                        <td class="text-center">{{ additionalRequirement.status ? 'Enable' : 'Disable' }}</td>
                        <td class="text-center">
                            <i v-if="additionalRequirement.status" class="bi bi-check-circle text-primary"></i>
                            <i v-else class="bi bi-x-circle text-danger"></i>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="mt-2 d-flex gap-3 justify-content-center">
            <button
                v-if="!hasNext"
                type="button"
                class="btn btn-primary btn-sm py-3 px-5 mx-auto text-center"
                @click.prevent="retry">
                Retry
            </button>
        </div>
    </div>
</template>
<style scoped>
.installer_btn:active {
    color: #fff !important;
}
</style>

<script setup>
import {ref, onMounted, computed, watch} from "vue";
import {urlGenerator} from "@utilities/urlGenerator";
import router from "@router/index";

const checkPhpVersion = ref({});
const checkMysqlVersion = ref({});
const phpRequirements = ref({});
const phpRequirementsErrors = ref({});
const folderPermissions = ref({});
const folderPermissionsErrors = ref({});
const additionalRequirement = ref({})
const getRequirement = () => {
    axios
        .get(urlGenerator(`api/installation/requirements`))
        .then((response) => {
            if (
                !response?.data?.checkPhpVersion &&
                !response?.data?.requirements?.requirements?.php
            ) {
                router.push("/login");
            } else {
                checkPhpVersion.value = response?.data?.checkPhpVersion;
                checkMysqlVersion.value = response?.data?.mysqlVersion;
                phpRequirements.value =
                    response?.data?.requirements?.requirements?.php;
                phpRequirementsErrors.value = response?.data?.requirements?.errors
                folderPermissions.value =
                    response?.data.permissions?.permissions;

                folderPermissionsErrors.value = response?.data.permissions?.errors
                additionalRequirement.value = response?.data?.additional_requirement
            }
        })
};

const hasNext = computed(() => {
    if (phpRequirements.value) {
        let isRequired = true;
        for (const key in phpRequirements.value) {
            if (!phpRequirements.value[key]) {
                isRequired = false;
            }
            return (
                checkPhpVersion.value.status &&
                checkMysqlVersion.value.status &&
                folderPermissionsErrors.value === null &&
                !phpRequirementsErrors.value
            );
        }
    }
    return false;
});


watch(hasNext, (canProceed) => {
    if (canProceed) {
        router.push({name: "environmentSetup"});
    }
});

const retry = () => {
    location.replace(urlGenerator('/installation'))
}

onMounted(() => {
    getRequirement();
});
</script>
