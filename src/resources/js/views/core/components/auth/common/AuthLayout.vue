<template>
    <div class="auth-page-wrapper flex">
        <div class="left-content">
            <div class="auth-form">
                <div class="brand">
                    <img
                        :src="settingInfo && settingInfo.company_logo ?  urlGenerator(settingInfo.company_logo) : '/assets/images/logo.png'"
                        class="mb-4 height-60 w-auto" alt="App logo">
                </div>
                <slot name="auth-content"></slot>
            </div>
        </div>

        <div class="right-content" :style="'background-image: url('+ urlGenerator(companyBanner) +')'"></div>


    </div>
</template>

<script setup>
import {ref, onMounted, computed} from "vue"
import store from "@store";
import {urlGenerator} from "@utilities/urlGenerator";

const settingInfo = computed(() => store.getters["setting/setting"])
const companyBanner = computed(() => settingInfo.value?.company_banner || 'assets/images/brand.png')

const darkMode = ref(false)
onMounted(() => {
    let htmlElement = document.documentElement,
        theme = localStorage.getItem('theme')
    // Check for active theme
    if (theme === 'dark') {
        htmlElement.setAttribute('theme', 'dark');
        darkMode.value = true;
        store.state.theme.darkMode = true;
    } else {
        htmlElement.setAttribute('theme', 'light');
        darkMode.value = false;
        store.state.theme.darkMode = false;
    }
})

</script>
