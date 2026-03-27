<template>
    <StripeElements
        v-if="stripeLoaded"
        v-slot="{ elements, instance }"
        ref="elms"
        :stripe-key="stripeKey"
        :instance-options="instanceOptions"
        :elements-options="elementsOptions"
    >
        <StripeElement
            ref="payment-element"
            :elements="elements"
            :options="cardOptions"
        />
    </StripeElements>
   <div class="row">
       <div class="col-3">
           <button type="button" class="btn btn-primary" @click="pay">Pay</button>
       </div>
   </div>
</template>

<script lang="ts">
import {StripeElements, StripeElement} from 'vue-stripe-js'
import {loadStripe} from '@stripe/stripe-js'
import {defineComponent, ref, onBeforeMount} from 'vue'

export default defineComponent({
    name: 'CardOnly',

    components: {
        StripeElements,
        StripeElement,
    },

    setup() {
        const stripeKey = ref('pk_test_51HoYQ1JbyRbTVw3dWCeIQdYCcAlNSgZOlfDALAtzCfLx0raOZ1dOmToWJO0HzjIdWaXkto0fwvMIdm4xDBFRl4AI00gi5pxRR1') // test key
        const instanceOptions = ref({
            // https://stripe.com/docs/js/initializing#init_stripe_js-options
        })
        const elementsOptions = ref({
            // https://stripe.com/docs/js/elements_object/create#stripe_elements-options

        })
        const cardOptions = ref({
            // https://stripe.com/docs/stripe.js#element-options

        })
        const stripeLoaded = ref(false)
        const card = ref()
        const elms = ref()

        onBeforeMount(() => {
            const stripePromise = loadStripe(stripeKey.value)
            stripePromise.then(() => {
                stripeLoaded.value = true
            })
        })



        const pay = () => {
            // Get stripe element
            const cardElement = card.value.stripeElement

            // Access instance methods, e.g. createToken()
            elms.value.instance.createToken(cardElement).then((result: object) => {
                // Handle result.error or result.token
                console.log(result)
            })
        }

        return {
            stripeKey,
            stripeLoaded,
            instanceOptions,
            elementsOptions,
            cardOptions,
            card,
            elms,
            pay
        }
    },
})
</script>


