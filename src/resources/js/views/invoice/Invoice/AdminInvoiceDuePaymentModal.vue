<template>
    <app-modal :modal-id="modalId" :title="$t('invoice_due_payment')" modal-size="large" :preloader="preloader"
               @submit="submit" @close="closeModal">

        <template v-slot:body>
            <div class="row">
                <div class="col-sm-6">
                    <div class="mb-3">
                        <app-input type="date" :label="$t('received_on')" label-required
                                   :placeholder="$t('received_on')"
                                   v-model="formData.received_on"
                                   :enable-time-picker="false"
                                   auto-apply
                                   :errors="$errors(errors, 'received_on')"/>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="mb-4">
                        <app-input type="select" id="paymentMethod" :label="$t('payment_method')" label-required
                                   :options="paymentMethodList" list-value-field="name"
                                   :choose-label="$t('choose_a_payment_method')"
                                   v-model="formData.payment_method_id" :errors="$errors(errors, 'payment_method_id')"/>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="mb-3">
                        <app-input type="text"
                                   :label="$t('due_amount')"
                                   label-required
                                   :placeholder="$t('due_amount')"
                                   v-model="dueAmount"
                                   disabled/>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="mb-3">
                        <app-input type="number" :label="$t('paying_amount')"
                                   label-required
                                   :placeholder="$t('paying_amount')"
                                   v-model="formData.paying_amount"
                                   :errors="$errors(errors, 'paying_amount')"/>
                    </div>
                </div>

                <div class="col-md-12">
                    <app-input v-model="formData.note"
                               :label="$t('note')"
                               type="textarea"/>
                </div>

            </div>


        </template>

    </app-modal>
</template>

<script setup>
import {onMounted, ref, computed} from "vue";
import {useSubmitForm} from "@/core/global/composable/modal/useSubmitForm";
import {ADMIN_DUE_INVOICE_PAYMENT, SELECTED_ADMIN_PAYMENT_METHOD, SELECTED_NOTE} from "@services/endpoints/invoice";
import Axios from "@services/axios";
import moment from "moment";
import {numberFormatter} from "@utilities/helpers";

const props = defineProps({
    modalId: String,
    tableId: String,
    invoiceData: {},
})
const emit = defineEmits(['close'])

const dueAmount = computed(() => numberFormatter(props.invoiceData.due_amount))
const {preloader, formData, errors, save, closeModal} = useSubmitForm(props, emit)
const submit = () => {

    const data = {
        ...formData.value,
        received_on: formData.value.received_on ? moment(formData.value.received_on).format('YYYY-MM-DD') : null
    }
    save(`${ADMIN_DUE_INVOICE_PAYMENT}/${props.invoiceData.id}`, data)
}

const paymentMethodList = ref([])

const getPaymentMethod = () => {
    Axios.get(SELECTED_ADMIN_PAYMENT_METHOD).then((response) => {
        paymentMethodList.value = response.data
    })
}
onMounted(() => {
    getPaymentMethod()
})

</script>


