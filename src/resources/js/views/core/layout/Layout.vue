<template>
    <div
        class="container-scroller position-relative overflow-auto"
        @scroll="handleScroll"
        id="scrollerContainer"
    >
        <navbar :profile-data="profileData" />
        <div>
            <sidebar v-click-outside="sidebarOffCanvas" />
            <div class="sidebar-overlay"></div>
        </div>
        <div class="pt-4"></div>
        <div class="container-fluid page-body-wrapper py-5 px-md-20px">
            <div class="main-panel mt-4">
                <router-view />
            </div>
        </div>
    </div>
</template>

<script>
import Navbar from "@/core/layout/Navbar.vue";
import Sidebar from "@/core/layout/Sidebar.vue";
import store from "@store/index";
import { ref, computed, onMounted } from "vue";

export default {
    name: "Layout",
    components: { Navbar, Sidebar },
    setup() {
        const scrollTop = ref(0);
        const profileData = computed(() => store.getters["user/profileData"]);
        const getProfileData = () => {
            store.dispatch("user/getProfileData");
        };
        const handleScroll = (event) => {
            scrollTop.value = event.currentTarget.scrollTop;

            if (scrollTop.value > 10) {
                let navbar = document.getElementById("navbar-top");
                navbar.classList.add("add-scroller-style");
            } else {
                let navbar = document.getElementById("navbar-top");
                navbar.classList.remove("add-scroller-style");
            }

            // for back to top

            if (scrollTop.value > 150) {
                let backToTop = document.getElementById("backToTop");
                backToTop.classList.add("view");
            } else {
               // let backToTop = document.getElementById("backToTop");
                //backToTop.classList.remove("view");
            }
        };

        onMounted(() => {
            getProfileData();
        });
        const sidebarOffCanvas = () => {
            const sidebar = document.querySelector(
                ".sidebar-off-canvas.active"
            );
            if (sidebar) sidebar.classList.remove("active");
        };
        return { profileData, sidebarOffCanvas, handleScroll };
    },
};
</script>
