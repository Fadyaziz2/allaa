<template>
    <div class="content-wrapper">
        <app-breadcrumb :page-title="$t('expense_import')"/>
        <div class="row mt-5 ">
            <div class="col-md-12">
                <div class="top-info">
                    <h5>The field labels marked with * are required input fields</h5>
                    <p class="m-0 mt-3">The correct column order is (title*, date*, amount*, category_name*, reference,
                        note) and you must follow this.</p>
                </div>
            </div>

            <div class="mb-4">
                <p>We would like to provide you a sample .CSV file <a href="" @click.prevent="sampleDownload">Download
                    Sample File</a></p>
                <app-input type="multi-image-uploader"
                           id="multi-image-upload-expense-modal"
                           :max-length="1"
                           :after-upload-success="afterUploadSuccess"
                           @changeFile="filesSelected"
                           :errors="$errors(errors, 'files')"/>
                <small class="text-danger" v-if="errors.missing_field">{{ errors.missing_field }}</small>
                <small class="text-danger" v-if="errors.missing_fields">{{ errors.missing_fields }}</small>
            </div>

            <div class="row mt-3">
                <div class="col-12 d-flex gap-3">
                    <button class="btn btn-primary"
                            @click.prevent="submit()">
                        <app-button-loader v-if="preloader"/>
                        {{ $t("submit") }}
                    </button>
                </div>
            </div>

            <div v-if="uploadResponse.stat">
                <div>
                    <CSVUploadStateItem
                        type="success"
                        :label="$t('successful_rows')"
                        :count="uploadResponse.stat?.success_count"
                        :amount="uploadResponse.stat?.success_rate"
                        :max-amount="100"
                    />
                    <CSVUploadStateItem
                        type="warning"
                        :label="$t('unsuccessful_rows')"
                        :count="uploadResponse.stat?.failed_count"
                        :amount="uploadResponse.stat?.failed_rate"
                        :max-amount="100"
                    />
                    <CSVUploadStateItem
                        type="danger"
                        :label="$t('errors_found')"
                        :count="uploadResponse.stat?.error_count"
                        :amount="uploadResponse.stat?.error_rate"
                        :max-amount="100"
                    />
                </div>
                <p class="my-1 text-gray-700 fw-semibold">
                    {{ $t("download") }}
                    <a :href="urlGenerator(uploadResponse.stat.path_to_file)">
                        import_expense.csv
                    </a>
                    {{ $t('and_after_fixing_the_errors_re_upload') }}
                </p>
            </div>
        </div>
    </div>
</template>
<script setup>
import {useI18n} from 'vue-i18n';
import {ref} from 'vue';
import Axios from "@services/axios";
import {useToast} from "vue-toastification";
import {urlGenerator} from "@utilities/urlGenerator";
import CSVUploadStateItem from "@/invoice/import/CsvUploadStateItem.vue";
import {EXPENSE_IMPORT, PRODUCT_IMPORT} from "@services/endpoints/invoice";

const toast = useToast();
const attachments = ref([]);
const uploadResponse = ref({});
const errors = ref({});
const filesSelected = (files) => {
    attachments.value = files;
};

const preloader = ref(false);
const afterUploadSuccess = ref(false);
const submit = () => {
    preloader.value = true;
    let formData = new FormData();
    errors.value = {};
    attachments.value.forEach(attachment => {
        formData.append('files', attachment);
    });

    Axios.post(EXPENSE_IMPORT, formData,
        {
            headers: {'Content-Type': 'multipart/form-data'}
        }).then(({data}) => {
        toast.success(data?.message);
        afterUploadSuccess.value = true;
        uploadResponse.value = data;
    }).catch(({response}) => {
        uploadResponse.value = response.data;
        if (response.status === 422) {
            errors.value = response?.data?.errors;
        } else {
            errors.value = {};
            toast.error(response?.data?.message);
        }
    }).finally(() => preloader.value = false);
}

const sampleFileType = ref([]);
const sampleDownload = () => {
    let commas = "";
    let keys = [
        "Title",
        "Date",
        "Amount",
        "Category Name",
        "Reference",
        "Note"
    ];

    if (sampleFileType.length) {
        keys = [];
        commas = ",".repeat(keys.slice(5).length);
    }

    downloadCSV(
        `${keys.join(",")}\n` +
        `Test expense,2024-01-01,500,Test category,reference,Test note${commas}\n` +
        `Test expense,2024-01-02,1000,Test category,reference,Test note${commas}\n` +
        `Test expense,2024-01-05,1500,Test category,reference,Test note${commas}\n`
    );
}

const downloadCSV = (csv) => {
    let e = document.createElement("a");
    e.href = "data:text/csv;charset=utf-8," + encodeURI(csv);
    e.target = "_blank";
    e.download = `import_expense_sample.csv`;
    e.click();
}

</script>
