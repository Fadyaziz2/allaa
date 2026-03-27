<template>
    <app-modal :modal-id="modalId"
               modal-size="extra-large"
               :title="selectedUrl ? $t('update_role') : $t('add_role')"
               :preloader="preloader"
               @submit="submit"
               @close="closeModal">
        <template v-slot:body>
            <div class="row mb-5">
                <div class="col-md-12">
                    <app-input type="text"
                               id="name"
                               :label="$t('name')"
                               label-required
                               :placeholder="$t('role_name')"
                               v-model="formData.name"
                               :errors="$errors(errors, 'name')"/>
                </div>
                <div class="col-md-4 d-flex align-items-center">

                        <div class="form-check mt-4">
                        <label class="form-check-label mx-2" for="all">{{ $t("select_all_permission") }}</label>
                        <input id="all"
                               class="form-check-input"
                               type="checkbox"
                               :checked="formData.permissions.length === permissionLength"
                               @click="selectAll($event)"
                               name="all_check">
                    </div>

                </div>
            </div>

            <div class="row" v-if="Object.keys(data.permissions).length">
                <div class="col-md-4" v-for="permissionGroupName in Object.keys(data.permissions)">
                    <div class="roles">
                        <div class="title-bar form-check rounded-default shadow-sm bg-gray-300">
                            <input :id="`single-checkbox-${permissionGroupName}`"
                                   class="form-check-input me-2 ms-0"
                                   type="checkbox"
                                   :checked="groupIsChecked(data.permissions[permissionGroupName])"
                                   @click="selectGroup($event)"
                                   :name="permissionGroupName">
                            {{ permissionGroupName }}
                        </div>

                        <div class="content p-3">
                            <div class="my-3 form-check " v-for="permission in data.permissions[permissionGroupName]">
                                <input :id="permission.id"
                                       type="checkbox"
                                       class="form-check-input"
                                       name="permissions"
                                       v-model="formData.permissions"
                                       :value="permission.id">
                                <label class="ms-2" :for="permission.id">
                                    {{ $t(permission.name) }}
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </template>
    </app-modal>
</template>

<script>
import {ref, computed, onMounted} from "vue"
import {ROLES} from "@services/endpoints";
import {useSubmitForm} from "@/core/global/composable/modal/useSubmitForm";
import Axios from "@services/axios";

export default {
    name: "RoleModal",
    props: {
        modalId: {},
        tableId: {},
        selectedUrl: {},
        data: {
            default: function () {
                return {
                    permissions: {}
                };
            }
        }
    },
    setup(props, {emit}) {

        const formData = ref({
            permissions: []
        })


        const {preloader, errors, save, closeModal} = useSubmitForm(props, emit, 'no')
        const submit = () => {
            save(props.selectedUrl ? props.selectedUrl : ROLES, formData.value)
        }

        const permissionLength = computed(() => {
            let i = 0;
            for (let permissionGroup in props.data.permissions) {
                i += props.data.permissions[permissionGroup].length;
            }
            return i;
        })

        const selectAll = (event) => {
            if (event.target.checked) {
                for (let permissionGroup in props.data.permissions) {
                    for (let permission in props.data.permissions[
                        permissionGroup
                        ]) {
                        formData.value.permissions.push(props.data.permissions[permissionGroup][permission].id);
                    }
                }
            } else {
                formData.value.permissions = [];
            }
        }

        const selectGroup = (event) => {
            let groupName = event.target.name;
            if (event.target.checked) {
                assignGroupPermission(getPermissionValues(props.data.permissions[groupName], "id"));
            } else {
                detachGroupPermission(
                    getPermissionValues(
                        props.data.permissions[groupName],
                        "id"
                    )
                );
            }
        }

        const getPermissionValues = (data, key) => {
            let value = [];
            for (let index in data) {
                value.push(data[index][key]);
            }
            return value;
        }
        const assignGroupPermission = (permissions) => {
            for (let index in permissions) {
                if (!formData.value.permissions.includes(permissions[index])) {
                    formData.value.permissions.push(permissions[index]);
                }
            }
        }
        const detachGroupPermission = (permissions) => {
            for (let index in permissions) {
                let indexOf = formData.value.permissions.indexOf(
                    permissions[index]
                );
                formData.value.permissions.splice(indexOf, 1);
            }
        }
        const groupIsChecked = (groupPermissions) => {
            let groupPermissionCheck = true;
            groupPermissions.forEach(item => {
                if (!formData.value.permissions.includes(item.id)) {
                    groupPermissionCheck = false;
                }
            });
            return groupPermissionCheck;
        }

        const getEditData = () => {
            if (props.selectedUrl) {
                Axios.get(props.selectedUrl).then(({data}) => {
                    formData.value = data
                    formData.value.permissions = data.permissions.map(item => item.id);
                })
            }
        }


        onMounted(() => {
            if (props.selectedUrl) {
                getEditData()
            }
        })

        return {
            submit,
            closeModal,
            preloader,
            formData,
            errors,
            permissionLength,
            selectAll,
            groupIsChecked,
            selectGroup
        }
    }
}
</script>

<style lang="scss">
.roles {
  .title-bar {
    background-color: var(--form-control-bg);
    border: 1px solid var(--border-color);
    padding: 10px 15px;
    font-size: 15px;
    font-weight: 500;
    text-transform: capitalize;
  }
}

</style>


