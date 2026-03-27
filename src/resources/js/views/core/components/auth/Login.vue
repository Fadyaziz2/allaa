<template>
    <auth-layout>
        <template v-slot:auth-content>
            <form action="" ref="form" @submit.prevent="submit">
                <div class="mb-4">
                    <app-input
                        type="email"
                        id="email"
                        :label="$t('email')"
                        :label-required="true"
                        :placeholder="$t('email_address')"
                        v-model="formData.email"
                        :errors="$errors(errors, 'email')"
                    />
                </div>
                <div class="mb-4 position-relative">
                    <app-input
                        type="password"
                        id="password"
                        :label="$t('password')"
                        :label-required="true"
                        :placeholder="$t('password')"
                        v-model="formData.password"
                        :errors="$errors(errors, 'password')"
                    />
                    <router-link
                        class="position-absolute top-0 end-0 brand-color"
                        to="/forget-password"
                    >{{ $t("reset_password") }}</router-link>
                </div>
                <button
                    type="submit"
                    class="btn btn-primary w-100 shadow rounded-3 mb-3"
                >
                    <app-button-loader v-if="preloader" />
                    {{ $t("sign_in") }}
                </button>
            </form>

            <div v-if="isDemoVersion == 'true'" class="mt-4">
                <table class="table">
                    <thead>
                    <tr>
                        <th>{{ $t('role') }}</th>
                        <th>{{ $t('email') }}</th>
                        <th>{{ $t('password') }}</th>
                        <th>{{ $t('action') }}</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr v-for="role in roleList" :key="role.name">
                        <td>{{ role.name }}</td>
                        <td>{{ role.email }}</td>
                        <td>{{ role.password }}</td>
                        <td>
                            <button type="button" @click="copyCredentials(role)" class="btn btn-sm btn-secondary">
                                {{ $t("copy_to_clipboard") }}
                            </button>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </template>
    </auth-layout>
</template>

<script setup>
import { useI18n } from "vue-i18n";
import AuthLayout from "@/core/components/auth/common/AuthLayout.vue";
import { reactive, ref } from "vue";
import { useAuth } from "@services/auth";
import { setToken } from "@utilities/token";
import router from "@router/index";
import { useToast } from "vue-toastification";
import usePermission from "@/core/global/composable/usePermission";

const { t } = useI18n();
const { storePermissions } = usePermission();
const formData = ref({ email: '', password: '' });
const errors = ref({});
const preloader = ref(false);
const { login } = useAuth();
const toast = useToast();
const isDemoVersion = ref(process.env.IS_DEMO);

const roleList = reactive([
    {
        name: t("super_admin"),
        email: 'admin@demo.com',
        password: '123456'
    },
    {
        name: t("manager"),
        email: 'manager@demo.com',
        password: '123456'
    },
    {
        name: t("customer"),
        email: 'customer@demo.com',
        password: '123456'
    },
]);

const copyCredentials = async (role) => {
    try {
        formData.value.email = role.email;
        formData.value.password = role.password;
        toast.success(t("copied_successfully"),{timeout:1500});
    } catch (error) {
        toast.error(t("copy_failed"));
    }
};

const submit = () => {
    preloader.value = true;
    login(formData.value)
        .then(({ data }) => {
            setToken(data["access_token"]);
            storePermissions(data["permissions"]);
            router.push({ name: "dashboard" });
        })
        .catch(({ response }) => {
            if (response.status === 422) {
                errors.value = response.data.errors;
            } else {
                formData.value.password = "";
                errors.value = {};
                toast.error(response.data.message);
            }
        })
        .finally(() => (preloader.value = false));
};
</script>
