import store from "@store/index"
import { computed } from "vue"

export default function usePermission() {
    const storePermissions = (permissionList) => {
        store.commit('permission/SET_PERMISSIONS', permissionList);
    }

    const removePermissions = () => {
        store.commit('permission/SET_PERMISSIONS', {});
    }

    const permissions = computed(()=> store.getters['permission/permissions']);

    const canAccess = (permissionName) => {
        if (permissions.value && permissions.value.is_app_admin) {
            return true;
        }

        if (!permissions.value || !permissions.value[permissionName]) return false;
        return permissions.value[permissionName];
    }

    const isSupperAdmin = () => {
        if (permissions.value) {
            return permissions.value.is_app_admin;
        }
    }
    return {
        storePermissions,
        removePermissions,
        canAccess,
        isSupperAdmin

    }
}
