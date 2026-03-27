<script setup>
import {onMounted, ref} from "vue";
import Axios from "@services/axios";
import {DOWNLOAD_ESTIMATE} from "@services/endpoints/invoice";
import {useToast} from "vue-toastification";

const toast = useToast()
const props = defineProps({
    id: {},
});
const invoiceURL = ref(null); // Add this line
const preloader = ref(false);

const invoicePreview = () => {
    preloader.value = true;
    Axios.get(`${DOWNLOAD_ESTIMATE}/${props.id}?preview=preview`, {responseType: 'arraybuffer'}).then(response => {
        // Create a blob from the response data
        const blob = new Blob([response.data], {type: 'application/pdf'});

        // Create a URL for the blob
        invoiceURL.value = window.URL.createObjectURL(blob); // Update this line
    }).catch(error => {
        toast.error("Quotation preview failed. Please try again later.");
    }).finally(() => preloader.value = false);
}

onMounted(() => {
    invoicePreview()
})
</script>

<template>
    <div class="content-wrapper">
        <app-breadcrumb :page-title="$t('estimate_preview')"/>
        <app-loader v-if="preloader"></app-loader>
        <iframe v-else :src="invoiceURL" width="100%" height="750px"></iframe>
    </div>

</template>

<style scoped lang="scss">

</style>
