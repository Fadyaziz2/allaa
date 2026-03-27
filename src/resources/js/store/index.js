import {createStore} from "vuex";
import user from "@store/user";
import install from "@store/install";
import setting from "@store/setting";
import notification from "@store/notification";
import permission from "@store/auth/permission";

export default createStore({
    state: {
        theme: {
            darkMode: false
        },
        settings: {
            dateFormat: "YYYY-MM-DD",
            timeFormat: 12
        },
        isPageLoaded: false,
        isAppInstalled: false
    },
    getters: {
        isPageLoaded: state => state.isPageLoaded,
        isAppInstalled: state => state.isAppInstalled
    },
    mutations: {
        SET_PAGE_LOADED: (state, data) => state.isPageLoaded = data
    },

    modules: {
        user,
        install,
        setting,
        permission,
        notification
    }
})
