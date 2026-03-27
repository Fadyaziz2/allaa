<template>
    <app-modal :modal-id="modalId"
               @submit="submit"
               @close="close">
    </app-modal>
</template>

<script>
import AppModal from "@/core/global/modal/Modal.vue";
import {Modal} from "bootstrap";

export default {
    name: "PaymentSettingModal",
    components: {AppModal},
    props: {
        modalId: {},
        tableId: {}
    },
    setup(props, {emit}) {
        const submit = () => {

        }
        const close = () => {
            let myModalId = document.getElementById(props.modalId)
            new Modal(myModalId).hide();
            emit('close')
        }

        return {submit, close}
    }
}
</script>

