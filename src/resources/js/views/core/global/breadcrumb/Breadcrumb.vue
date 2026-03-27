<template>
    <div class="d-flex align-items-center justify-content-between mb-3">
        <h4 class="mb-0 breadcrumb-custom">{{ pageTitle }}</h4>
        <slot name="breadcrumb-actions"></slot>
    </div>
</template>

<script>
export default {
    name: "Breadcrumb",
    props: {
        pageTitle: {
            type: String
        }
    }
}
</script>

<style scoped>
.breadcrumb-custom {
    font-size: 24px;
    font-weight: 500;
}
</style>

