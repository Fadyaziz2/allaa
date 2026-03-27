<template>
    <app-loader class="mt-4" v-if="getPreloader"/>
    <form v-else>
        <div class="mb-3">
            <app-input
                type="select"
                id="time_zone"
                :label="$t('time_zone')"
                label-required
                list-value-field="name"
                :show-search="true"
                v-model="formData.time_zone"
                :options="timeZones"
                :selected-disable="false"
                :choose-label="$t('choose_a_time_zone')"
                :errors="$errors(errors, 'time_zone')"
            />
        </div>
        <div class="mb-3">
            <app-input
                type="select"
                id="date_format"
                :label="$t('date_format')"
                label-required
                list-value-field="name"
                v-model="formData.date_format"
                :options="dateFormatList"
                :selected-disable="false"
                :choose-label="$t('choose_a_date_format')"
                :errors="$errors(errors, 'date_format')"
            />
        </div>
        <div class="mb-3">
            <app-input
                type="select"
                id="language"
                :label="$t('language')"
                list-value-field="name"
                label-required
                v-model="formData.language"
                :options="languageList"
                :selected-disable="false"
                :choose-label="$t('choose_a_language')"
                :errors="$errors(errors, 'language')"
            />
        </div>
        <div class="mb-3">
            <app-input
                type="text"
                id="currency_symbol"
                :label="$t('currency_and_symbol')"
                label-required
                v-model="formData.currency_symbol"
                :placeholder="$t('currency_and_symbol')"
                :errors="$errors(errors, 'currency_symbol')"/>

            <app-note class="mt-2" :message="$t('pdf_will_not_support_all_currency_symbols')"/>
        </div>

        <div class="mb-3">
            <input-label
                label-id="decimal_separator"
                :label="$t('decimal_separator')"
                :required="true"
            />
            <div>
                <app-input
                    type="radio"
                    id="decimal_separator"
                    radio-checkbox-name="decimal_separator"
                    @changeRadio="changeValue('decimal_separator')"
                    list-value-field="name"
                    v-model="formData.decimal_separator"
                    :options="decimalSeparatorList"/>
            </div>
        </div>
        <div class="mb-3">
            <input-label
                label-id="thousand_separator"
                :label="$t('thousand_separator')"
                :required="true"/>
            <div>
                <app-input
                    type="radio"
                    id="thousand_separator"
                    radio-checkbox-name="thousand_separator"
                    @changeRadio="changeValue('thousand_separator')"
                    list-value-field="name"
                    v-model="formData.thousand_separator"
                    :options="thousandSeparatorList"/>
            </div>
        </div>
        <div class="mb-3">
            <input-label
                label-id="number_of_decimal"
                :label="$t('number_of_decimal')"
                :required="true"/>
            <div>
                <app-input
                    type="radio"
                    id="number_of_decimal"
                    radio-checkbox-name="number_of_decimal"
                    list-value-field="name"
                    v-model="formData.number_of_decimal"
                    :options="numberOfDecimalList"
                />
            </div>
        </div>
        <div class="mb-3">
            <input-label
                label-id="number_of_decimal"
                :label="$t('currency_position')"
                :required="true"/>
            <div>
                <app-input
                    type="radio"
                    id="currency_position"
                    radio-checkbox-name="currency_position"
                    list-value-field="name"
                    v-model="formData.currency_position"
                    :options="currencyPositionList"
                />
            </div>
        </div>

        <button type="button"
                v-if="canAccess('update_setting')"
                class="btn btn-primary shadow mt-3"
                :disabled="preloader"
                @click.prevent="submit">
            <app-button-loader v-if="preloader"/>
            <i class="bi bi-download"></i>
            {{ $t('update') }}
        </button>

    </form>
</template>

<script setup>
import {ref, onMounted} from "vue"
import Axios from "@services/axios";
import {GENERAL_SETTING, SETTING} from "@services/endpoints";
import InputLabel from "@/core/global/input/label/InputLabel.vue";
import {useToast} from "vue-toastification";
import {loadLanguageAsync} from '@i18n/index';
import usePermission from '@/core/global/composable/usePermission';

const props = defineProps({
    id: {}
})

const {canAccess} = usePermission();
const formData = ref({})
const preloader = ref(false)
const toast = useToast()
const errors = ref({})
const defaultLang = localStorage.getItem("defaultLang");
const locale = ref(defaultLang);

const submit = async () => {
    preloader.value = true
    Axios.post(SETTING, formData.value).then(async ({data}) => {
        toast.success(data.message);
        getSetting();
        location.reload();
        // if (locale.value !== formData.value.language) {
        //     locale.value = formData.value.language;
        //     await loadLanguageAsync(formData.value.language);
        //     location.reload(); //Reload window if needed
        // }

    }).catch(({response}) => {
        if (response.status === 422) {
            errors.value = response.data.errors
        } else {
            errors.value = {};
            toast.error(response.data.message);
        }
    }).finally(() => preloader.value = false)
}

const timeZones = ref([])
const dateFormatList = ref([])
const languageList = ref([
    {
        id: 'en',
        name: 'English'
    },
    {
        id: 'fr',
        name: 'French'
    },
    {
        id: 'sp',
        name: 'Spanish'
    },
    {
        id: 'tr',
        name: 'Portugal'
    }
])
const decimalSeparatorList = ref([])
const thousandSeparatorList = ref([])
const numberOfDecimalList = ref([])
const currencyPositionList = ref([])
const changeValue = (type) => {
    if (type === 'thousand_separator') {
        if (formData.value.thousand_separator === ',') {
            formData.value.decimal_separator = '.'
        } else if (formData.value.thousand_separator === '.') {
            formData.value.decimal_separator = ','
        }
    } else {
        formData.value.thousand_separator = formData.value.decimal_separator === ',' ? '.' : ','
    }
}
const getPreloader = ref(false)

const getSetting = () => {
    getPreloader.value = true;
    Axios.get(SETTING).then(({data}) => {
        formData.value = data
    }).finally(() => getPreloader.value = false);
}
const getGeneralSetting = () => {
    getPreloader.value = true
    Axios.get(GENERAL_SETTING).then(({data}) => {
        timeZones.value = data.time_zones;
        dateFormatList.value = data.date_format;
        decimalSeparatorList.value = data.decimal_separator;
        thousandSeparatorList.value = data.thousand_separator;
        numberOfDecimalList.value = data.number_of_decimal;
        currencyPositionList.value = data.currency_position;
    }).finally(() => getPreloader.value = false)

}
onMounted(() => {
    getGeneralSetting()
    getSetting()
})

</script>

