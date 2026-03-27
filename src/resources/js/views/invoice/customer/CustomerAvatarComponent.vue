<template>
    <div class="d-flex align-items-center">

        <avatar :image="profilePicture"
                :name="rowData.full_name"
                :active="rowData?.status?.class"/>
        <div class="name mx-2 fs-6">
            <router-link :to="`customer/${rowData.id}/details`" class="brand-color">
                {{ rowData.full_name }}
            </router-link>
        </div>

    </div>

</template>

<script setup>
import Avatar from "@/core/global/avatar/Avatar.vue";
import {urlGenerator} from "@utilities/urlGenerator";
import {computed} from "vue"

const props = defineProps({
    rowData: {}
})

const profilePicture = computed(() => {
    if (props.rowData.profile_picture) {
        return urlGenerator(props.rowData.profile_picture.path)
    }
})

</script>
<style scoped>
.name {
    font-weight: 500 !important;
}
</style>
