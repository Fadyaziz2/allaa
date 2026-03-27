<template>
    <avatar-group :avatars="profilePicture(rowData.users)" :view-length="10"/>
</template>

<script setup>
import AvatarGroup from "@/core/global/avatar/AvatarGroup.vue";
import {urlGenerator} from "@utilities/urlGenerator";

const props = defineProps({
    rowData: {}
})

const profilePicture = (element) => {
    return element.map((item) => {
        return {
            image: item.profile_picture ? urlGenerator(item.profile_picture.path) : null,
            name: item.full_name,
            active: item.status ? item.status.class : null,
        };
    });
}
</script>

