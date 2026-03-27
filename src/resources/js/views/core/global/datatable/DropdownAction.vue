<template>
    <div class="dropdown dropstart action-dropdown" v-if="visibleActions && visibleActions.length > 0">
        <button class="dropdown-toggle"
                :key="'more-vertical-'+visibleActions.length"
                type="button"
                data-bs-toggle="dropdown"
                aria-expanded="false">
            <i class="bi bi-three-dots-vertical"/>
        </button>
        <ul class="dropdown-menu dropdown-menu-end scaleIn has-arrow right-top custom-scrollbar" :key="'dropdown-'+visibleActions.length">
            <li v-for="(action, index) in visibleActions" :key="index">
                <a href="#"
                    class="dropdown-item d-flex align-items-center gap-2"
                   :class="action.className"
                   @click.prevent="bothAction('', action, index)">
                     <i :class="action.icon"></i>
                     {{  action.title }}
                </a>
            </li>
        </ul>
    </div>
</template>

<script>
import {useAction} from "@/core/global/datatable/composable/useAction";

export default {
    name: "DropdownAction",
    props: {
        actions: {
            required: true,
            type: Array
        },
        rowData: {
            type: Object
        }
    },

    setup(props, {emit}) {
        const {action, visibleActions, bothAction} = useAction(props, emit)

        return {action, visibleActions, bothAction}
    }
}
</script>

