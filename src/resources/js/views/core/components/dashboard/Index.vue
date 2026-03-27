<template>
    <div class="content-wrapper">
        <!-- Dashboard Statistics-->
        <global-dashboard-statistics
            v-if="
                canAccess('dashboard_statistics_view') &&
                canAccess('manage_global_access')
            "
        />
        <dashboard-statistics
            v-else-if="canAccess('dashboard_statistics_view')"
        />
        <!-- Payment Overview Chart-->

        <div class="row">
            <div class="col-md-9 col-sm-9 col-xs-12 mb-4"
                 v-if="canAccess('expense_overview_dashboard')"
            >
                <div class="card p-4 update-details h-100">
                    <div
                        class="w-100 d-flex justify-content-between align-items-center"
                    >
                        <label for="income_expense_overview" class="mb-0 fs-16 fw-normal text-capitalize">
                            {{ $t("income_expense_overview") }}
                        </label>
                        <select id="income_expense_overview"
                                class="custom-filter w-auto"
                                v-model="expenseFilter"
                                @change="getExpenseOverviewChart"
                        >
                            <option value="1">{{ $t("last_7_days") }}</option>
                            <option value="2">{{ $t("this_week") }}</option>
                            <option value="3">{{ $t("last_week") }}</option>
                            <option value="4">{{ $t("this_month") }}</option>
                            <option value="5">{{ $t("last_month") }}</option>
                            <option value="6">{{ $t("this_year") }}</option>
                            <option value="">{{ $t("total") }}</option>
                        </select>
                    </div>
                    <div v-if="expenseOverViewLoader" class="text-center py-5 my-5">
                        <app-loader/>
                    </div>
                    <app-chart
                        v-else
                        type="bar"
                        id="horizontalBar"
                        :labels="expenseOverViewChart.labels"
                        :data="expenseOverViewChart.datasets"
                    />
                </div>
            </div>
            <div
                class="col-md-3 col-sm-3 col-xs-12 mb-4"
                v-if="canAccess('payment_overview_dashboard')"
            >
                <div class="card p-4 update-details h-100">
                    <h6 class="mb-0 fs-16 fw-normal text-capitalize">
                        {{ $t("payment_overview") }}
                    </h6>
                    <div class="d-flex flex-column mt-3">
                            <div class="d-flex align-items-center">
                                <span class="width-18 height-18 rounded d-inline-block"
                                      style="background: #00aaf0"/>
                            <span class="text-primary p-2"> {{ $t('received') }} ({{receivedAmount}})</span>
                        </div>
                        <div class="d-flex align-items-center">
                                <span class="width-18 height-18 rounded d-inline-block"
                                      style="background: #f60"/>
                            <span class="text-primary p-2"> {{ $t('due') }} ({{dueAmount}})</span>
                        </div>
                    </div>
                    <div v-if="paymentOverviewLoader" class="text-center py-5 my-5">
                        <app-loader/>
                    </div>
                    <app-chart
                        v-else
                        type="doughnut"
                        id="doughnut"
                        :height="300"
                        :labels="paymentOverViewChart.labels"
                        :data="paymentOverViewChart.datasets"
                    />
                </div>
            </div>
        </div>
        <!--        Income & Expense Overview Chart-->
        <div class="row">
            <div
                class="col-md-12 col-sm-12 col-xs-12 h-100"
                v-if="canAccess('income_overview_dashboard')"
            >
                <div class="card p-4 update-details h-100">
                    <div
                        class="w-100 d-flex justify-content-between align-items-center"
                    >
                        <label for="income_overview" class="mb-0 fs-16 fw-normal text-capitalize">
                            {{ $t("income_overview") }}
                        </label>
                        <select id="income_overview"
                                class="custom-filter w-auto"
                                v-model="incomeOverviewFilter"
                                @change="getIncomeOverViewChart"
                        >
                            <option value="1">{{ $t("last_7_days") }}</option>
                            <option value="2">{{ $t("this_week") }}</option>
                            <option value="3">{{ $t("last_week") }}</option>
                            <option value="4">{{ $t("this_month") }}</option>
                            <option value="5">{{ $t("last_month") }}</option>
                            <option value="6">{{ $t("this_year") }}</option>
                            <option value="">{{ $t("total") }}</option>
                        </select>
                    </div>

                    <div v-if="incomeOverViewChartLoader" class="text-center py-5 my-5">
                        <app-loader/>
                    </div>
                    <app-chart
                        v-else
                        type="line"
                        id="income-overview"
                        :labels="incomeOverViewChart.labels"
                        :data="incomeOverViewChart.datasets"
                    />
                </div>
            </div>
        </div>
        <!--        Recent Invoice & Estimate -->
        <div class="row mt-4" v-if="canAccess('recent_invoice_dashboard') || canAccess('recent_estimate_dashboard')">
            <div class="col-md-6 col-sm-12 col-xs-12" v-if="canAccess('recent_invoice_dashboard')">
                <app-breadcrumb :page-title="$t('recent_invoices')"/>
                <RecentInvoice/>
            </div>

            <div class="col-md-6 col-sm-12 col-xs-12" v-if="canAccess('recent_estimate_dashboard')">
                <app-breadcrumb :page-title="$t('recent_estimates')"/>
                <RecentEstimate/>
            </div>
        </div>

        <div class="row mt-4" v-if="canAccess('recent_transaction_dashboard') || canAccess('recent_expense_dashboard')">
            <div class="col-md-6 col-sm-12 col-xs-12" v-if="canAccess('recent_transaction_dashboard')">
                <app-breadcrumb :page-title="$t('recent_transactions')"/>
                <RecentTransaction/>
            </div>

            <div class="col-md-6 col-sm-12 col-xs-12" v-if="canAccess('recent_expense_dashboard')">
                <app-breadcrumb :page-title="$t('recent_expenses')"/>
                <RecentExpenses/>
            </div>
        </div>
    </div>
</template>

<script setup>
import {onBeforeMount, ref, computed} from "vue";
import Axios from "@services/axios";
import {
    DASHBOARD_EXPENSE_OVERVIEW,
    DASHBOARD_INCOME_OVERVIEW,
    DASHBOARD_PAYMENT_OVERVIEW,
} from "@services/endpoints/invoice";
import GlobalDashboardStatistics from "@/core/components/dashboard/GlobalDashboardStatistics.vue";
import DashboardStatistics from "@/core/components/dashboard/DashboardStatistics.vue";
import usePermission from "@/core/global/composable/usePermission";
import RecentInvoice from "@/core/components/dashboard/RecentInvoice.vue";
import RecentEstimate from "@/core/components/dashboard/RecentEstimate.vue";
import RecentTransaction from "@/core/components/dashboard/RecentTransaction.vue";
import RecentExpenses from "@/core/components/dashboard/RecentExpenses.vue";

import {useI18n} from "vue-i18n";
import {numberWithCurrencySymbol} from "@utilities/helpers";

const {canAccess} = usePermission();
const {t} = useI18n();

const incomeOverViewChart = ref({
    labels: [],
    datasets: [
        {
            data: [],
            backgroundColor: "#0064f0",
            borderColor: "#00aaf0",
            borderWidth: 3,
            fill: false,
        },
    ],
});
const incomeOverviewFilter = ref(4);
const incomeOverViewChartLoader = ref(false);

const getIncomeOverViewChart = () => {
    incomeOverViewChartLoader.value = true;
    let url = incomeOverviewFilter.value
        ? `${DASHBOARD_INCOME_OVERVIEW}/${incomeOverviewFilter.value}`
        : DASHBOARD_INCOME_OVERVIEW;
    Axios.get(url)
        .then(({data}) => {
            incomeOverViewChart.value.labels = Object.keys(data);
            incomeOverViewChart.value.datasets[0].data = Object.values(
                data
            ).map((item) => item.income);
        })
        .finally(() => (incomeOverViewChartLoader.value = false));
};

const paymentOverviewLoader = ref(false);
const paymentOverViewChart = ref({
    datasets: [
        {
            data: [],
            backgroundColor: ["#00aaf0", "#f60"],
            fill: false,
            borderWidth: 0,
        },
    ],
});

const getPaymentOverviewChart = () => {
    paymentOverviewLoader.value = true;
    Axios.get(DASHBOARD_PAYMENT_OVERVIEW)
        .then(({data}) => {
            paymentOverViewChart.value.labels = Object.keys(
                data.payment_overview
            );
            paymentOverViewChart.value.datasets[0].data = Object.values(
                data.payment_overview
            );
        })
        .finally(() => (paymentOverviewLoader.value = false));
};

const receivedAmount = computed(() => {
    return numberWithCurrencySymbol(paymentOverViewChart.value.datasets[0].data[0]);
});
const dueAmount = computed(() => {
    return numberWithCurrencySymbol(paymentOverViewChart.value.datasets[0].data[1]);
});

const expenseOverViewLoader = ref(false);
const expenseFilter = ref(2);
const expenseOverViewChart = ref({
    labels: [],
    datasets: [
        {
            label: t("income"),
            data: [],
            backgroundColor: "#00aaf0",
            borderWidth: 0,
            fill: false,
        },
        {
            label: t("expense_label"),
            data: [120, 180, 250],
            backgroundColor: "#f60",
            borderWidth: 0,
            fill: false,
        }
    ]
});
const getExpenseOverviewChart = () => {
    let url = expenseFilter.value
        ? `${DASHBOARD_EXPENSE_OVERVIEW}/${expenseFilter.value}`
        : DASHBOARD_EXPENSE_OVERVIEW;
    expenseOverViewLoader.value = true;
    Axios.get(url)
        .then(({data}) => {
            if (expenseFilter.value) {
                expenseOverViewChart.value.labels = data.labels;
                expenseOverViewChart.value.datasets[0].data = Object.values(
                    data.income
                ).map((item) => item.income);
                expenseOverViewChart.value.datasets[1].data = Object.values(
                    data.expense
                ).map((item) => item.expense);
            } else {
                let labels = [
                    Object.keys(data.income),
                    Object.keys(data.expense),
                ].flat();
                let unique = labels.filter(
                    (value, index, array) => array.indexOf(value) === index
                );
                expenseOverViewChart.value.labels = unique;
                expenseOverViewChart.value.datasets[0].data = Object.values(
                    data.income
                ).map((item) => item.income);
                expenseOverViewChart.value.datasets[1].data = Object.values(
                    data.expense
                ).map((item) => item.expense);
            }
        })
        .finally(() => (expenseOverViewLoader.value = false));
};


onBeforeMount(() => {
    if (canAccess("income_overview_dashboard")) {
        getIncomeOverViewChart();
    }
    if (canAccess("payment_overview_dashboard")) {
        getPaymentOverviewChart();
    }
    if (canAccess("expense_overview_dashboard")) {
        getExpenseOverviewChart();
    }
});
</script>
