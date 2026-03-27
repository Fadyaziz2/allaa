<template>
    <li class="nav-item nav-profile dropdown">
        <a class="nav-link dropdown-toggle border-left py-0 px-2 gap-2"
           href="#"
           role="button"
           id="dropdownMyProfileLink"
           data-bs-toggle="dropdown"
           aria-expanded="false">
            <div class="text-end d-flex align-items-center d-none d-sm-block">
                <p class="username mb-0"> {{ profileData.full_name }}</p>
            </div>
            <div class="nav-profile-img">
                <img
                    :src="profileData.profile_picture ? urlGenerator(profileData.profile_picture.path) : urlGenerator('assets/images/avatar.svg')"
                    :alt="urlGenerator('assets/images/avatar.svg')">
            </div>
        </a>
        <div class="dropdown-menu dropdown-menu-end navbar-dropdown custom-scrollbar"
             aria-labelledby="dropdownMyProfileLink">

            <router-link to="/profiles" class="dropdown-item">
                <i class="bi bi-person me-3"/>
                <span class="d-inline-block">{{ $t('my_profile') }}</span>
            </router-link>

            <router-link to="/settings" class="dropdown-item" v-if="canAccess('manage_global_access')">
                <i class="bi bi-gear me-3"/>
                <span class="d-inline-block">{{ $t('settings') }}</span>
            </router-link>


            <a class="dropdown-item" href="" @click.prevent="logout">
                <i class="bi bi-box-arrow-right me-3"/>
                <span class="d-inline-block">{{ $t('logout') }}</span>
            </a>
        </div>
    </li>
</template>

<script setup>
import {useAuth} from "@services/auth";
import {urlGenerator} from "@utilities/urlGenerator";
import usePermission from "@/core/global/composable/usePermission";
const { canAccess } = usePermission();

const props = defineProps({
    profileData: {}
})
const {logout} = useAuth();
</script>


