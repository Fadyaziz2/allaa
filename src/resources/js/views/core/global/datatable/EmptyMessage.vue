<template>
    <div class="no-data-found text-center">
        <img class="mb-primary" :src="urlGenerator('assets/images/nothing.svg')">
        <p class="mb-0 text-center mt-3">{{ $t('nothing_to_show_here') }}</p>
    </div>

</template>

<script setup>
import {urlGenerator} from "@utilities/urlGenerator";
</script>

<style lang="scss">
.no-data-found img {
    width: 165px;
    margin-top: 5%;
}
</style>

