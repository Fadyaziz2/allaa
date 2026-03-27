<template>
    <div class="content-wrapper">
        <app-breadcrumb :page-title="$t('roles')">
            <template #breadcrumb-actions>
                <button
                    v-if="canAccess('create_roles')"
                    @click.prevent="isModalActive = true"
                    class="btn btn-primary text-white"
                >
                    {{ $t("add_role") }}
                </button>
            </template>
        </app-breadcrumb>
        <app-datatable :id="tableId" :options="options" @action="actionTiger" />

        <role-modal
            v-if="isModalActive"
            modal-id="role-modal"
            :table-id="tableId"
            :selected-url="selectedData"
            :data="{ permissions: permissions }"
            @close="closeModal"
        />

        <app-delete-modal
            v-if="isDeleteModal"
            :selected-url="deleteUrl"
            :table-id="tableId"
            @cancelled="cancelled"
        />

        <manage-user-modal
            v-if="isManageUserModalActive"
            modal-id="manage-user-modal"
            :table-id="tableId"
            :manage-user="manageUserInfo"
            @close="closeManageUserModal"
        />
    </div>
</template>

<script setup>
import { ref, onBeforeMount, markRaw } from "vue";
import { useI18n } from "vue-i18n";
import { PERMISSIONS, ROLES } from "@services/endpoints";
import RoleModal from "@/core/components/setting/roles/RoleModal.vue";
import Axios from "@services/axios";
import { useDeleteModal } from "@/core/global/composable/modal/useDeleteModal";
import { useOpenModal } from "@/core/global/composable/modal/useOpenModal";
import RoleUserGroupAvatar from "@/core/components/setting/roles/RoleUserGroupAvatar.vue";
import ManageUserModal from "@/core/components/setting/roles/ManageUserModal.vue";
import usePermission from '@/core/global/composable/usePermission';

const { canAccess } = usePermission();
const tableId = ref("role-table");
const { t } = useI18n();
const options = ref({
    url: ROLES,
    pageSize: 5,
    rowLimit: 10,
    orderBy: "desc",
    showGridView: false,
    actionType: "dropdown",
    paginationType: "pagination",
    enableRowSelect: false,
    enableBulkSelect: false,
    showSearch: true,
    showFilter: false,
    columns: [
        {
            title: t("name"),
            type: "text",
            key: "name",
        },
        {
            title: t("number_of_user"),
            type: "text",
            key: "users_count",
        },
        {
            title: t("users"),
            type: "component",
            key: "users",
            componentName: markRaw(RoleUserGroupAvatar),
        },
        {
            title: t("manage_users"),
            type: "button",
            key: "users_count",
            className: "btn btn-primary text-white",
            // label: t('manage'),
            modifier: (value, row) => (row.alias ? false : t("manage")),
        },

        {
            title: t("action"),
            type: "action",
            align: "right",
        },
    ],
    actions: [
        {
            title: t("edit"),
            icon: "bi bi-pencil-square",
            type: "edit",
            modifier: (row) => !!canAccess("update_roles") && !row.is_default,
        },
        {
            title: t("delete"),
            icon: "bi bi-trash3",
            type: "delete",
            modifier: (row) => !!canAccess("delete_roles") && !row.is_default,
        },
    ],
});

const { isModalActive, selectedData, closeModal } = useOpenModal();

const { deleteUrl, isDeleteModal, cancelled } = useDeleteModal();
const isManageUserModalActive = ref(false);
const manageUserInfo = ref([]);
const actionTiger = (row, action) => {
    if (action.type === "delete") {
        deleteUrl.value = `${ROLES}/${row.id}`;
        isDeleteModal.value = true;
    } else if (action.type === "edit") {
        isModalActive.value = true;
        selectedData.value = `${ROLES}/${row.id}`;
    } else if (action.key === "users_count") {
        isManageUserModalActive.value = true;
        manageUserInfo.value = row;
    }
};

const permissions = ref([]);

const getPermission = () => {
    Axios.get(PERMISSIONS).then(({ data }) => (permissions.value = data));
};

const closeManageUserModal = () => {
    isManageUserModalActive.value = false;
    manageUserInfo.value = [];
};

onBeforeMount(() => {
    getPermission();
});
</script>
