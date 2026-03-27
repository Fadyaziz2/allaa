<template>
    <div class="content-wrapper">
        <app-breadcrumb :page-title="$t('customizations')"/>

        <app-tab id="setting-tab" area-label="vertical" :tabs="tabs"/>

    </div>
</template>

<script setup>
import {ref, markRaw} from "vue"
import {useI18n} from 'vue-i18n';
import usePermission from "@/core/global/composable/usePermission";
import InvoiceCustomization from "@/invoice/customization/InvoiceCustomization.vue";
import EstimateCustomization from "@/invoice/customization/EstimateCustomization.vue";
import PaymentCustomization from "@/invoice/customization/PaymentCustomization.vue";

const { canAccess } = usePermission();
const {t} = useI18n();
const tabs = ref([
    {
        icon: "bi bi-stickies-fill",
        title: t("invoices"),
        showHeader: true,
        key: 'invoices',
        component: markRaw(InvoiceCustomization),
        permission: canAccess('invoice_setting_update')
    },
    {
        icon: "bi bi-clipboard2-pulse-fill",
        title: t("estimates"),
        showHeader: true,
        key: 'estimates',
        component: markRaw(EstimateCustomization),
        permission: canAccess('estimate_setting_update')
    }, {
        icon: "bi bi-credit-card-2-front-fill",
        title: t("payments"),
        showHeader: true,
        key: 'payments',
        component: markRaw(PaymentCustomization),
        permission: canAccess('payment_setting_update')
    },
])

</script>

