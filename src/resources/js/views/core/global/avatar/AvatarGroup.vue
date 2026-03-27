<template>
    <div class="app-avatar-group">

        <div v-if="minimalView" class="minimal-view d-flex align-items-center cursor-pointer"
            @click.prevent="minimalView = false">
            <template v-for="(avatar, index) in avatars" :key="index">
                <avatar v-if="index < viewLength" :image="avatar.image" :name="avatar.name" :active="avatar.active"
                    size="36" />
            </template>

            <span class="mx-3 user-name">
                <!-- + - viewLength-->
                {{ avatars.length }} Users
            </span>
        </div>
        <div v-else>
            <template v-for="(avatar, index) in avatars" :key="index">
                <div class="d-flex align-items-center my-3 gap-2" v-if="index < viewLength" :key="index">
                    <avatar :image="avatar.image" :name="avatar.name" :active="avatar.active" :size="36" />
                    <div class="ms-2 d-flex justify-content-center flex-column">
                        <p class="m-0" v-if="avatar.name">{{ avatar.name }}</p>
                        <small v-if="avatar.title">{{ avatar.title }}</small>
                    </div>
                </div>
            </template>
        </div>
        <div title="Hide Details" v-if="!minimalView" class="avatar-minimize p-2 rounded-3 cursor-pointer"
            @click.prevent="minimalView = true">
            <i class="bi bi-arrows-angle-contract fw-bold"></i>
        </div>
    </div>
</template>

<script setup>
import { ref } from "vue"
import Avatar from "@/core/global/avatar/Avatar.vue";

const props = defineProps({
    avatars: {
        type: Array,
        required: true
    },
    viewLength: {
        type: Number,
        default: 5
    }
})

const minimalView = ref(true)

</script>

<style lang="scss">
.app-avatar-group {
    display: flex;
    position: relative;
    justify-content: space-between;
    column-gap: 10px;

    .avatar-minimize {
        background-color: transparent;
        color: var(--font-color);
        position: relative;
        right: 0;
        top: 14px;
        border: none;

        i {
            font-size: 1.3rem;
            color: var(--font-color);
        }
    }

    .avatar-wrapper {
        img,
        .no-image {
            border: 2px solid var(--border-color);
            transition: .5s;

            &:hover {
                transform: translateY(-2px) scale(1.02);
            }
        }
        &:not(:first-child) {
            margin-left: -10px;
        }
    }
}

.rtl {
    .app-avatar-group {
        .avatar-wrapper {
            &:not(:first-child) {
                margin-right: -10px;
            }
        }
        .user-name{
            margin-right: 20px!important;
            margin-left: 0!important;
        }
    }
}
</style>
