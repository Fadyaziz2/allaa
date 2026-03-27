<template>
    <app-modal :modal-id="modalId"
               :title="$t('manage_users')"
               modal-size="large"
               :premoader="preloader"
               :permission="canAccess('attach_user_role')"
               @submit="submit"
               @close="closeModal">

        <template v-slot:body>
            <app-loader v-if="preloader"/>
            <div v-else class="d-flex align-items-center justify-content-between pb-3 mb-3"
                 v-for="(user, index) in manageUser.users">
                <div class="d-flex align-items-center">
                    <div class="profile-avatar">
                        <avatar :image="profilePicture(user)"
                                :name="user.full_name"
                                :active="user?.status?.class"/>
                    </div>
                    <div class="media m-2">
                        {{ user.full_name }}
                        <div class="email">
                            {{ user.email }}
                        </div>
                    </div>
                </div>

                <div class="delete" v-if="!(user.is_admin) && canAccess('detach_user_role')">
                    <a href="" @click.prevent="detachUserRole(user, index)"><i class="bi bi-trash fs-4 text-danger"></i></a>
                </div>
            </div>
            <div class="mb-4" v-if="canAccess('attach_user_role')">
                <app-input type="advance-multi-select"
                           id="manage-role-users"
                           listValueField="full_name"
                           list-key-field="id"
                           v-model="users"
                           :loading-length="10"
                           :fetch-url="`${ROLE_WITHOUT_USER}?existing=${existUsers}`"
                           :choose-label="$t('choose_a_user')"
                />
            </div>
        </template>

    </app-modal>
</template>

<script setup>
import {ref, computed, watch} from "vue"
import {Modal} from "bootstrap";
import Avatar from "@/core/global/avatar/Avatar.vue";
import {urlGenerator} from "@utilities/urlGenerator";
import Axios from "@services/axios";
import {ATTACH_ROLE_USER, DETACH_ROLE_USER, ROLE_WITHOUT_USER} from "@services/endpoints";
import useEmitter from "@/core/global/composable/useEmitter";
import {useToast} from "vue-toastification";
import {useI18n} from 'vue-i18n';
import store from "@store/index";
import usePermission from '@/core/global/composable/usePermission';

const { canAccess } = usePermission();
const props = defineProps({
    modalId: {},
    tableId: {},
    manageUser: {}
})
const emit = defineEmits(['close'])
const toast = useToast()
const emitter = useEmitter()
const {t} = useI18n();

const users = ref([])
const preloader = ref(false)
const submit = () => {
    preloader.value = true
    Axios.post(`${ATTACH_ROLE_USER}/${props.manageUser.id}`, {
        'users': users.value
    }).then(({data}) => {
        emitter.emit('reload-' + props.tableId);
        toast.success(data?.message);
        closeModal()
    }).catch(({response}) => {
        toast.error(response?.data?.message);
    }).finally(() => preloader.value = false)
}
const profilePicture = (user) => {
    if (user.profile_picture) {
        return urlGenerator(user.profile_picture.path)
    }
}

const existUsers = ref([])
watch((props.manageUser), (item) => {
    existUsers.value = item.users ? item.users.map((el) => el.id) : []
}, {immediate: true})
const profileData = computed(() => store.getters['user/profileData'])

const detachUserRole = (user, index) => {
    if (user.is_admin) {
        toast.error(t('supper_admin_user_can_not_downgrade'));
        return
    }
    if (user.id == profileData.value.id) {
        toast.error(t('can_not_delete_own_account_role'));
        return
    }
    props.manageUser.users.splice(index, 1);
    Axios.patch(`${DETACH_ROLE_USER}/${user.id}`).then(({data}) => {
        toast.success(data?.message);
        emitter.emit('reload-' + props.tableId);
    }).catch(({response}) => {
        toast.error(response?.data?.message);
    })

}

const closeModal = () => {
    let modal = Modal.getInstance(document.getElementById(props.modalId))
    modal.hide()
    emit('close')
}
</script>


