<template>
    <app-modal :modal-id="modalId"
               :title="$t('invoice_due_payment')"
               modal-size="large"
               :save-button-label="$t('pay_now')"
               save-button-icon="bi-credit-card"
               :preloader="preloader"
               @submit="submit" @close="closeModal">

        <template v-slot:body>
            <div class="mb-4">
                <app-input type="select" id="payment_method"
                           :label="$t('select_payment_method')"
                           listValueField="name"
                           list-key-field="type"
                           :options="paymentMethodList"
                           v-model="formData.payment_method"
                           :choose-label="$t('choose_a_payment_method')"
                           :errors="$errors(errors, 'payment_method')"/>
            </div>

        </template>
    </app-modal>

    <stripe-payment-modal v-if="isStripePaymentModal"
                          :table-id="tableId"
                          modal-id="stripe-payment-modal"
                          :invoice-data="invoiceData"
                          :payment-method-obj="paymentMethodObj"
                          @close="closeModal"/>
</template>

<script setup>
import {useSubmitForm} from "@/core/global/composable/modal/useSubmitForm";
import {ref, onMounted, computed} from "vue";
import {CUSTOMER_DUE_INVOICE_PAYMENT, SELECTED_CUSTOMER_PAYMENT_METHOD} from "@services/endpoints/invoice";
import Axios from "@services/axios";
import {useToast} from "vue-toastification";
import StripePaymentModal from "@/invoice/Invoice/payment/StripePaymentModal.vue";
import useEmitter from "@/core/global/composable/useEmitter";
import store from "@store/index";
import {urlGenerator} from "@utilities/urlGenerator";

const props = defineProps({
    modalId: String,
    tableId: String,
    invoiceData: {},
})
const emit = defineEmits(['close'])
const emitter = useEmitter();

const {preloader, formData, errors, closeModal, afterError} = useSubmitForm(props, emit)
const toast = useToast()

const isStripePaymentModal = ref(false)
const settingInfo = computed(() => store.getters["setting/setting"]);

const submit = () => {
    if (formData.value.payment_method === 'stripe') {
        isStripePaymentModal.value = true
        return true;
    }
    if (formData.value.payment_method === 'razorpay') {
        razorpayPay()
        return true
    } else {
        preloader.value = true
        Axios.post(`${CUSTOMER_DUE_INVOICE_PAYMENT}/${props.invoiceData?.id}`, formData.value).then((response) => {
            window.location.replace(response.data.url)
        }).catch(({response}) => {
            afterError(response)
        }).finally(() => preloader.value = false)
    }

}

const razorpayPay = () => {
    let options = {
        "key": paymentMethodObj.value.api_key,
        "amount": props.invoiceData?.due_amount * 100,
        "currency": "INR",
        "name": settingInfo ? settingInfo.value.company_name : 'N/A',
        "image": settingInfo ? urlGenerator(settingInfo.value.company_logo) : urlGenerator('assets/images/logo.svg'),
        "handler": ((response) => {
            if (response.razorpay_payment_id) {
                preloader.value = true;
                Axios.post(`${CUSTOMER_DUE_INVOICE_PAYMENT}/${props.invoiceData?.id}`, {
                    razorpay_payment_id: response.razorpay_payment_id,
                    payment_method: 'razorpay',
                }).then((response) => {
                    toast.success(response?.data?.message);
                    emitter.emit("reload-invoice-table");
                    closeModal();
                }).finally(() => preloader.value = false);
            }
        }),
        "theme": {
            "color": "#3399cc"
        }
    };
    const rozarpay = new Razorpay(options);
    rozarpay.open()
}

const paymentMethodList = ref([])
const getPaymentMethod = () => {
    Axios.get(SELECTED_CUSTOMER_PAYMENT_METHOD).then(({data}) => {
        paymentMethodList.value = data.data
    })
}

const paymentMethodObj = computed(() => paymentMethodList.value.find(item => item.type === formData.value.payment_method));
const scriptLoaded = ref(false);
const getRazorpayScript = () => {
    const script = document.createElement('script');
    script.src = 'https://checkout.razorpay.com/v1/checkout.js';
    script.onload = () => {
        scriptLoaded.value = true;
    };
    document.body.appendChild(script);
}
onMounted(() => {
    getPaymentMethod()
    getRazorpayScript()

})


</script>


