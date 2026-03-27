<template>
    <div class="content-wrapper">
        <h1 class="mt-5">{{ $t('welcome_to_dashboard') }}</h1>
        <div class="row">
            <status-bar></status-bar>
        </div>
        <div class="row my-5">
            <div class="col-md-4 col-sm-6 col-xs-12 mb-3">
                <div class="card p-4 update-details h-100">
                    <h6 class="mb-0 fs-6 "> Line Chart </h6>
                <div class="card p-4 update-details">
                    <h6 class="mb-0 "> Line Chart </h6>
                    <app-chart type="line" id="line" :labels='["Vue js", "PHP", "Laravel", "Golang", "Python"]'
                        :data='[12, 80, 73, 65, 46]'
                        :background-color="['DeepSkyBlue', 'DarkTurquoise', 'MediumSlateBlue', 'Wheat', 'Chocolate']" />
                </div>
            </div>
            <div class="col-md-4 col-sm-6 col-xs-12 mb-3">
                <div class="card p-4 update-details">
                    <h6 class="mb-0"> Doughnut Chart </h6>
                    <app-chart type="doughnut" id="doughnut" :labels='["Laravel", "Golang", "Python"]' :data='[90, 45, 85,]'
                        :background-color="['DeepSkyBlue', 'DarkTurquoise', 'MediumSlateBlue', 'Wheat', 'Chocolate']" />
                </div>
            </div>
            <div class="col-md-4 col-sm-6 col-xs-12 mb-3">
                <div class="card p-4 update-details">
                    <h6 class="mb-0"> Top Selling Product </h6>
                    <app-chart type="pie" id="pie" :height="160" :width="160" :labels='["Vue js", "PHP", "Laravel",]'
                        :data='[12, 19, 3,]'
                        :background-color="['DeepSkyBlue', 'DarkTurquoise', 'MediumSlateBlue', 'Wheat', 'Chocolate']" />
                </div>
            </div>

            <div class="col-md-4 col-sm-6 col-xs-12 mb-3">
                <div class="card p-4 update-details">
                    <h6 class="mb-0"> Content Hover Over Tooltip</h6>
                    <app-chart type="line" id="polarArea" :labels='["Vue js", "PHP", "Laravel", "Golang", "Python"]'
                        :data='[12, 19, 3, 5, 6]'
                        :background-color="['DeepSkyBlue', 'DarkTurquoise', 'MediumSlateBlue', 'Wheat', 'Chocolate']" />
                </div>
            </div>

            <div class="col-md-4 col-sm-6 col-xs-12 mb-3">
                <div class="card p-4 update-details">
                    <div class="w-100 d-flex justify-content-between align-items-center">
                        <h6 class="mb-0"> Income & Expense</h6>
                        <select class="custom-filter w-auto">
                            <option value="1">This Month</option>
                            <option value="1">This Year</option>
                            <option value="1">This Week</option>
                        </select>
                    </div>
                    <app-chart type="bar" id="incomeExpense" :labels='["Income", "Expense"]' :data='[98, 78, 65, 45, 47]'
                        :background-color="['DeepSkyBlue', 'DarkTurquoise', 'MediumSlateBlue', 'Wheat', 'Chocolate']" />
                </div>
            </div>
            <div class="col-md-4 col-sm-6 col-xs-12 mb-3">
                <div class="card p-4 update-details">
                    <h6 class="mb-0"> Bar Chart </h6>
                    <app-chart type="bar" id="horizontalBar" :labels='["Vue js", "PHP", "Python"]' :data='[100, 19, 65]'
                        :background-color="'rgba(153, 102, 255, 1)'" :border-color="'rgba(153, 102, 255, 1)'" />
                </div>
            </div>

        </div>






        <div class="mb-4">
            <app-input type="advance-multi-select" id="multi-users" listValueField="full_name" list-key-field="id"
                v-model="multiUser" :loading-length="10" fetch-url="multi-select" :placeholder="'choose_a_user'" />
        </div>


        <div class="mb-4">
            <app-input id="name" type="text" label="Name" label-required placeholder="Enter name" v-model="formData.name"
                :errors="$errors(errors, 'name')" />
        </div>

        <div class="mb-4">
            <app-input type="email" id="email" label="Email" :label-required="true" placeholder="Enter email"
                v-model="formData.email" />
        </div>

        <div class="mb-4">
            <app-input type="password" id="password" label="Password" :label-required="true" placeholder="Enter password"
                v-model="formData.password" />
        </div>

        <div class="mb-4">
            <app-input type="number" id="number" label="Number" :label-required="true" placeholder="Enter number"
                v-model="formData.number" />
        </div>

        <div class="mb-4">
            <app-input type="select" id="select" label="Select" :label-required="true" list-value-field="name"
                :show-search="true" :options="selectOptions" choose-label="choose_a_status" v-model="formData.id" />

        </div>

        <div class="mb-4">
            <app-input type="multi-select" id="list-select" label="Multi select" :label-required="true"
                list-value-field="full_name" :show-search="true" choose-label="multi-select" :options="selectOptions"
                v-model="multiTest" />

        </div>

        <div class="mb-4">
            <app-input type="radio" id="decimal_separator" name="decimal_separator" label="Radio" list-value-field="name"
                v-model="formData.radioValue" :options="selectOptions" />
        </div>

        <div class="mb-4">
            <app-input type="checkbox" id="custom_checkbox" label="demo" name="custom_checkbox" list-value-field="name"
                v-model="formData.checkbox_value" :options="selectOptions" />
        </div>

        <div class="mb-4">
            <app-input type="date" v-model="date" />
        </div>

        <div class="mb-4">
            <app-input type="image-uploader" id="image-upload" v-model="image" />
        </div>


        <div class="mb-4">
            <!--                    <app-input-->
            <!--                        type="advance-search-select"-->
            <!--                        id="users"-->
            <!--                        listValueField="name"-->
            <!--                        list-key-field="id"-->
            <!--                        v-model="formData.user_id"-->
            <!--                        :loading-length="10"-->
            <!--                        fetch-url="users"-->
            <!--                        :placeholder="'choose_a_user'"-->
            <!--                    />-->

        </div>


        <div class="mb-4">
            <app-input type="editor" id="editor" v-model="formData.content" />
        </div>


        <app-breadcrumb :page-title="('datatable')">
            <template #breadcrumb-actions>
                <div class="d-flex">
                    <a href="" class="btn btn-primary" @click.prevent="isModalActive = true">Open Modal</a>
                </div>
            </template>
        </app-breadcrumb>


        <app-datatable id="user-table" :options="options" @action="actionTiger" />

        <payment-setting-modal v-if="isModalActive" modal-id="payment-modal" @close="closeModal" />
        <app-delete-modal v-if="isDeleteModalActive" modal-id="delete-modal" @cancelled="isDeleteModalActive = false"
            @confirmed="confirmed" />

        <fieldset class="mt-4">
            <legend>Badge-square-fill</legend>
            <span class="badge-square-fill bg-success">
                Approved
            </span>
            <span class="badge-square-fill bg-warning">
                In progress
            </span>
            <span class="badge-square-fill bg-primary">
                Primary
            </span>
            <span class="badge-square-fill bg-danger">
                Rejected
            </span>
            <span class="badge-square-fill bg-info">
                Information
            </span>

    </fieldset>
    <fieldset class="mt-4">
      <legend>Badge-square-light</legend>
      <span class="badge-square-light bg-success">
        Approved
      </span>
      <span class="badge-square-light bg-warning">
        In progress
      </span>
      <span class="badge-square-light bg-primary">
        Success
      </span>
      <span class="badge-square-light bg-danger">
        Rejected
      </span>
      <span class="badge-square-light bg-info">
        Information
      </span>

        </fieldset>

        <fieldset class="mt-4">
            <legend>Badge-rounded </legend>
            <span class="badge-rounded bg-success">
                Success
            </span>
            <span class="badge-rounded bg-info">
                info
            </span>
            <span class="badge-rounded bg-danger">
                danger
            </span>
            <span class="badge-rounded bg-warning">
                warning
            </span>
            <span class="badge-rounded bg-primary">
                Primary
            </span>
        </fieldset>
    </div>
</template>

<script>
import statusBar from "../../global/status-bar/status.vue";
import { ref } from "vue";
import AppInput from "@/core/global/input/FormInput.vue";
import useEmitter from "@/core/global/composable/useEmitter";
import PaymentSettingModal from "@/core/components/setting/payment/PaymentSettingModal.vue";
import AppBreadcrumb from "@/core/global/breadcrumb/Breadcrumb.vue";
import { useI18n } from 'vue-i18n';

export default {
    name: "Index",
    components: {
        AppBreadcrumb,
        AppInput,
        PaymentSettingModal,
        statusBar,
    },

    setup() {
        const date = ref();
        const formData = ref({
            id: '',
            user_id: '',
            content: "Bangladesh",
            radioValue: 4,
            checkbox_value: [1, 3]
        })
        const image = ref(null)
        const multiTest = ref([])
        const multiUser = ref([1, 2, 3, 4])
        const selectOptions = ref([
            { id: 1, name: 'option 1' },
            { id: 2, name: 'option 2' },
            { id: 3, name: 'option 3' },
            { id: 4, name: 'option 4' },
            { id: 5, name: 'option 5' },

        ])

        const errors = ref({
            name: ["Name filed"]
        })

        const selectedDateRange = ref(null)


        const isModalActive = ref(false)
        const closeModal = () => {
            isModalActive.value = false
        }
        const isDeleteModalActive = ref(false)


        const confirmed = () => {
            console.log("confirm")
            isDeleteModalActive.value = false
        }
        const { t } = useI18n();
        const options = ref({
            url: 'datatableusers',
            pageSize: 5,
            rowLimit: 10,
            orderBy: 'desc',
            showGridView: false,
            actionType: 'dropdown',
            paginationType: 'pagination',
            enableRowSelect: false,
            enableBulkSelect: false,
            showSearch: true,
            showFilter: true,
            exportData: () => {
                console.log('Here export data ...')
            },
            importData: () => {
                console.log('Work for import data...')
            },
            filters: [
                {
                    type: 'search-select',
                    key: 'single-select',
                    label: 'Category',
                    options: [
                        {
                            id: 1,
                            name: 'Men Dress'
                        },
                        {
                            id: 2,
                            name: 'Women Dress'
                        }
                    ],
                    permission: true,
                },
                {
                    type: 'checkbox',
                    key: 'checkbox',
                    label: 'Dress Type',
                    options: [
                        { id: 1, name: 'Option 1' },
                        { id: 2, name: 'Option 2' },
                        { id: 3, name: 'Option 3' },
                    ],
                    permission: true,
                },

                {
                    type: 'advance-search-select',
                    key: 'advance-test',
                    label: 'Advance select',
                    listKeyField: 'id',
                    listValueField: 'name',
                    rowPerLoad: 10,
                    fetchUrl: 'users',
                    permission: true,
                },

                {
                    type: 'multi-select-filter',
                    key: 'multi-test',
                    label: 'Multi select',
                    listKeyField: 'id',
                    listValueField: 'name',
                    rowPerLoad: 10,
                    fetchUrl: 'users',
                    permission: true,
                }
            ],
            columns: [
                {
                    title: t('name'),
                    type: 'text',
                    key: 'full_name'
                },
                {
                    title: 'Email',
                    type: 'text',
                    key: 'email'
                },
                /*{
                    title: 'Quantity',
                    type: 'text',
                    key: 'quantity',
                    accountAble: true
                },
                {
                    title: 'Total',
                    type: 'text',
                    key: 'total',
                    accountAble: true
                },*/
                /*{
                    title: 'Code',
                    type: 'custom-html',
                    key: 'email',
                    modifier: (value) => {
                        return `---`;
                    }
                },
                {
                    title: 'SKU',
                    type: 'custom-html',
                    key: 'email',
                    modifier: (value) => {
                        return `---`;
                    }
                },
                {
                    title: 'Category',
                    type: 'custom-html',
                    key: 'email',
                    modifier: (value) => {
                        return `---`;
                    }
                },
                {
                    title: 'Purchase Price',
                    type: 'custom-html',
                    key: 'email',
                    modifier: (value) => {
                        return `---`;
                    }
                },
                {
                    title: 'Sales Price',
                    type: 'custom-html',
                    key: 'email',
                    modifier: (value) => {
                        return `---`;
                    }
                },
                {
                    title: 'Status',
                    type: 'custom-html',
                    align: 'center',
                    key: 'status',
                    modifier: (status) => {
                        return `<i class="bi bi-check-circle-fill text-${status.class}"></i>`;
                    }
                },*/
                {
                    title: 'Action',
                    type: 'action',
                    align: 'right'
                },
            ],
            actions: [
                {
                    title: 'edit',
                    type: 'edit'
                }
            ],
        })

        const emitter = useEmitter()
        const actionTiger = (row, action, index) => {
            if (action.type === 'edit') {
                isDeleteModalActive.value = true
                // axiosDelete(`datatableusers/${row.id}`).then((res) => {
                //     emitter.emit('reload-user-table');
                // })
            }
        }

        const chartData = ref({
            labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
            datasets: [
                {
                    label: 'Data One',
                    backgroundColor: '#f87979',
                    data: [40, 20, 12, 100, 15, 30, 60, 90, 150, 120, 80, 75]
                },
                {
                    label: 'Data Two',
                    backgroundColor: '#007ACC',
                    data: [40, 20, 12, 100, 15, 30, 60, 90, 150, 120, 80, 75]
                }
            ]
        })

        const chartOptions = ref({
            responsive: true,
        })

        return {
            date,
            formData,
            errors,
            selectOptions,
            multiTest,
            multiUser,
            options,
            actionTiger,
            selectedDateRange,
            image,
            isDeleteModalActive,
            confirmed,
            isModalActive,
            closeModal,
            chartData,
            chartOptions,
        }
    },


}

</script>

