<template>
    <div
        class="container-scroller position-relative overflow-auto custom-scrollbar"
        @scroll="handleScroll"
        id="scrollerContainer"
    >
        <router-view />
    </div>
</template>

<script setup>
import { ref } from 'vue';

const scrollTop = ref(0);
const handleScroll = (event) => {
    scrollTop.value = event.currentTarget.scrollTop;

    // for back to top
    if (scrollTop.value > 150) {
        let backToTop = document.getElementById("backToTop");
        backToTop.classList.add("view");
    } else {
        let backToTop = document.getElementById("backToTop");
        backToTop.classList.remove("view");
    }
};
</script>

<style lang="scss" scoped></style>
