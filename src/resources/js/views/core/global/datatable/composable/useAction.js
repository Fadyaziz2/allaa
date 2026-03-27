import AppFunction from "@/core/global/helpers/app/coreAppFunction";
import {computed, ref} from "vue"

export const useAction = (props, emit) => {

    const action = ref({})
    const visibleActions = computed(() => {
        return props.actions.filter(action => {
            if (AppFunction.isUndefined(action.title)) return false
            if (AppFunction.isUndefined(action.modifier)) return true
            return action.modifier(props.rowData)
        })
    })

    const bothAction = (e, action, index) => {
        emit('action', props.rowData, action, index)
    }

    return {action, visibleActions, bothAction}

}
