<template>
    <div class="mb-4">
        <app-input id="current_password" type="password" :label="$t('current_password')" label-required
                   :placeholder="$t('current_password')" v-model="formData.current_password"
                   :errors="$errors(errors, 'current_password')"/>
    </div>
    <div class="mb-4">
        <app-input id="new_password" type="password" :label="$t('new_password')" label-required
                   :placeholder="$t('new_password')" v-model="formData.password" :errors="$errors(errors, 'password')"/>
        <app-note class="mt-2" :message="$t('password_user_gide_message')"/>
    </div>

    <div class="mb-4">
        <app-input id="confirm_password" type="password" :label="$t('confirm_password')" label-required
                   :placeholder="$t('confirm_password')" v-model="formData.confirm_password"
                   :errors="$errors(errors, 'confirm_password')"/>
    </div>

    <button type="button"
            class="btn btn-primary shadow"
            :disabled="preloader"
            @click.prevent="submit">
        <app-button-loader v-if="preloader"/>
        <i class="bi bi-download"></i>
        {{ $t('update') }}
    </button>
</template>

<script setup>
import {ref} from "vue"
import Axios from "@services/axios";
import {PASSWORD_CHANGE} from "@services/endpoints";
import {useToast} from "vue-toastification";


const props = defineProps({
    id: {}
})
const formData = ref({})
const errors = ref({})
const preloader = ref(false)
const toast = useToast()
const submit = () => {
    preloader.value = true
    errors.value = {}
    Axios.patch(PASSWORD_CHANGE, formData.value).then((response) => {
        toast.success(response.data.message);
        formData.value = {}
        errors.value = {}
    }).catch(({response}) => {
        if (response.status === 422) {
            errors.value = response.data.errors;
        } else {
            toast.error(response.data.message);
        }
    }).finally(() => preloader.value = false)
}
</script>


