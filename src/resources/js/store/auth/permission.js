export default {
    namespaced: true,
    state: {
        permissions: {}
    },
    getters: {
        permissions: state => state.permissions
    },

    mutations: {
        SET_PERMISSIONS: (state, payload) => state.permissions = payload,
    },

}
