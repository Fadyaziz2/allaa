<template>
    <nav class="navbar navbar-top px-md-20px" id="navbar-top">
        <div class="navbar-menu-wrapper">
            <div class="navbar-left-items gap-2">
                <ul class="navbar-nav">
                    <li
                        v-if="!isPosPage"
                        class="nav-item d-none d-lg-block sidebar-toggle-button"
                    >
                        <button
                            id="sidebar-toggle-button"
                            aria-label="Toggle Sidebar"
                            v-if="sidebarStatus === 'open'"
                            class="nav-link"
                            @click.prevent="toggleSidebar('open')"
                        >
                            <i class="bi bi-list" aria-hidden="true"></i>
                        </button>
                        <button
                            id="sidebar-toggle-button"
                            aria-label="Toggle Sidebar"
                            v-else
                            class="nav-link"
                            @click.prevent="toggleSidebar('collapse')"
                        >
                            <i class="bi bi-sliders" aria-hidden="true"></i>
                        </button>
                    </li>
                    <li
                        class="nav-item d-block"
                        :class="{ 'd-lg-none': !isPosPage }"
                    >
                        <a
                            href="#"
                            class="nav-link"
                            @click.prevent="sidebarOffCanvas"
                            area-label="Toggle Sidebar"
                        >
                            <i class="bi bi-justify-left fs-1 mx-1 lh-1" />
                        </a>
                    </li>
                </ul>
                <router-link
                    :to="{ name: 'dashboard' }"
                    class="navbar-primary d-block"
                    :class="{ 'd-lg-none': !isPosPage }"
                >
                    <img
                        :src="
                            settingInfo && settingInfo.company_logo
                                ? urlGenerator(settingInfo.company_icon)
                                : '/assets/images/favicon.svg'
                        "
                        alt="brand-icon"
                    />
                </router-link>
            </div>
            <div class="navbar-right-items">
                <ul class="navbar-nav gap-2">
                    <li
                        class="nav-item px-2 dropdown"
                        v-if="
                            canAccess('create_customers') ||
                            canAccess('create_products') ||
                            canAccess('create_invoices') ||
                            canAccess('create_estimates')
                        "
                    >
                        <a
                            href="#"
                            class="nav-link dropdown-toggle"
                            role="button"
                            id="shortcutDropdown"
                            data-bs-toggle="dropdown"
                            aria-expanded="false"
                            aria-label="Shortcut Dropdown"
                        >
                            <i class="bi bi-plus-square"></i>
                        </a>
                        <ShortcutDropdown></ShortcutDropdown>
                    </li>
                    <li class="nav-item px-2">
                        <a
                            href="#"
                            class="nav-link"
                            @click.prevent="toggleDarkMode"
                            aria-label="Dark Mode"
                        >
                            <i v-if="darkMode" class="bi bi-cloud-sun" />
                            <i v-else class="bi bi-cloud-moon" />
                        </a>
                    </li>
                    <li class="nav-item fullscreen-icon px-2">
                        <a
                            href="#"
                            class="nav-link"
                            @click.prevent="fullscreen"
                            aria-label="Fullscreen"
                        >
                            <i class="bi bi-fullscreen" />
                        </a>
                    </li>

                    <notification-dropdown
                        v-if="canAccess('manage_global_access')"
                        class="px-2"
                    />
                    <language-dropdown
                        :language="languageList"
                        class="px-2 px-sm-3"
                    />
                    <profile-dropdown :profile-data="profileData" />
                </ul>
            </div>
        </div>
    </nav>
</template>

<script setup>
import LanguageDropdown from "@/core/layout/navdropdown/LanguageDropdown.vue";
import NotificationDropdown from "@/core/layout/navdropdown/NotificationDropdown.vue";
import ShortcutDropdown from "@/core/layout/navdropdown/ShortcutDropdown.vue";
import ProfileDropdown from "@/core/layout/navdropdown/ProfileDropdown.vue";
import { ref, watch, onMounted, computed, onBeforeMount } from "vue";
import store from "@store/index";
import { urlGenerator } from "@utilities/urlGenerator";
import usePermission from "@/core/global/composable/usePermission";

const { canAccess } = usePermission();

const props = defineProps({
    profileData: {},
});
const languageList = [
    {
        title: "English",
        key: "en",
    },
    {
        title: "French",
        key: "fr",
    },
    {
        title: "Spanish",
        key: "sp",
    },
    {
        title: "Portugal",
        key: "pt",
    },
];

const sidebarStatus = ref("open");
const fullscreen = () => {
    if (
        (document.fullScreenElement !== undefined &&
            document.fullScreenElement === null) ||
        (document.msFullscreenElement !== undefined &&
            document.msFullscreenElement === null) ||
        (document.mozFullScreen !== undefined && !document.mozFullScreen) ||
        (document.webkitIsFullScreen !== undefined &&
            !document.webkitIsFullScreen)
    ) {
        if (document.documentElement.requestFullScreen) {
            document.documentElement.requestFullScreen();
        } else if (document.documentElement.mozRequestFullScreen) {
            document.documentElement.mozRequestFullScreen();
        } else if (document.documentElement.webkitRequestFullScreen) {
            document.documentElement.webkitRequestFullScreen(
                Element.ALLOW_KEYBOARD_INPUT
            );
        } else if (document.documentElement.msRequestFullscreen) {
            document.documentElement.msRequestFullscreen();
        }
    } else {
        if (document.cancelFullScreen) {
            document.cancelFullScreen();
        } else if (document.mozCancelFullScreen) {
            document.mozCancelFullScreen();
        } else if (document.webkitCancelFullScreen) {
            document.webkitCancelFullScreen();
        } else if (document.msExitFullscreen) {
            document.msExitFullscreen();
        }
    }
};
const isPosPage = ref(false);
const toggleSidebar = (status) => {
        if (status === "open") {
            sidebarStatus.value = "collapsed";
            document.querySelector("body").classList.add("sidebar-icon-only");
        } else {
            sidebarStatus.value = "open";
            document
                .querySelector("body")
                .classList.remove("sidebar-icon-only");
        }
        store.commit("setting/SET_SIDEBARSTATUS", sidebarStatus.value);
    },
    sidebarOffCanvas = (e) => {
        e.stopPropagation();
        store.commit("setting/SET_SIDEBARSTATUS", "open");
        document
            .querySelector(".sidebar-off-canvas")
            .classList.toggle("active");
    };

const darkMode = ref(false);
const toggleDarkMode = () => {
    darkMode.value = !darkMode.value;
    store.state.theme.darkMode = !store.state.theme.darkMode;
};

watch([darkMode, sidebarStatus], ([NewDarkMode, NewSidebarStatus]) => {
    let htmlElement = document.documentElement;
    if (NewDarkMode) {
        localStorage.setItem("theme", "dark");
        htmlElement.setAttribute("theme", "dark");
    } else {
        localStorage.setItem("theme", "light");
        htmlElement.setAttribute("theme", "light");
    }
    if (NewSidebarStatus === "open") {
        localStorage.setItem("sidebarStatus", "open");
        htmlElement.setAttribute("sidebarStatus", "open");
    } else {
        localStorage.setItem("sidebarStatus", "collapsed");
        htmlElement.setAttribute("sidebarStatus", "collapsed");
    }
});

const changeDirection = () => {
    let direction = localStorage.getItem("direction");
    if (!direction || direction == "null" || direction == "ltr") {
        direction = "rtl";
    } else {
        direction = "ltr";
    }
    let htmlElement = document.documentElement;
    htmlElement.setAttribute("dir", direction);
    htmlElement.setAttribute("class", direction);
    localStorage.setItem("direction", direction);
};
onBeforeMount(() => {
    let htmlElement = document.documentElement;
    let direction = localStorage.getItem("direction");
    if (direction) {
        htmlElement.setAttribute("dir", direction);
        htmlElement.setAttribute("class", direction);
    }
});
onMounted(() => {
    let htmlElement = document.documentElement,
        theme = localStorage.getItem("theme"),
        getSidebarStatus = localStorage.getItem("sidebarStatus");

    // Check for active theme
    if (theme === "dark") {
        htmlElement.setAttribute("theme", "dark");
        darkMode.value = true;
        store.state.theme.darkMode = true;
    } else {
        htmlElement.setAttribute("theme", "light");
        darkMode.value = false;
        store.state.theme.darkMode = false;
    }

    // Check for active sidebar
    if (getSidebarStatus === "open") {
        sidebarStatus.value = "open";
        htmlElement.setAttribute("theme", "open");
    } else {
        sidebarStatus.value = "collapsed";
        htmlElement.setAttribute("theme", "light");
        document.querySelector("body").classList.add("sidebar-icon-only");
    }
    store.commit("setting/SET_SIDEBARSTATUS", sidebarStatus.value);
});
const settingInfo = computed(() => store.getters["setting/setting"]);
</script>
