<template>
    <button @click="razorpayPay">Pay via Razorpay</button>
</template>

<script setup>
import {ref, onMounted} from "vue"
const razorpayPay = () => {
    let options = {
        "key": 'rzp_test_5xzReaId3AoSRZ',
        "amount": 500,
        "currency": "INR",
        "name": 'Khokon',
        "image": 'https://example.com/your_logo',
        "handler": ((response) => {
            // if (response.razorpay_payment_id) {
            //     this.preloader = true;
            //     this.paypalButton = false;
            //     axiosPost('checkout', {
            //         razorpay_payment_id: response.razorpay_payment_id,
            //         amount: formData.due_amount,
            //         payment_type: 'razorpay',
            //         invoice_id: formData.id
            //     }).then((response) => {
            //         // this.$toastr.s(response.data.message);
            //         // this.paymentSuccess();
            //         // this.preloader = false;
            //         // this.paypalButton = false;
            //     });
            // }
        }),
        "theme": {
            "color": "#3399cc"
        }
    };

    console.log(options)
    const rozarpay = new Razorpay(options);
    rozarpay.open()
}
const scriptLoaded = ref(false);
onMounted(() => {
    const script = document.createElement('script');
    script.src = 'https://checkout.razorpay.com/v1/checkout.js';
    script.onload = () => {
        scriptLoaded.value = true;
        // Script has been loaded, you can now access its functions or variables
    };
    document.body.appendChild(script);

    // let options = {
    //     "key": "rzp_test_5xzReaId3AoSRZ", // Enter the Key ID generated from the Razorpay Setting -> API Keys
    //     "amount": "50000", // Amount is in currency. Default currency is INR. Hence, 50000 refers to 50000 paise
    //     "currency": "INR",
    //     "name": "Invoice",
    //     "description": "Test Transaction",
    //     "image": "https://example.com/your_logo",
    //     "handler": function (response) {
    //         console.log(response)
    //         // axios.post("PAYMENT_SUCCESS_API", {
    //         //     payment_id: response.razorpay_payment_id,
    //         //     order_id: response.razorpay_order_id,
    //         // })
    //         //     .then(function (response) {
    //         //         // Show success message
    //         //     })
    //         //     .catch(function (error) {
    //         //         // Show failed message
    //         //     });
    //     },
    //     "prefill": {
    //         "name": "Customer Name",
    //         "email": "customer.email@example.com",
    //         "contact": "9999999999"
    //     },
    //     "notes": {
    //         "address": "Customer Address"
    //     },
    //     "theme": {
    //         "color": "#3399cc"
    //     }
    // };
    // let rzp = new Razorpay(options);
    //
    // rzp.on('payment.failed', function (response) {
    //     axios.post("PAYMENT_FAILURE_API", {
    //         payment_id: response.razorpay_payment_id,
    //         order_id: response.razorpay_order_id,
    //         code: response.error.code,
    //         description: response.error.description,
    //     })
    //         .then(function (response) {
    //             // Show failed message
    //         })
    //         .catch(function (error) {
    //             // Show error message
    //         });
    // });
})
</script>
