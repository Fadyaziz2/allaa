import {nextTick} from 'vue'
import {createI18n} from 'vue-i18n'

export const i18n = createI18n({
    legacy: false,
    locale: 'en',
    messages: {
        en: {
            welcome_to_dashboard: 'Welcome to Dashboard',
            core: 'Welcome to Invoice Assistant',
            name: 'User Name'
        },
    },
});

export function setI18nLanguage(i18n, locale) {
    if (i18n.mode === 'legacy') {
        i18n.global.locale = locazle
    } else {
        i18n.global.locale.value = locale
    }
    /**
     * NOTE:
     * If you need to specify the language setting for headers, such as the `fetch` API, set it here.
     * The following is an example for axios.
     *
     * axios.defaults.headers.common['Accept-Language'] = locale
     */
    document.querySelector('html').setAttribute('lang', locale)
}

export async function loadLocaleMessages(i18n, locale) {
    return nextTick()
}
