<script setup>
import { onMounted, ref } from "vue";
import Axios from "@services/axios";
import {THERMAL_ESTIMATE} from "@services/endpoints/invoice";
import { useToast } from "vue-toastification";
import {canAccess} from "@utilities/permission";
import {urlGenerator} from "@utilities/urlGenerator";
const props = defineProps({
    id: {
        type: [String, Number],
        required: true
    }
});

const toast = useToast();
const preloader = ref(false);
const pdfUrl = ref("");

const invoicePreview = () => {
    preloader.value = true;

    Axios.get(`${THERMAL_ESTIMATE}/${props.id}?preview=true`, { responseType: 'arraybuffer' })
        .then(response => {
            const blob = new Blob([response.data], { type: 'application/pdf' });
            pdfUrl.value = URL.createObjectURL(blob);

            // Automatically trigger print after iframe loads
            const iframe = document.getElementById("thermal-iframe");
            if (iframe) {
                iframe.onload = () => {
                    setTimeout(() => {
                        iframe.contentWindow.focus();
                        iframe.contentWindow.print();
                    }, 800);
                };
            }
        })
        .catch(() => {
            toast.error("Invoice preview failed. Please try again later.");
        })
        .finally(() => {
            preloader.value = false;
        });
};

const createInvoice = () => {
    router.push({
        name: "create-estimate"
    })
}

onMounted(() => {
    invoicePreview();
});
</script>

<template>
    <div class="content-wrapper">
        <app-breadcrumb :page-title="$t('estimate_thermal_preview')">
            <template #breadcrumb-actions>
                <a v-if="canAccess('create_estimates')" :href="urlGenerator(`create-quotation`)"
                             class="btn btn-primary text-white d-flex align-items-center">
                    {{ $t('add_estimate') }}
                </a>
            </template>
        </app-breadcrumb>
        <app-loader v-if="preloader" />

        <!-- Show iframe only when PDF URL is available -->
        <iframe
            v-if="pdfUrl"
            id="thermal-iframe"
            :src="pdfUrl"
            style="width: 100%; height: calc(100vh - 100px); border: none;"
        ></iframe>
    </div>
</template>
