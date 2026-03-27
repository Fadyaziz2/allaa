import {createRouter, createWebHistory} from "vue-router";
import AppRoutes from "@router/AppRoutes";
import {LOCALES, PUBLIC_SETTING} from "@services/endpoints";
import {loadedLanguages, i18n, setI18nLanguage} from "@i18n";
import {urlGenerator} from "@utilities/urlGenerator";
import store from "@store";
import {getToken} from "@utilities/token";
import usePermission from "@/core/global/composable/usePermission";
import CoreRoutes from "@router/CoreRoutes";

const {storePermissions} = usePermission();

let routes = [...CoreRoutes, ...AppRoutes];

const router = createRouter({
    history: createWebHistory(),
    linkActiveClass: "active",
    routes,
});

router.beforeEach(async (to, from, next) => {
    let lang = "en";
    if (store.getters["setting/pageLoaded"] === false) {
        const token = getToken();
        await axios
            .get(urlGenerator(PUBLIC_SETTING), {
                headers: {
                    Authorization: `Bearer ${token}`,
                },
            })
            .then(({data}) => {
                store.commit("setting/SET_SETTING", data);
                lang = data.language;
                if (data.permissions) {
                    storePermissions(data.permissions);
                } else {
                    storePermissions({});
                }
            })
            .finally(() => store.commit("setting/SET_PAGE_LOADED", true));
    }
    if (to.meta?.hasPermission && to.meta?.hasPermission() === false) {
        const token = getToken();
        if (token) {
            next({name: "403"});
            return;
        }
        next({name: "login"});
        return;

    }

    const locale =
        localStorage.getItem("defaultLang") != null
            ? localStorage.getItem("defaultLang")
            : lang;
    const url = `${LOCALES}/${locale}`;
    if (loadedLanguages.includes(locale)) {
        setI18nLanguage(locale);
        return next();
    }
    await axios.get(urlGenerator(url)).then(({data}) => {
        i18n.global.setLocaleMessage(locale, data.languages);
    });
    setI18nLanguage(locale);
    return next();
});

export default router;
