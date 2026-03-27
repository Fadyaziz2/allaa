<template>
    <div class="avatar-wrapper">
        <img v-if="image"
             :src="image"
             class="rounded-circle has-image" >
        <div v-else class="no-image fw-semibold">
            {{ titleFilter }}
        </div>
    </div>
</template>

<script>
import {computed} from "vue"

export default {
    name: "Avatar",
    props: {
        image: String,
        name: String,
        size: {
            default: 40
        },
        active: String
    },

    setup(props) {
        const titleFilter = computed(() => {
            const name = props.name || 'A V'
            const parts = name.split(' ')
            const first = parts[0] ? parts[0][0] : ''
            const last = parts.length > 1 ? parts[parts.length - 1][0] : ''
            return `${first}${last}`.toUpperCase()
        })

        return {titleFilter}
    }

}
</script>

<style lang="scss">
.avatar-wrapper {
    position: relative;

    img {
        height: 100%;
        width: 100%;
    }
    .has-image{
        height: 40px!important;
         width: 40px!important;
    }

    .no-image {
        font-size: 14px;
        height: 45px!important;
         width: 45px!important;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #ffffff;
        background-color: #00aaf0
    }

    .active-status {
        height: 8px;
        width: 8px;
        border-radius: 50%;
        bottom: 6%;
        right: 10%;
        position: absolute;
    }
}
</style>
