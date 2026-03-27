<template>
    <li class="nav-item nav-notification dropdown">
        <a class="nav-link dropdown-toggle border-left"
           href="#"
           role="button"
           id="dropdownNotification"
           data-bs-toggle="dropdown" aria-expanded="false"
           aria-label="Show notifications">
            <div class="notify-icon">
                <i class="bi bi-bell"/>
                <span class="counter" v-if="notifications.length > 0">
                  {{ notifications.length }}
                </span>
            </div>
        </a>
        <div class="dropdown-menu dropdown-menu-end navbar-dropdown py-0 border custom-scrollbar"
             aria-labelledby="dropdownNotification">
            <div class="dropdown-item border-bottom d-flex align-items-center justify-content-between p-3">
                <a href="#" class="text-default pointer-events-none">
                    <h6 class="mb-0 ">{{ $t('notifications') }}</h6>
                </a>
                <a href="#" class="text-default" v-if="notifications.length > 0" @click.prevent="markAsRead">
                    <h6 class="mb-0 d-flex align-items-center">
                        <i class="bi bi-check2-circle fs-4 me-2"></i>
                        {{ $t('mark_as_read') }}
                    </h6>
                </a>
            </div>

            <div class="notification-wrapper custom-scrollbar">

                <!-- if here recent notification, this block will be here  -->
                <div class="notification-items" v-if="notifications.length > 0" v-for="notification in notifications">
                    <div class="notification-topper">
                        <div class="dot"></div>
                        <div class="notification-txt">
                            {{ notification.data.message }}
                        </div>
                    </div>
                    <div class="notification-date-time">
                        <span> {{ formatDateTimeToLocal(notification.created_at) }}</span>
                    </div>
                </div>

                <div v-else class="mark-all py-5">
                    <i class="bi bi-bell-fill   display-2"></i>
                    No new notification
                </div>

            </div>

            <div class="view-all border-top w-100 p-2 text-center px-0">
                <router-link :to="{name: 'AllNotification'}" class="text-muted ls-1">
                    <small>
                        {{$t('view_all_notification')}}
                    </small>
                </router-link>
            </div>
        </div>
    </li>
</template>

<script setup>
import {ref, computed, onMounted} from "vue"
import Axios from "@services/axios";
import {useToast} from "vue-toastification";
import {READ_ALL_NOTIFICATIONS} from "@services/endpoints";
import {formatDateTimeToLocal} from "@utilities/helpers";
import store from "@store/index";
import useEmitter from "@/core/global/composable/useEmitter";


const emitter = useEmitter()
const toast = useToast();

const notifications = computed(() => store.getters['notification/notificationList'])
const getNotification = () => {
    store.dispatch('notification/getNotificationData')
}

const markAsReadLoader = ref(false);
const markAsRead = () => {
    markAsReadLoader.value = true;
    Axios.patch(READ_ALL_NOTIFICATIONS).then(({data}) => {
        toast.success(data.message);
        getNotification();
        emitter.emit('reload-aLl-notification-table');
    }).catch(e => toast.error(e.response?.data?.message)).finally(() => markAsReadLoader.value = false);
}

onMounted(() => {
    getNotification()
})
</script>

<style scoped lang="scss">
.rtl {
    .navbar-top {
        .notification-wrapper {
            .notification-items {
                text-align: right;

                .dot {
                    margin-left: 10px;
                    margin-right: unset !important;
                }
            }
        }

        .view-all {
            padding-left: unset !important;
            padding-right: 25px;
            text-align: right;
        }
    }
}
</style>
