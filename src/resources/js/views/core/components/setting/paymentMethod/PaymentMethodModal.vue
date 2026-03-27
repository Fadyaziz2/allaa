<template>
    <app-modal :modal-id="modalId"
               modal-size="large"
               :title="selectedUrl ? $t('update_payment_method') : $t('add_payment_method')"
               :preloader="preloader"
               @submit="submit"
               @close="closeModal">
        <template v-slot:body>
            <div class="mb-4">
                <app-input type="select" id="type" :label="$t('payment_method_type')" label-required :label-required="true"
                           list-value-field="name" :options="paymentMethodTypeList"
                           :choose-label="$t('choose_a_payment_method')"
                           v-model="formData.type" :errors="$errors(errors, 'type')"/>
            </div>

            <div class="mb-4">
                <app-input type="text" id="name" :label="$t('name')" label-required :placeholder="$t('name')"
                           v-model="formData.name" :errors="$errors(errors, 'name')"/>
            </div>

            <div class="mb-4" v-if="formData.type === 'paypal' ||  formData.type === 'sslcommerz'">
                <app-input type="select"
                           id="payment_mode"
                           :label="$t('payment_mode')"
                           label-required
                           list-value-field="name"
                           :choose-label="$t('choose_a_mode')"
                           :options="[{id:'sandbox', name:$t('sandbox')}, {id:'live', name: $t('live')}]"
                           v-model="formData.payment_mode"
                           :errors="$errors(errors, 'payment_mode')"/>
            </div>


            <template v-if="formData.type === 'paypal' || formData.type === 'stripe' || formData.type === 'razorpay' || formData.type === 'sslcommerz'">
                <div class="mb-4">
                    <app-input type="text"
                               id="api_key"
                               :label="$t('api_key')"
                               label-required
                               :placeholder="$t('api_key')"
                               v-model="formData.api_key"
                               :errors="$errors(errors, 'api_key')"/>
                </div>

                <div class="mb-4">
                    <app-input type="password"
                               id="api_secret"
                               :label="$t('api_secret')"
                               label-required
                               :placeholder="$t('api_secret')"
                               v-model="formData.api_secret"
                               :errors="$errors(errors, 'api_secret')"/>
                </div>

            </template>

        </template>
    </app-modal>
</template>

<script setup>
import {useSubmitForm} from "@/core/global/composable/modal/useSubmitForm";
import {reactive, onMounted} from "vue";
import {useI18n} from "vue-i18n";
import {PAYMENT_METHODS} from "@services/endpoints/invoice";
import Axios from "@services/axios";

const props = defineProps({
    modalId: String,
    tableId: String,
    selectedUrl: String
})

const emit = defineEmits(['close'])
const {t} = useI18n();

const {preloader, formData, errors, save, closeModal} = useSubmitForm(props, emit, 'no')
const submit = () => {
    save(props.selectedUrl ? props.selectedUrl : PAYMENT_METHODS, formData.value)
}

const getEditData = () => {
    Axios.get(props.selectedUrl).then(({data}) => {
        formData.value = data

        data.settings.length ? data.settings.map((item) => {
            if (item.name === 'api_key') {
                formData.value.api_key = item.value
            }

            if (item.name === 'api_secret') {
                formData.value.api_secret = item.value
            }

            if (item.name === 'payment_mode') {
                formData.value.payment_mode = item.value
            }
        }) : []
    })
}
onMounted(() => {
    if (props.selectedUrl) {
        getEditData()
    }
})

const paymentMethodTypeList = reactive([
    {
        id: 'others',
        name: t('others')
    },
    {
        id: 'paypal',
        name: t('paypal')
    },
    {
        id: 'stripe',
        name: t('stripe')
    },
    {
        id: 'sslcommerz',
        name: t('sslcommerz')
    },
    {
        id: 'razorpay',
        name: t('razorpay')
    }
])
</script>

