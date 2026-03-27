<template>
    <div class="text-center d-flex w-100vw h-100vh justify-content-center align-items-center flex-column">
        <h1 class="display-1 fw-bold text-danger">404</h1>
        <p class="text-secondary">Sorry! The page your looking for doesn't exist!!</p>
        <router-link :to="{name: 'login'}" class="btn btn-primary">Back</router-link>

    </div>
</template>

<script setup>

</script>

<style lang="scss" scoped>

</style>
