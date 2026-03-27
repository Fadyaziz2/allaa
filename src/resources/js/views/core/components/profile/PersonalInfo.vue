<template>
    <div class="mb-4">
        <app-input id="first_name"
                   type="text"
                   :label="$t('first_name')"
                   label-required
                   :placeholder="$t('first_name')"
                   v-model="formData.first_name"
                   :errors="$errors(errors, 'first_name')"/>
    </div>
    <div class="mb-4">
        <app-input id="last_name"
                   type="text"
                   :label="$t('last_name')"
                   label-required
                   :placeholder="$t('last_name')"
                   v-model="formData.last_name"
                   :errors="$errors(errors, 'last_name')"/>
    </div>
    <div class="mb-4">
        <app-input id="email_address"
                   type="email"
                   :label="$t('email_address')"
                   label-required
                   :placeholder="$t('email_address')"
                   v-model="formData.email"
                   :errors="$errors(errors, 'email')"/>
    </div>
    <template v-if="formData.user_profile">
        <div class="mb-4">
            <app-input id="phone_number"
                       type="phone-number"
                       :label="$t('phone_number')"
                       :placeholder="$t('phone_number')"
                       v-model="phoneDetails"
                       :selected-country="phoneDetails.phone_country"
                       :errors="$errors(errors, 'phone_number')"/>
        </div>

        <div class="mb-4">
            <app-input id="gender"
                       type="select"
                       :options="genderList"
                       :label="$t('gender')"
                       listValueField="name"
                       listKeyField="id"
                       v-model="formData.user_profile.gender"
                       :choose-label="$t('choose_a_gender')"
                       :errors="$errors(errors, 'gender')"/>
        </div>

        <div class="mb-4">
            <app-input id="address"
                       type="textarea"
                       :label="$t('address')"
                       :placeholder="$t('address')"
                       v-model="formData.user_profile.address"
                       :errors="$errors(errors, 'address')"/>
        </div>
    </template>

    <button type="button"
            class="btn btn-primary shadow"
            :disabled="preloader"
            @click.prevent="submit">
        <app-button-loader v-if="preloader"/>
        <i class="bi bi-download"></i>
        {{ $t('update') }}
    </button>


</template>

<script setup>
import {ref, computed, watch} from "vue"
import {useI18n} from 'vue-i18n';
import Axios from "@services/axios";
import {MY_PROFILE_UPDATE} from "@services/endpoints";
import {useToast} from "vue-toastification";
import store from "@store/index";

const props = defineProps({
    id: {}
})

const formData = ref({})
const phoneDetails = ref({
    phone_number: '',
    phone_country: 'BD',
})
const errors = ref({})
const preloader = ref(false)
const toast = useToast()
const submit = () => {
    preloader.value = true
    if (phoneDetails.value.phone_number) {
        formData.value.phone_number = phoneDetails.value.phone_number
        formData.value.phone_country = phoneDetails.value.phone_country

    }
    const customData = {
        ...formData.value,
        address: formData.value.user_profile.address,
        gender: formData.value.user_profile.gender,
    }

    Axios.post(MY_PROFILE_UPDATE, customData).then((response) => {
        toast.success(response.data.message);
        formData.value = {}
        errors.value = {}
        store.dispatch('user/getProfileData')
    }).catch(({response}) => {
        if (response.status === 422) {
            errors.value = response.data.errors;
        } else {
            toast.error(response.data.message);
        }
    }).finally(() => preloader.value = false)
}

const profileData = computed(() => store.getters['user/profileData'])
watch(profileData, (user) => {
    formData.value = {
        ...user,
        user_profile: {
            ...user.user_profile,
        }
    }
    if (user.user_profile?.phone_number) {
        phoneDetails.value = {
            phone_number: user.user_profile?.phone_number,
            phone_country: user.user_profile?.phone_country,
        }
    }

}, {immediate: true})
const {t} = useI18n();
const genderList = ref([
    {
        id: 'male',
        name: t('male')
    },
    {
        id: 'female',
        name: t('female')
    },
    {
        id: 'others',
        name: t('others')
    },
])
</script>

