<template>
    <app-modal :modal-id="modalId"
               modal-size="large"
               :title="$t('stripe_payment')"
               :save-button-label="$t('pay_now')"
               save-button-icon="bi-credit-card"
               :preloader="preloader"
               @submit="pay" @close="closeModal">

        <template v-slot:body>
            <StripeElements
                v-if="stripeLoaded"
                v-slot="{ elements, instance }"
                ref="elms"
                :stripe-key="stripeKey"
                :instance-options="instanceOptions"
                :elements-options="elementsOptions"
            >
                <StripeElement
                    ref="card"
                    :elements="elements"
                    :options="cardOptions"
                />
            </StripeElements>
            <div class="mt-2">
                <small class="text-danger" v-if="Object.keys(stripeApiErrors).length">{{ stripeApiErrors }}</small>
            </div>

        </template>

    </app-modal>
</template>

<script setup>
import {ref, onBeforeMount} from "vue";
import {StripeElements, StripeElement} from 'vue-stripe-js'
import {loadStripe} from '@stripe/stripe-js'
import {Modal} from "bootstrap";
import Axios from "@services/axios";
import {useToast} from "vue-toastification";
import {CUSTOMER_DUE_INVOICE_PAYMENT} from "@services/endpoints/invoice";
import useEmitter from "@/core/global/composable/useEmitter";

const toast = useToast();
const props = defineProps({
    modalId: String,
    tableId: String,
    invoiceData: {},
    paymentMethodObj: {}
})

const emit = defineEmits(['close'])
const emitter = useEmitter();
const stripeKey = ref(props.paymentMethodObj.api_key) // test key
const instanceOptions = ref({
    // https://stripe.com/docs/js/initializing#init_stripe_js-options
})
const elementsOptions = ref({
    // https://stripe.com/docs/js/elements_object/create#stripe_elements-options

})
const cardOptions = ref({
    // https://stripe.com/docs/stripe.js#element-options
    value: {
        postalCode: false,
    },
})

const stripeLoaded = ref(false)
const scriptLoaded = ref(false)
const card = ref()
const elms = ref()
const stripeApiErrors = ref('')
const preloader = ref(false)
const pay = () => {
    stripeApiErrors.value = {}
    // Get stripe element
    const cardElement = card.value.stripeElement

    elms.value.instance.createToken(cardElement).then((result) => {
        // Handle result.error or result.token
        if (result.error) {
            stripeApiErrors.value = result?.error?.message
            return '';
        }
        if (result.token) {
            preloader.value = true
            Axios.post(`${CUSTOMER_DUE_INVOICE_PAYMENT}/${props.invoiceData?.id}`, {
                'payment_method': 'stripe',
                'token': result.token?.id
            }).then((response) => {
                toast.success(response?.data?.message);
                emitter.emit("reload-invoice-table");
                closeModal();
            }).catch((error) => {
                toast.error(error?.response?.data?.message);
            })

        }
    }).catch((error) => {
        toast.error('Stripe payment failed');
    }).finally(() => preloader.value = false)
}

const closeModal = () => {
    let modal = Modal.getInstance(document.getElementById(props.modalId));
    modal.hide();
    emit("close");
}

onBeforeMount(() => {
    const stripePromise = loadStripe(stripeKey.value)
    stripePromise.then(() => {
        stripeLoaded.value = true
    })

    const script = document.createElement('script');
    script.src = 'https://js.stripe.com/v3/';
    script.onload = () => {
        scriptLoaded.value = true;
        // Script has been loaded, you can now access its functions or variables
    };
    document.body.appendChild(script);
})

</script>
<style scoped>
.InputContainer .InputElement{
    position: absolute;
    top: 0;
    color: brown !important;
}
</style>

