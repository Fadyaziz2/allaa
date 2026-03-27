<template>
    <app-loader class="mt-4" v-if="getPreloader"/>
    <form v-else>
        <div class="mb-4">
            <app-input
                type="text"
                id="paymentPrefix"
                :label="$t('payment_prefix')"
                label-required
                :placeholder="$t('payment_prefix')"
                v-model="formData.payment_prefix"
                :errors="$errors(errors, 'payment_prefix')"/>
        </div>

        <div class="mb-4">
            <app-input
                type="text"
                id="payment_serial_start"
                :label="$t('payment_serial_start')"
                label-required
                :placeholder="$t('payment_serial_start')"
                v-model="formData.payment_serial_start"
                :errors="$errors(errors, 'payment_serial_start')"/>
        </div>

        <button type="button"
                class="btn btn-primary shadow mt-3"
                @click.prevent="submit"
                v-if="canAccess('payment_setting_update')"
                :disabled="preloader"
        >
            <app-button-loader v-if="preloader"/>
            <i class="bi bi-download"></i>
            {{ $t('update') }}
        </button>
    </form>
</template>

<script setup>
import {ref, onMounted} from "vue"
import Axios from "@services/axios";
import {PAYMENT_SETTING, CUSTOMIZATIONS} from "@services/endpoints/invoice";
import {useToast} from "vue-toastification";
import usePermission from "@/core/global/composable/usePermission";

const {canAccess} = usePermission();

const formData = ref({})
const preloader = ref(false)

const toast = useToast()
const errors = ref({})
const submit = () => {
    preloader.value = true
    Axios.post(PAYMENT_SETTING, formData.value).then((response) => {
        toast.success(response.data.message);
        errors.value = {};
        getPaymentSetting()
    }).catch(({response}) => {
        if (response.status === 422)
            errors.value = response?.data?.errors;
        else {
            errors.value = {}
            toast.error(response?.data?.message);
        }
    }).finally(() => preloader.value = false)
}

const getPreloader = ref(false)
const getPaymentSetting = () => {
    getPreloader.value = true
    Axios.get(CUSTOMIZATIONS, {
        params: {
            type: 'payment'
        }
    }).then(({data}) => {
        formData.value = data;
    }).finally(() => getPreloader.value = false)
}
onMounted(() => {
    getPaymentSetting()
})


</script>
