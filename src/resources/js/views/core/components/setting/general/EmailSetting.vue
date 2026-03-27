<template>
    <app-loader class="mt-4" v-if="preloader"/>
    <form v-else>
        <div class="mb-4">
            <app-input
                type="select"
                id="provider"
                :label="$t('provider')"
                label-required
                :options="providerList"
                list-value-field="name"
                :choose-label="$t('choose_a_provider')"
                v-model="formData.provider"
                :errors="$errors(errors, 'provider')"
            />
        </div>

        <div class="mb-4">
            <app-input
                type="text"
                id="from_name"
                :label="$t('from_name')"
                label-required
                :placeholder="$t('from_name')"
                v-model="formData.from_name"
                :errors="$errors(errors, 'from_name')"
            />
        </div>
        <div class="mb-4">
            <app-input
                type="email"
                id="from_email"
                :label="$t('from_email')"
                label-required
                :placeholder="$t('from_email')"
                v-model="formData.from_email"
                :errors="$errors(errors, 'from_email')"
            />
        </div>

        <template v-if="formData.provider === 'smtp'">
            <div class="mb-4">
                <app-input
                    type="text"
                    id="host"
                    :label="$t('smtp_host')"
                    label-required
                    :placeholder="$t('smtp_host')"
                    v-model="formData.smtp_host"
                    :errors="$errors(errors, 'smtp_host')"
                />
            </div>
            <div class="mb-4">
                <app-input
                    type="text"
                    id="smtp_port"
                    :label="$t('smtp_port')"
                    label-required
                    :placeholder="$t('smtp_port')"
                    v-model="formData.smtp_port"
                    :errors="$errors(errors, 'smtp_port')"
                />
            </div>
            <div class="mb-4">
                <app-input
                    type="select"
                    id="encryption_type"
                    :label="$t('encryption_type')"
                    label-required
                    :options="encryptionTypeList"
                    list-value-field="name"
                    :choose-label="$t('encryption_type')"
                    v-model="formData.encryption_type"
                    :errors="$errors(errors, 'encryption_type')"
                />

            </div>
            <div class="mb-4">
                <app-input
                    type="text"
                    id="smtp_username"
                    :label="$t('smtp_username')"
                    label-required
                    :placeholder="$t('smtp_username')"
                    v-model="formData.smtp_username"
                    :errors="$errors(errors, 'smtp_username')"
                />
            </div>
            <div class="mb-4">
                <app-input
                    type="password"
                    id="email_password"
                    :label="$t('email_password')"
                    label-required
                    :placeholder="$t('email_password')"
                    v-model="formData.email_password"
                    :errors="$errors(errors, 'email_password')"
                />
            </div>


        </template>
        <div class="d-grid gap-2 d-md-flex mt-3">
            <button v-if="canAccess('update_email_setting')" type="button"
                    class="btn btn-primary"
                    :disabled="preloader"
                    @click.prevent="submit">
                <app-button-loader v-if="buttonLoader"/>
                <i class="bi bi-download"></i>
                {{ $t('update') }}
            </button>

            <button type="button" v-if="checkEmail" class="btn btn-primary-outline me-2 fw-bold"
                    @click.prevent="isModalActive = true">
                {{ $t('test_mail') }}
            </button>
        </div>

    </form>
    <test-mail-modal v-if="isModalActive"
                     modal-id="test-mail-modal"
                     @close="isModalActive = false"/>
</template>

<script setup>
import {ref, onMounted} from "vue"
import {useI18n} from 'vue-i18n';
import Axios from "@services/axios";
import {EMAIL_SETTINGS, EXIST_EMAIL_SETTINGS} from "@services/endpoints";
import {useToast} from "vue-toastification";
import TestMailModal from "@/core/components/setting/general/TestMailModal.vue"
import _ from 'lodash'

import usePermission from '@/core/global/composable/usePermission';

const {canAccess} = usePermission();

const props = defineProps({
    id: {}
})
const {t} = useI18n();
const formData = ref({})
const errors = ref({})
const preloader = ref(false)
const buttonLoader = ref(false)
const toast = useToast()
const submit = () => {
    buttonLoader.value = true
    Axios.post(EMAIL_SETTINGS, formData.value).then(({data}) => {
        toast.success(data.message);
        getEmailSetting()
        existEmailCheck()
    }).catch(({response}) => {
        if (response.status === 422) {
            errors.value = response.data.errors;
        }
    }).finally(() => buttonLoader.value = false)
}

const providerList = ref([
    {
        id: 'sendmail',
        name: t('sendmail')
    },
    {
        id: 'smtp',
        name: t('smtp')
    }
])

const encryptionTypeList = ref([
    {
        id: 'ssl',
        name: t('ssl')
    },
    {
        id: 'tls',
        name: t('tls')
    }
])

const getEmailSetting = () => {
    preloader.value = true
    Axios.get(EMAIL_SETTINGS).then(({data}) => {
        if (!_.isEmpty(data)) {
            formData.value = data
        }
    }).finally(() => preloader.value = false)
}

const isModalActive = ref(false)
const checkEmail = ref(null)
const existEmailCheck = () => {
    Axios.get(EXIST_EMAIL_SETTINGS).then((response) => {
        checkEmail.value = response.data
    })
}

onMounted(() => {
    getEmailSetting()
    existEmailCheck()
})

</script>

