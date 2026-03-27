<template>
    <div class="text-center d-flex w-100vw h-100vh justify-content-center align-items-center flex-column">
        <h1 class="display-1 fw-bold text-danger">403</h1>
        <p class="text-secondary">Sorry! Action you are trying to perform is not allowed</p>
        <router-link :to="{name: 'dashboard'}" class="btn btn-primary">Back to Dashboard</router-link>
    </div>
</template>

<script setup>

</script>

<style lang="scss" scoped>

</style>
