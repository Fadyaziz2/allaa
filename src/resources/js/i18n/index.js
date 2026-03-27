import { nextTick } from 'vue'
import { createI18n } from "vue-i18n";
import axios from 'axios';
import { LOCALES } from '@services/endpoints';

//Vue i18n
export const loadedLanguages = Array();
export const i18n = createI18n({
  legacy: false, // you must set `false`, to use Composition API
  locale: 'en', // you must set `false`, to use Composition API
});

export function setI18nLanguage(lang) {
  if (i18n.mode === "legacy") {
    i18n.global.locale = lang;
  } else {
    i18n.global.locale.value = lang;
  }
  loadedLanguages.push(lang);
  document.querySelector("html").setAttribute("lang", lang);
  localStorage.setItem('defaultLang', lang);
  const html = document.querySelector("html");
  lang === "ar" ? html.setAttribute("dir", "rtl") : html.setAttribute("dir", "ltr");
  return lang;
}

export async function loadLanguageAsync(lang) {
  // If the same language
  if (i18n.global.locale.value === lang) {
    return Promise.resolve(setI18nLanguage(lang));
  }

  // If the language was already loaded
  if (loadedLanguages.includes(lang)) {
    return Promise.resolve(setI18nLanguage(lang));
  }

  const url = `${LOCALES}/${lang}`;
  axios.get(url).then(res =>{
    i18n.global.setLocaleMessage(lang, res.data.languages);
  })

  loadedLanguages.push(lang);
  setI18nLanguage(lang);
  return nextTick()
}
