import Axios from "@services/axios";
import {MY_PROFILE} from "@services/endpoints";

export default {
    namespaced: true,
    state: {
        profileData: {}
    },
    getters: {
        profileData: state => state.profileData
    },
    actions: {
        getProfileData: ({commit}, loading = false) => {
            //commit('SET_LOADING', loading)
            return Axios.get(MY_PROFILE).then(res => {
                commit('SET_PROFILE_DATA', res.data)
                return res;
            }).catch((error) => console.log(error))
        },
    },
    mutations: {
        SET_PROFILE_DATA: (state, data) => state.profileData = data,
    },

}
