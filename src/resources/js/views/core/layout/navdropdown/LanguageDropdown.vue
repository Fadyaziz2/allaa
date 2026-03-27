<template>
    <li class="nav-item nav-language dropdown py-0">
        <a
            class="nav-link dropdown-toggle d-flex justify-content-center align-items-center"
            href="#"
            id="dropdownLanguage"
            data-bs-toggle="dropdown"
            aria-expanded="false"
            aria-label="Change Language">
            <i
                class="bi bi-globe me-sm-2 d-inline-flex justify-content-center align-items-center"
            ></i>
            <span class="me-sm-2 language-text text-uppercase">{{
                locale
            }}</span>
            <i
                class="d-none d-sm-block bi bi-chevron-down d-inline-flex justify-content-center align-items-center mx-1 fs-12"
            ></i>
        </a>
        <div
            class="dropdown-menu dropdown-menu-end navbar-dropdown custom-scrollbar"
            aria-labelledby="ChangeLanguage"
        >
            <a
                class="dropdown-item d-flex align-items-center py-1"
                v-for="item in language"
                href=""
                @click.prevent="changeLang(item.key)"
            >
                <span class="ms-3 d-inline-block">
                    {{ item.title }}
                </span>
            </a>
        </div>
    </li>
</template>
<script setup>
import { ref } from "vue";
import { loadLanguageAsync } from "@i18n/index";

const props = defineProps({
    language: Array,
});

const defaultLang = localStorage.getItem("defaultLang");
const locale = ref(defaultLang ? defaultLang : "EN");
const changeLang = (lang) => {
    locale.value = lang;
    loadLanguageAsync(lang);
    location.reload(); //Reload window if needed
};
</script>
