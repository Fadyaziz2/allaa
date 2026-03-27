export default {
    namespaced: true,
    state: {
        pageLoaded: false,
        setting: {},
        sidebarStatus: 'open',
    },
    getters: {
        pageLoaded: state => state.pageLoaded,
        setting: state => state.setting,
        sidebarStatus: state => state.sidebarStatus,
    },
    mutations: {
        SET_PAGE_LOADED: (state, payloads) => state.pageLoaded = payloads,
        SET_SETTING: (state, payloads) => state.setting = payloads,
        SET_SIDEBARSTATUS: (state, payloads) => state.sidebarStatus = payloads,
    }

}
