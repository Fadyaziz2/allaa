<template>
    <div
        class="content-wrapper d-flex align-items-center justify-content-center flex-column"
    >
        <app-loader v-if="preloader"/>
        <div v-else class="w-100">
            <!-- Block UI when updating -->
            <div v-if="confirmUpdateLoader" class="overlay">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Updating...</span>
                </div>
            </div>
            <div class="mb-5 text-center">
                <i
                    class="bi fw-600 fs-1"
                    :class="[
                        !hasUpdate ? 'bi-gear' : 'bi-emoji-smile text-primary',
                    ]"
                ></i>
                <div class="text-primary fs-3 fw-500">
                    {{
                        hasUpdate
                            ? $t("new_update_is_available")
                            : $t("no_new_version_available")
                    }}
                </div>
                <p class="fs-4 m-0" v-if="!hasUpdate">
                    {{ $t("you_already_have_the_latest_version") }}
                </p>
            </div>
            <app-loader v-if="autoUpdatePreloader"/>
            <div v-else>
                <div
                    class="my-4 p-4 d-flex flex-wrap gap-5 border border-2 update-details justify-content-center align-items-center"
                >
                    <version
                        v-if="hasUpdate"
                        :label="$t('your_version')"
                        :versionNumber="currentAppVersion"
                    />
                    <div v-if="hasUpdate" class="version_separation">
                        <i class="bi bi-arrow-right text-primary"></i>
                    </div>
                    <version
                        :label="
                            hasUpdate
                                ? $t('new_version')
                                : $t('current_version')
                        "
                        type="next"
                        :versionNumber="
                            hasUpdate ? nextUpdatableVersion : currentAppVersion
                        "
                    />
                </div>
                <div
                    class="mb-5 d-flex gap-3 justify-content-center align-items-center"
                >
                    <a
                        href="https://invoicex.theme29.com/documentation"
                        class="btn btn-sm px-4 btn-secondary text-white"
                    >
                        {{ $t("documentation") }}
                    </a>
                    <button
                        v-if="hasUpdate"
                        :disabled="confirmUpdateLoader"
                        class="ms-2 btn btn-sm px-4 download-button text-white"
                        @click="updateApp(nextUpdatableVersion)"
                    >
                        <app-button-loader v-if="confirmUpdateLoader"/>
                        {{ $t("update") }}
                    </button>
                </div>
                <primary-note
                    class="p-4"
                    title="Consider before upgrading"
                    description=""
                >
                    <ul class="consider-text">
                        <li>
                            {{ $t("update_backup_file_description") }}
                        </li>
                        <li>{{ $t("update_backup_file_description_2") }}</li>
                    </ul>
                </primary-note>
            </div>
        </div>
    </div>
</template>

<script setup>
import {ref, onMounted, computed} from "vue";
import {urlGenerator} from "@utilities/urlGenerator";
import {useToast} from "vue-toastification";
import Axios from "@services/axios";
import PrimaryNote from "@/core/global/note/PrimaryNote.vue";
import Version from "@/core/components/setting/update/Version.vue";

const defaultUpdate = ref(true);
const preloader = ref(false);
const currentAppVersion = ref(null);
const toast = useToast();

const checkUpdate = () => {
    preloader.value = true;
    Axios.get(urlGenerator(`api/app/check-verify`))
        .then((response) => {
            currentAppVersion.value = response?.data?.current_app_version;
            verifyMarketPlace(response?.data?.url);
        })
        .finally(() => (preloader.value = false));
};
const verifyMarketPlace = (url) => {
    delete axios.defaults.headers.common["X-Requested-With"];
    delete axios.defaults.headers.common["X-CSRF-TOKEN"];
    axios
        .get(url)
        .then((response) => {
            if (response?.data?.message === "verified") {
                autoUpdate();
            }
        })
        .catch(({ response }) => {
            if (response?.status === 422) {
                toast.error(response.data?.errors?.purchase_key[0]);
            }
        });
};

const updates = ref({});
const autoUpdatePreloader = ref(false);
const autoUpdate = () => {
    autoUpdatePreloader.value = true;
    Axios.get('api/app/update-app')
        .then((response) => {
            updates.value = response.data;
        })
        .catch(({response}) => {
            if (response.data.status === false) {
                try {
                    toast.success(response?.data?.message);
                } catch (e) {
                    toast.success(response?.data?.message);
                }
            }

            updates.value = {result: []};
        })
        .finally(() => (autoUpdatePreloader.value = false));
};

const nextUpdatableVersion = computed(
    () => updates.value.result?.map((i) => i.version).sort()[0] || 0
);
const hasUpdate = computed(
    () =>
        defaultUpdate.value &&
        updates.value.result &&
        updates.value.result.length
);

const confirmUpdateLoader = ref(false);
const updateApp = (appVersion) => {
    confirmUpdateLoader.value = true;
    delete axios.defaults.headers.common["X-Requested-With"];
    delete axios.defaults.headers.common["X-CSRF-TOKEN"];
    Axios.get(`api/app/update-app/${appVersion}`)
        .then((response) => {
            toast.success(response.data.message);
            cashClear();
        })
        .catch(() => {
            toast.error("Your update has been failed");
        })
        .finally(() => (confirmUpdateLoader.value = false));
};

const cashClear = () => {
    axios.get(urlGenerator(`cash-clear`)).then((res) => {
        location.replace(urlGenerator("/"));
    });
};

onMounted(() => {
    checkUpdate();
});
</script>

<style>
.consider-text {
    margin-top: 10px;
    padding-left: 14px;
}

.consider-text li {
    margin-bottom: 12px;
    font-size: 12px;
}

.download-button {
    background-color: var(--primary);
    opacity: 1;
}

.download-button:hover {
    background-color: var(--success);
    opacity: 0.8;
}

.overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(255, 255, 255, 0.8);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 9999;
}
</style>
