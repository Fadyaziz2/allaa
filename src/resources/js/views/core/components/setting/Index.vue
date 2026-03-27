<template>
    <div class="content-wrapper">
        <app-breadcrumb :page-title="$t('settings')"/>

        <app-tab id="setting-tab" area-label="vertical" :tabs="tabs"/>
    </div>
</template>

<script setup>
import {ref, markRaw} from "vue"
import {useI18n} from 'vue-i18n';
import InformationSetting from "@/core/components/setting/general/InformationSetting.vue";
import SystemSetting from "@/core/components/setting/general/SystemSetting.vue";
import EmailSetting from "@/core/components/setting/general/EmailSetting.vue";
import CronJobSetting from "@/core/components/setting/general/CronJobSetting.vue";
import usePermission from '@/core/global/composable/usePermission';
import PaymentMethodList from "@/core/components/setting/paymentMethod/PaymentMethodList.vue";
import Notes from "@/invoice/setting/notes/Index.vue";
import TaxList from "@/invoice/setting/tax/TaxList.vue"
import InvoiceCustomization from "@/invoice/customization/InvoiceCustomization.vue";
import EstimateCustomization from "@/invoice/customization/EstimateCustomization.vue";
import PaymentCustomization from "@/invoice/customization/PaymentCustomization.vue";

const { canAccess } = usePermission();
const {t} = useI18n();
const tabs = ref([
    {
        icon: "bi bi-gear-fill",
        title: t("general_setting"),
        showHeader: true,
        key: 'general_setting',
        component: markRaw(InformationSetting),
        permission: canAccess('view_general_setting')
    },
    {
        icon: "bi bi-x-diamond-fill",
        title: t('system_setting'),
        showHeader: true,
        key: 'system_setting',
        component: markRaw(SystemSetting),
        permission: canAccess('view_general_setting')
    },
    {
        icon: "bi bi-box-fill",
        title: t('cron_job'),
        showHeader: true,
        key: 'cron_job',
        component: markRaw(CronJobSetting),
        permission: canAccess('view_cronjob')
    },{
        icon: "bi bi-envelope-at-fill",
        title: t('email_setting'),
        showHeader: true,
        key: 'email_setting',
        component: markRaw(EmailSetting),
        permission: canAccess('view_email_setting')
    },
    {
        icon: "bi bi-credit-card-2-front-fill",
        title: t('payment_method'),
        key: 'payment_method',
        showHeader: true,
        component: markRaw(PaymentMethodList),
        permission: canAccess('view_payment_methods'),
        headerButton: {
            label: t('add_payment_method'),
            class: 'btn btn-primary',
            permission: !!canAccess('create_payment_methods')
        }
    },
    {
        icon: "bi bi-journal-bookmark-fill",
        title: t('notes'),
        key: 'notes',
        showHeader: true,
        component: markRaw(Notes),
        permission: canAccess('view_notes'),
        headerButton: {
            label: t('add_note'),
            class: 'btn btn-primary',
            permission: !!canAccess('create_notes')
        }
    },

    {
        icon: "bi bi-tags-fill",
        title: t('taxes'),
        key: 'taxes',
        showHeader: true,
        component: markRaw(TaxList),
        permission: canAccess('view_taxes'),
        headerButton: {
            label: t('add_tax'),
            class: 'btn btn-primary',
            permission: !!canAccess('create_taxes')
        }
    },
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

