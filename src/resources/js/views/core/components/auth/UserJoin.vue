<template>
    <auth-layout>
        <template v-slot:auth-content>
            <form ref="form">
                <div class="mb-4">
                    <app-input type="text" id="first_name" :label="$t('first_name')" :label-required="true"
                        :placeholder="$t('first_name')" v-model="formData.first_name"
                        :errors="$errors(errors, 'first_name')" />

                </div>
                <div class="mb-4">
                    <app-input type="text" id="last_name" :label="$t('last_name')" :label-required="true"
                        :placeholder="$t('last_name')" v-model="formData.last_name"
                        :errors="$errors(errors, 'last_name')" />

                </div>
                <div class="mb-4">
                    <app-input type="password" id="new_password" :label="$t('new_password')" :label-required="true"
                        :placeholder="$t('new_password')" v-model="formData.password"
                        :errors="$errors(errors, 'password')" />
                    <app-note class="mt-2" :message="$t('password_user_gide_message')"/>
                </div>
                <div class="mb-4">
                    <app-input type="password" id="confirm_password" :label="$t('confirm_password')" :label-required="true"
                        :placeholder="$t('confirm_password')" v-model="formData.password_confirmation"
                        :errors="$errors(errors, 'password_confirmation')" />
                </div>

                <button type="button" class="btn btn-primary w-100 shadow" @click.prevent="submit">
                    <app-button-loader v-if="preloader" />
                    {{ $t('confirm') }}
                </button>
            </form>
        </template>
    </auth-layout>
</template>

<script setup>
import AuthLayout from "@/core/components/auth/common/AuthLayout.vue";
import { ref } from "vue"
import { useToast } from "vue-toastification";
import { urlGenerator } from "@utilities/urlGenerator";
import { USER_JOIN } from "@services/endpoints";
import { useRoute } from "vue-router";
import router from "@router/index";

const route = useRoute();
const formData = ref({})
const errors = ref({})
const preloader = ref(false)
const toast = useToast()
const submit = () => {
    preloader.value = true
    let data = {
        ...formData.value,
        token: route.query.token,
    }
    axios.post(urlGenerator(USER_JOIN), data, {
        headers: {
            Accept: "application/json",
            "Content-Type": "application/json",
        },
    }).then(({ data }) => {
        toast.success(data.message);
        router.push({ name: "login" });

    }).catch(({ response }) => {
        if (response.status === 422) {
            errors.value = response.data.errors;
        } else {
            errors.value = {};
            toast.error(response.data.message);
        }
    }).finally(() => preloader.value = false);
}
</script>
