<script setup>
import {onMounted, ref} from "vue";
import Axios from "@services/axios";
import {DOWNLOAD_INVOICE} from "@services/endpoints/invoice";
import {useToast} from "vue-toastification";

const props = defineProps({
    id: {},
});
const invoiceURL = ref(null);
const toast = useToast()
const preloader = ref(false);

const invoicePreview = () => {
     preloader.value = true
    Axios.get(`${DOWNLOAD_INVOICE}/${props.id}?preview=preview`, {responseType: 'arraybuffer'}).then(response => {
        // Create a blob from the response data
        const blob = new Blob([response.data], {type: 'application/pdf'});

        // Create a URL for the blob
        invoiceURL.value = window.URL.createObjectURL(blob); // Update this line
    }).catch(error => {
        toast.error("Invoice preview failed. Please try again later.");
    }).finally(() => preloader.value = false);
}

onMounted(() => {
    invoicePreview()
})
</script>

<template>
    <div class="content-wrapper">
        <app-breadcrumb :page-title="$t('invoice_preview')"/>
        <app-loader v-if="preloader"></app-loader>
        <iframe v-else :src="invoiceURL" width="100%" height="750px"></iframe>
    </div>
</template>
