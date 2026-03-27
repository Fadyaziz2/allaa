import {urlGenerator} from "@utilities/urlGenerator";

export default {
    namespaced: true,
    state: {
        installData: {}
    },
    getters: {
        installData: state => state.installData
    },
    actions: {
        checkInstall: ({commit}) => {
            axios.get(urlGenerator(`api/check-install`)).then((response) => {
                console.log(response)
               commit('CHECK_INSTALL_DATA', response)
            })
        }
    },
    mutations: {
        CHECK_INSTALL_DATA: (state, data) => state.installData = data,
    }

}
