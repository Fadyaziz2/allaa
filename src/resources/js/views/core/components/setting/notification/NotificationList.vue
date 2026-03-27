<template>
    <div class="content-wrapper">
        <app-breadcrumb :page-title="$t('notification_template')" />
        <div class="row">
            <div class="col-md-4">
                <app-input type="select" id="select"
                           :label-required="true"
                           :label="$t('select_notification')"
                           list-value-field="original_name"
                           :options="notificationTypeList" :choose-label="$t('choose_a_notification_type')"
                           v-model="formData.notification_type_id"
                           @selectInput="changeNotificationType(formData.notification_type_id)"
                />
            </div>
        </div>


        <app-loader v-if="preloader" />
        <template v-else>
            <app-tab v-if="notificationTemplate.length > 0" id="notification-tab" area-label="horizontal-flat"
                type="horizontal" :tabs="tabs" />
        </template>

    </div>
</template>

<script setup>
import { ref, markRaw, onMounted } from "vue"
import { useI18n } from 'vue-i18n';
import EmailNotifications from "@/core/components/setting/notification/types/EmailNotifications.vue";
import SystemNotification from "@/core/components/setting/notification/types/SystemNotification.vue";
import Axios from "@services/axios";
import { NOTIFICATION_TYPE, SELECTED_NOTIFICATION_TEMPLATE } from "@services/endpoints";

const { t } = useI18n();
const formData = ref({})
const notificationTemplate = ref({})
const tabs = ref([
    {
        title: t('email'),
        key: 'email_notification',
        component: markRaw(EmailNotifications),
        permission: true,
        props: null,
        type: 'mail'
    },

    {
        title: t('system'),
        key: 'system_setting',
        component: markRaw(SystemNotification),
        permission: false,
        props: null,
        type: 'database'
    }

])
const notificationTypeList = ref([])
const getNotificationType = () => {
    Axios.get(NOTIFICATION_TYPE).then(({ data }) => {
        notificationTypeList.value = data
    })
}

const preloader = ref(false)
const changeNotificationType = (notification_type_id) => {
    let notificationTypeId = notification_type_id == null || notification_type_id === '' ? 1 : notification_type_id
    preloader.value = true
    tabs.value.forEach(element => {
        element.permission = false;
        element.props = null
    });
    formData.value.notification_type_id = notificationTypeId;
    Axios.get(`${SELECTED_NOTIFICATION_TEMPLATE}/${notificationTypeId}`).then(({ data }) => {
        notificationTemplate.value = data
        notificationTemplate.value.find((item) => {
            tabs.value.forEach((element) => {
                if (element.type === item.type) {
                    element.props = item;
                    element.permission = true;
                }
            })
        })
    }).finally(() => preloader.value = false)
}

onMounted(() => {
    getNotificationType();
    changeNotificationType(1);
})

</script>




