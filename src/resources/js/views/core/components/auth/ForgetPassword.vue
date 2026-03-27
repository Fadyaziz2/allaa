<template>
    <auth-layout>
        <template v-slot:auth-content>
        <form ref="form">
            <div class="mb-4 position-relative">
                <app-input
                    type="email"
                    id="email"
                    :label="$t('email_address')"
                    :label-required="true"
                    :placeholder="$t('email_address')"
                    v-model="formData.email"
                    :errors="$errors(errors, 'email')"
                />
                <router-link class="position-absolute top-0 end-0 brand-color" to="/login">{{ $t('back_to_login') }}</router-link>
            </div>
            <button type="button"
                    class="btn btn-primary w-100 shadow rounded-3"
                    @click.prevent="submit">
                <app-button-loader v-if="preloader"/>
                {{ $t('send_reset_link') }}
            </button>
        </form>
        </template>
    </auth-layout>
</template>

<script setup>
import AuthLayout from "@/core/components/auth/common/AuthLayout.vue";
import {ref} from "vue"
import {urlGenerator} from "@utilities/urlGenerator";
import {useToast} from "vue-toastification";
import {FORGET_PASSWORD} from "@services/endpoints";

const preloader = ref(false)
const formData = ref({})
const errors = ref({})
const toast = useToast()
const submit = () => {
    preloader.value = true
    axios.post(urlGenerator(FORGET_PASSWORD), formData.value, {
        headers: {
            Accept: "application/json",
            "Content-Type": "application/json",
        },
    }).then(({data}) => {
        toast.success(data.message);
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

