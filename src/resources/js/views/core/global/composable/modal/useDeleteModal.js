import {ref} from "vue"

export const useDeleteModal = () => {
    const deleteUrl = ref(null)
    const isDeleteModal = ref(false)

    const cancelled = () => {
        isDeleteModal.value = false
        deleteUrl.value = null
    }
    return {deleteUrl, isDeleteModal, cancelled}
}
