<template>
    <auth-layout>
        <template v-slot:auth-content>
            <form ref="form">
                <div class="mb-4">
                    <app-input type="password" id="new_password" :label="$t('new_password')" :label-required="true"
                               :placeholder="$t('new_password')" v-model="formData.password"
                               :errors="$errors(errors, 'password')"/>
                    <app-note class="mt-2" :message="$t('password_user_gide_message')"/>
                </div>
                <div class="mb-4">
                    <app-input type="password" id="confirm_password" :label="$t('confirm_password')"
                               :label-required="true"
                               :placeholder="$t('confirm_password')" v-model="formData.password_confirmation"
                               :errors="$errors(errors, 'password_confirmation')"/>
                </div>
                <button type="button" class="btn btn-primary w-100 shadow" @click.prevent="submit">
                    <app-button-loader v-if="preloader"/>
                    {{ $t('update_password') }}
                </button>
            </form>
        </template>
    </auth-layout>
</template>

<script setup>
import AuthLayout from "@/core/components/auth/common/AuthLayout.vue";
import {ref} from "vue"
import {urlGenerator} from "@utilities/urlGenerator";
import {CONFORM_PASSWORD} from "@services/endpoints";
import {useToast} from "vue-toastification";
import router from "@router/index";
import {useRoute} from "vue-router";

const preloader = ref(false)
const errors = ref({})
const formData = ref({})
const toast = useToast()
const route = useRoute();
const submit = () => {
    preloader.value = true
    let data = {
        ...formData.value,
        token: route.query.token,
    }
    axios.post(urlGenerator(CONFORM_PASSWORD), data, {
        headers: {
            Accept: "application/json",
            "Content-Type": "application/json",
        }
    }).then(({data}) => {
        toast.success(data.message);
        router.push({name: 'login'})
    }).catch(({response}) => {
        if (response.status === 422) {
            errors.value = response.data.errors
        } else {
            errors.value = {};
            toast.error(response.data.message);
        }
    }).finally(() => preloader.value = false)
}

</script>

