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
                        <i :class="[icon?icon:'bi bi-check-circle', modalClass ? modalClass:'text-brand']"
                           class="custom-delete-icon display-3"></i>
                    </div>
                    <br>
                    <h4 class="text-left font-weight-bold msg-white">
                        {{ title ? title : $t('are_you_sure') }}</h4>
                    <p v-if="subTitle" class="text-center">{{ subTitle }}</p>
                    <p class="text-left">
                        {{ message }}
                    </p>
                    <div class="border-top my-4"></div>

                    <div class="text-left">

                        <button type="button" class="mx-1 me-2 d-inline-flex align-items-center" :disabled="preloader"
                                :class="[firstButtonClass ? firstButtonClass : 'btn btn-primary']"
                                data-dismiss="modal" @click.prevent="confirmed">
                            <app-button-loader v-if="preloader"/>
                            <i class="bi bi-check-circle me-2"></i> {{ firstButtonName ? firstButtonName : $t('yes') }}
                        </button>

                        <button type="button" class="d-inline-flex align-items-center"
                                :class="[secondButtonClass ? secondButtonClass : 'btn btn-primary-outline']"
                                data-dismiss="modal" @click.prevent="cancelled">
                            {{ secondButtonName ? secondButtonName : $t('no') }}
                        </button>

                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import {onMounted} from "vue";
import {Modal} from "bootstrap";

const props = defineProps({
    modalId: {
        type: String,
        default: 'app-conformation-modal'
    },
    title: String,
    icon: String,
    subTitle: String,
    message: String,
    modalClass: String,
    firstButtonName: String,
    firstButtonClass: String,
    secondButtonName: String,
    secondButtonClass: String,
    preloader: {
        type: Boolean,
        default: false
    }
});

const emit = defineEmits(['cancel', 'confirm']);

const cancelled = () => {
    closeModal()
    emit('cancel', false);
}

const confirmed = () => {
    emit('confirm');
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
        emit('cancel');
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

