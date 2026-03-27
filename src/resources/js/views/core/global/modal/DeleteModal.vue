<template>
    <div class="modal fade"
         :id="modalId"
         tabindex="-1"
         :aria-labelledby="`${modalId}-ModalLabel`"
         aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-body">
                    <div class="text-left">
                        <i :class="[icon?icon:'bi bi-trash-fill', modalClass ? modalClass:'text-danger']"
                           class="custom-delete-icon display-3"></i>
                    </div>
                    <br>
                    <h4 class="text-left font-weight-bold msg-white">
                        {{ title ? title : $t('are_you_sure_you_want_to_delete') }}</h4>
                    <p v-if="subTitle" class="text-center">{{ subTitle }}</p>
                    <p class="text-left">
                        {{ message ? message : $t('this_content_will_be_deleted_permanently') }}
                    </p>

                    <div class="border-top my-4"></div>

                    <div class="text-left d-flex gap-2" v-if="showFooter">
                        <button class="btn btn-primary-danger-outline mx-1"
                           data-dismiss="modal" @click.prevent="cancelled">
                            {{ secondButtonName ? secondButtonName : $t('cancel') }}
                        </button>
                        <button class="btn btn-primary-danger btn-danger"
                           data-dismiss="modal" @click.prevent="confirmed">
                            <app-button-loader v-if="preloader"/>
                            <i class="bi bi-trash"></i> {{ firstButtonName ? firstButtonName : $t('delete') }}
                        </button>
                    </div>

                    <div v-else class="text-left">
                        <slot name="footer"></slot>
                    </div>

                </div>

            </div>
        </div>
    </div>
</template>

<script setup>
import {ref, onMounted} from "vue";
import {Modal} from "bootstrap";
import useEmitter from "@/core/global/composable/useEmitter";
import Axios from "@services/axios";
import {useToast} from "vue-toastification";

const props = defineProps({
    modalId: {
        type: String,
        default: 'app-delete-modal'
    },
    title: String,
    icon: String,
    subTitle: String,
    message: String,
    modalClass: String,
    firstButtonName: String,
    secondButtonName: String,
    showFooter: {
        type: Boolean,
        default: true
    },
    selectedUrl: String,
    tableId: String,
    callBackEmit: {
        type: Boolean,
        default: false
    },
});

const emit = defineEmits(['cancelled', 'confirmed', 'confirmSuccess']);
const preloader = ref(false);
const toast = useToast();
const emitter = useEmitter();

const cancelled = () => {
    closeModal()
    emit('cancelled', false);
}
const confirmed = async () => {
    preloader.value = true;
    await Axios.delete(props.selectedUrl).then((response) => {
        closeModal();
        toast.success(response.data.message);
        emitter.emit('reload-' + props.tableId);
        if (props.callBackEmit) {
            emit('confirmSuccess')
        }
    }).catch((error) => {
        if (error.response?.data?.message) toast.error(error.response.data.message);
    }).finally(() => preloader.value = false);
}

const openModal = () => {
    let appModal = new Modal(document.getElementById(props.modalId))
    appModal.show();
}
const closeModal = () => {
    let modal = Modal.getInstance(document.getElementById(props.modalId));
    modal.hide();
}

onMounted(() => {
    openModal();
    let modal = document.getElementById(props.modalId),
        html = document.getElementsByTagName('html')[0];

    modal.addEventListener('hidden.bs.modal', () => {
        emit('cancelled');
        html.style.overflowY = 'auto';
    });

    modal.addEventListener('shown.bs.modal', () => {
        html.style.overflowY = 'hidden';
    });
})

</script>

<style lang="scss">
.msg-white {
    color: var(--font-color);
}
</style>


