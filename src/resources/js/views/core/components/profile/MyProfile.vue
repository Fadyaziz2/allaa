<template>
    <div class="content-wrapper">
        <app-breadcrumb :page-title="$t('profile')" />

        <app-tab id="profile-tab" :tabs="tabs">
            <div class="user-avatar-wrapper mb-4">
                <div class="user-avatar-info my-2 d-flex justify-content-center flex-column align-items-center">
                    <app-input type="image-uploader" id="isProfilePicture"  ref="profileImageUploader" :generate-file-url="false"
                        :label="$t('change_picture')" v-model="profile_picture" @changeFile="updateProfilePicture" />

                    <div class="mt-4">
                        <p class="mb-0 fw-bold fs-16">{{ loggedInUser.full_name }}</p>
                        <span class="text-muted" v-if="loggedInUser.roles">{{ loggedInUser.roles[0].name }}</span>
                    </div>
                </div>
            </div>
        </app-tab>

    </div>
</template>

<script>
import { ref, computed, watch, markRaw } from "vue"
import store from "@store/index";
import { urlGenerator } from "@utilities/urlGenerator";
import { UPDATE_PROFILE_PICTURE } from "@services/endpoints";
import Axios from "@services/axios";
import { useToast } from "vue-toastification";
import PersonalInfo from "@/core/components/profile/PersonalInfo.vue";
import PasswordChange from "@/core/components/profile/PasswordChange.vue";
import { useI18n } from 'vue-i18n';

export default {
    name: "MyProfile",
    setup() {
        const profileData = computed(() => store.getters['user/profileData'])
        const loggedInUser = ref({})
        const profileImageUploader = ref()

        const profile_picture = ref('')

        watch(profileData, (user) => {
            loggedInUser.value = user
            profile_picture.value = user.profile_picture ? urlGenerator(user.profile_picture.path) : urlGenerator('assets/images/avatar.svg')
        }, { immediate: true })

        const toast = useToast()
        const updateProfilePicture = (file) => {
            let data = new FormData();
            data.append('profile_picture', file);
            Axios.post(UPDATE_PROFILE_PICTURE, data, {
                headers: {
                    "Content-Type": "multipart/form-data",
                },
                onUploadProgress: function(progressEvent) {
                    profileImageUploader.value.imageUploader.uploadProgress = Math.round( (progressEvent.loaded * 100) / progressEvent.total );
                }
            }).then((response) => {
                toast.success(response.data.message);
                store.dispatch('user/getProfileData')
            }).catch(({response}) => {
                toast.error(response?.data?.message);
            })
        }
        const { t } = useI18n();
        const tabs = ref([
            {
                title: t('personal_info'),
                key: 'personal_info',
                component: markRaw(PersonalInfo)
            },
            {
                title: t('password_change'),
                key: 'password_change',
                component: markRaw(PasswordChange)
            },
        ])

        return { profile_picture, loggedInUser, updateProfilePicture, profileData, tabs, profileImageUploader }
    }
}
</script>
<style lang="scss">
.fs-16 {
  font-size: 16px;
}
</style>

