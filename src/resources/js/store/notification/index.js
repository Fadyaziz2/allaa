import Axios from "@services/axios";
import {MY_PROFILE, NOTIFICATIONS} from "@services/endpoints";

export default {
    namespaced: true,
    state: {
        notificationList: {}
    },
    getters: {
        notificationList: state => state.notificationList
    },
    actions: {
        getNotificationData: ({commit}, loading = false) => {
            return Axios.get(NOTIFICATIONS, {
                params: {
                    unread: true,
                }
            }).then(res => {
                commit('SET_NOTIFICATION_DATA', res.data.data)
                return res;
            }).catch((error) => console.log(error))
        },
    },
    mutations: {
        SET_NOTIFICATION_DATA: (state, data) => state.notificationList = data,
    },

}
