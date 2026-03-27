<template>
    <app-modal
        :modal-id="modalId"
        :title="selectedUrl ? $t('update_customer') : $t('add_customer')"
        modal-size="large"
        :preloader="preloader"
        @submit="submit"
        @close="closeModal"
    >
        <template v-slot:body>
            <app-loader v-if="pageLoader"></app-loader>
            <form v-else>
                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-4">
                            <app-input
                                type="text"
                                id="first_name"
                                :label="$t('first_name')"
                                label-required
                                :placeholder="$t('first_name')"
                                v-model="formData.first_name"
                                :errors="$errors(errors, 'first_name')"
                            />
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="mb-4">
                            <app-input
                                type="text"
                                id="last_name"
                                :label="$t('last_name')"
                                label-required
                                :placeholder="$t('last_name')"
                                v-model="formData.last_name"
                                :errors="$errors(errors, 'last_name')"
                            />
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="mb-4">
                            <app-input
                                type="email"
                                id="email"
                                :label="$t('email')"
                                label-required
                                :placeholder="$t('email')"
                                v-model="formData.email"
                                :errors="$errors(errors, 'email')"
                            />
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-4">
                            <app-input
                                id="phone_number"
                                type="phone-number"
                                :label="$t('phone_number')"
                                :placeholder="$t('phone_number')"
                                v-model="phoneDetails"
                                :selected-country="phoneDetails.phone_country"
                                :errors="$errors(errors, 'phone_number')"
                            />
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-4">
                            <app-input
                                type="text"
                                id="tax_no"
                                :label="$t('tax_no')"
                                :placeholder="$t('tax_no')"
                                v-model="formData.tax_no"
                                :errors="$errors(errors, 'tax_no')"
                            />
                        </div>
                    </div>

                    <div class="col-md-6" v-if="!selectedUrl">
                        <div class="mb-4 mt-2">
                            <label class="mb-2">{{ t("portal_access") }}</label>
                            <div class="d-flex align-items-start">
                                <app-input
                                    type="checkbox"
                                    id="portal_access"
                                    :label="$t('')"
                                    v-model="formData.portal_access"
                                    :checked="portalAccessChecked"
                                    :options="[{ id: 1 }]"
                                    :errors="$errors(errors, 'portal_access')"
                                />
                                <span>{{
                                    $t(
                                        "allow_this_customer_to_login_to_the_customer_portal"
                                    )
                                }}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <h4 class="mb-4">{{ $t("billing_address") }}</h4>
                    <div class="mb-2"></div>
                    <div class="col-md-6">
                        <div class="mb-4">
                            <app-input
                                type="text"
                                id="name"
                                :label="$t('name')"
                                :placeholder="$t('name')"
                                v-model="formData.name"
                                :errors="$errors(errors, 'name')"
                            />
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="mb-4">
                            <app-input
                                type="number"
                                id="phone"
                                :label="$t('phone')"
                                :placeholder="$t('phone')"
                                v-model="formData.phone"
                                :errors="$errors(errors, 'phone')"
                            />
                        </div>
                    </div>
                    <div class="col-md-12">
                        <div class="mb-4">
                            <app-input
                                type="text"
                                id="address"
                                :label="$t('address')"
                                :placeholder="$t('address')"
                                v-model="formData.address"
                                :errors="$errors(errors, 'address')"
                            />
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-4">
                            <app-input
                                type="select"
                                id="country"
                                :label="$t('country')"
                                :show-search="true"
                                :options="countryList"
                                list-key-field="id"
                                list-value-field="name"
                                :choose-label="$t('choose_a_country')"
                                v-model="formData.country_id"
                                :errors="$errors(errors, 'country_id')"
                            />
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-4">
                            <app-input
                                type="text"
                                id="state"
                                :label="$t('state')"
                                :placeholder="$t('state')"
                                v-model="formData.state"
                                :errors="$errors(errors, 'state')"
                            />
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="mb-4">
                            <app-input
                                type="text"
                                id="city"
                                :label="$t('city')"
                                :placeholder="$t('city')"
                                v-model="formData.city"
                                :errors="$errors(errors, 'city')"
                            />
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="mb-4">
                            <app-input
                                type="text"
                                id="zip_code"
                                :label="$t('zip_code')"
                                :placeholder="$t('zip_code')"
                                v-model="formData.zip_code"
                                :errors="$errors(errors, 'zip_code')"
                            />
                        </div>
                    </div>
                </div>
            </form>
        </template>
    </app-modal>
</template>

<script setup>
import { computed, onMounted, ref } from "vue";
import { useSubmitForm } from "@/core/global/composable/modal/useSubmitForm";
import { CUSTOMERS, SELECTED_COUNTRY } from "@services/endpoints/invoice";
import Axios from "@services/axios";
import { useI18n } from "vue-i18n";

const { t } = useI18n();

const props = defineProps({
    modalId: String,
    tableId: String,
    selectedUrl: String,
});
const emit = defineEmits(["close"]);
const phoneDetails = ref({
    phone_number: "",
    phone_country: "BD",
});
const { preloader, pageLoader, formData, errors, save, closeModal } =
    useSubmitForm(props, emit, "no");
const submit = () => {
    if (phoneDetails.value.phone_number) {
        formData.value.phone_number = phoneDetails.value.phone_number;
        formData.value.phone_country = phoneDetails.value.phone_country;
    }
    save(props.selectedUrl ? props.selectedUrl : CUSTOMERS, formData.value);
};
const getEditData = () => {
    pageLoader.value = true;
    Axios.get(props.selectedUrl)
        .then(({ data }) => {
            formData.value = data;
            if (data.billing_address) {
                let billingAddress = data.billing_address;
                formData.value.country_id = billingAddress.country_id;
                formData.value.name = billingAddress.name;
                formData.value.state = billingAddress.state;
                formData.value.city = billingAddress.city;
                formData.value.zip_code = billingAddress.zip_code;
                formData.value.address = billingAddress.address;
                formData.value.phone = billingAddress.phone;
            }
            if (data.user_profile) {
                let userProfile = data.user_profile;
                if (userProfile.phone_number) {
                    phoneDetails.value.phone_number = userProfile.phone_number;
                    phoneDetails.value.phone_country =
                        userProfile.phone_country;
                }
                formData.value.tax_no = userProfile.tax_no;
                formData.value.portal_access =
                    userProfile.portal_access == 1
                        ? [userProfile.portal_access]
                        : [];
            }
        })
        .finally(() => (pageLoader.value = false));
};

const portalAccessChecked = computed(() => formData.value.portal_access > 0);
const countryList = ref([]);
const getCountry = () => {
    Axios.get(SELECTED_COUNTRY).then(({ data }) => {
        countryList.value = data;
    });
};
onMounted(() => {
    getCountry();
    if (props.selectedUrl) {
        getEditData();
    }
});
</script>
