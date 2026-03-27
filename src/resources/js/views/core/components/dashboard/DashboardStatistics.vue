<template>
    <div>
        <div v-if="statisticsLoader" class="text-center py-5 my-5">
            <app-loader />
        </div>
        <div v-else class="row">
            <div class="col-sm-6 col-md-4 col-lg-6 col-xl-4 col-xxl-3">
                <app-widget
                    :title="numberWithCurrencySymbol(statistics.total_amount)"
                    :sub-title="$t('total_amount')"
                    :icon="cardIcons.total_amount"
                />
            </div>
            <div class="col-sm-6 col-md-4 col-lg-6 col-xl-4 col-xxl-3">
                <app-widget
                    :title="
                        numberWithCurrencySymbol(statistics.total_paid_amount)
                    "
                    :sub-title="$t('total_paid')"
                    :icon="cardIcons.total_paid"
                />
            </div>
            <div class="col-sm-6 col-md-4 col-lg-6 col-xl-4 col-xxl-3">
                <app-widget
                    :title="
                        numberWithCurrencySymbol(statistics.total_due_amount)
                    "
                    :sub-title="$t('total_due')"
                    :icon="cardIcons.total_due"
                />
            </div>
            <div class="col-sm-6 col-md-4 col-lg-6 col-xl-4 col-xxl-3">
                <app-widget
                    :title="statistics.total_invoice"
                    :sub-title="$t('total_invoice')"
                    :icon="cardIcons.total_invoice"
                />
            </div>
            <div class="col-sm-6 col-md-4 col-lg-6 col-xl-4 col-xxl-3">
                <app-widget
                    :title="statistics.total_paid_invoice"
                    :sub-title="$t('total_paid_invoice')"
                    :icon="cardIcons.total_paid_invoice"
                />
            </div>
            <div class="col-sm-6 col-md-4 col-lg-6 col-xl-4 col-xxl-3">
                <app-widget
                    :title="statistics.total_due_invoice"
                    :sub-title="$t('total_due_invoice')"
                    :icon="cardIcons.total_due_invoice"
                />
            </div>
        </div>
    </div>
</template>

<script setup>
import { onBeforeMount, ref } from "vue";
import { numberWithCurrencySymbol } from "@utilities/helpers";
import Axios from "@services/axios";
import { DASHBOARD_STATISTICS } from "@services/endpoints/invoice";
import {urlGenerator} from "@utilities/urlGenerator";

const statisticsLoader = ref(false);
const statistics = ref({});
const cardIcons = {
    total_amount : urlGenerator(`assets/images/amount.svg`),
    total_customer : urlGenerator(`assets/images/customer.svg`),
    total_product : urlGenerator(`assets/images/product.svg`),
    total_invoice : urlGenerator(`assets/images/invoice.svg`),
    total_paid : urlGenerator(`assets/images/paid.svg`),
    total_paid_invoice : urlGenerator(`assets/images/paid-invoice.svg`),
    total_due : urlGenerator(`assets/images/due-amount.svg`),
    total_due_invoice : urlGenerator(`assets/images/due-invoice.svg`),
}
const getStatistics = () => {
    statisticsLoader.value = true;
    Axios.get(DASHBOARD_STATISTICS)
        .then(({ data }) => {
            statistics.value = data;
        })
        .finally(() => (statisticsLoader.value = false));
};
onBeforeMount(() => {
    getStatistics();
});
</script>
