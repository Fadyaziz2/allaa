<template>
    <app-modal :modal-id="modalId" :title="selectedUrl ? $t('update_expense') : $t('add_expense')" modal-size="large"
               :preloader="preloader" @submit="submit" @close="closeModal">
        <template v-slot:body>
            <app-loader v-if="pageLoader"></app-loader>
            <form v-else>
                <div class="mb-4">
                    <app-input type="text" id="title" :label="$t('title')" label-required :placeholder="$t('title')"
                               v-model="formData.title" :errors="$errors(errors, 'title')"/>
                </div>

                <div class="mb-4">
                    <app-input type="date" id="date" v-model="formData.date" format="yyyy-MM-dd" :label="$t('date')"
                               label-required :placeholder="$t('date')" :enable-time-picker="false"
                               :max-date="new Date()" auto-apply
                               :errors="$errors(errors, 'date')"/>
                </div>

                <div class="mb-4">
                    <app-input type="number" id="amount" :label="$t('amount')" label-required
                               :placeholder="$t('amount')"
                               v-model="formData.amount" :errors="$errors(errors, 'amount')"/>
                </div>

                <div class="mb-4">
                    <app-input type="text" id="reference" :label="$t('reference')" :placeholder="$t('reference')"
                               v-model="formData.reference" :errors="$errors(errors, 'reference')"/>
                </div>

                <div class="mb-4">
                    <app-input type="advance-search-select" id="categories" :label="$t('category')" label-required
                               listValueField="name" list-key-field="id" v-model="formData.category_id"
                               :loading-length="10"
                               :fetch-url="`${SELECTED_CATEGORY}?type=expense`" :choose-label="$t('choose_a_category')"
                               :errors="$errors(errors, 'category_id')"/>
                </div>

                <div class="mb-4">
                    <app-input type="multi-image-uploader"
                               id="multi-image-upload-expense-modal"
                               :label="$t('attachments')"
                               @changeFile="filesSelected"/>

                    <div class="mt-2">
                        <small class="text-danger">{{$t('multi_image_upload_gide_line')}}</small>
                        <div v-for="(attachment, index) in attachments">
                            <small v-if="errors['attachments.'+index]" class="text-danger">
                                {{ errors['attachments.' + index][0] }}
                            </small>
                        </div>

                    </div>

                    <div v-if="formData.attachments?.length" class="w-100 d-flex flex-wrap gap-2 mt-3">
                        <template v-for="attachment in formData.attachments" :key="attachment.id">
                            <div class="d-block position-relative">
                                <img :src="urlGenerator(attachment.path)" alt=""
                                     class="height-80 border border-3 rounded-3 overflow-hidden">
                                <div class="remove-media" @click="removeAttachments(attachment.id)">
                                    <i class="bi bi-x"></i>
                                </div>
                            </div>
                        </template>
                    </div>
                     -`
                </div>

                <div class="mb-4">
                    <app-input type="textarea" id="note" :label="$t('note')" v-model="formData.note"
                               :errors="$errors(errors, 'note')"/>
                </div>
            </form>
        </template>
    </app-modal>
</template>

<script setup>
import {ref} from "vue"
import {useSubmitForm} from "@/core/global/composable/modal/useSubmitForm";
import {EXPENSES, SELECTED_CATEGORY} from "@services/endpoints/invoice";
import moment from 'moment';
import {urlGenerator} from "@utilities/urlGenerator";
import Axios from "@services/axios";
import {formDataAssigner} from "@utilities/helpers";

const props = defineProps({
    modalId: String,
    tableId: String,
    selectedUrl: String,
});

const emit = defineEmits(['close']);
const {
    pageLoader,
    preloader,
    formData,
    errors,
    closeModal,
    afterSuccess,
    afterError,
    afterFinalResponse
} = useSubmitForm(props, emit);
const attachments = ref([]);
const filesSelected = (files) => {
    attachments.value = files;
};
const deletableAttachmentIds = ref([]);
const removeAttachments = (id) => {
    formData.value.attachments = formData.value.attachments.filter(attachment => attachment.id != id);
    deletableAttachmentIds.value.push(id);
}

const submit = () => {
    const formDataCustomization = {
        ...formData.value,
        date: formData.value.date ? moment(formData.value.date).format('yyyy-MM-DD') : null
    }
    let data = formDataAssigner(new FormData(), formDataCustomization)
    deletableAttachmentIds.value.forEach(id => {
        data.append('deletable_attachment_ids[]', id);
    });
    attachments.value.forEach(attachment => {
        data.append('attachments[]', attachment);
    });
    save(props.selectedUrl ? props.selectedUrl : EXPENSES, data);
};

const save = (url, formData, type = 'patch', event = null) => {
    preloader.value = true
    if (props.selectedUrl) {
        if (type === 'patch') {
            Axios.post(url + '?_method=PATCH', formData, {headers: {'Content-Type': 'multipart/form-data'}}).then((response) => {
                afterSuccess(response, event)
            }).catch(({response}) => {
                afterError(response)
            }).finally(() => afterFinalResponse())
        } else {
            Axios.post(url + '?_method=PUT', formData, {headers: {'Content-Type': 'multipart/form-data'}}).then((response) => {
                afterSuccess(response, event)
            }).catch(({response}) => {
                afterError(response)
            }).finally(() => afterFinalResponse())
        }
    } else {
        Axios.post(url, formData, {headers: {'Content-Type': 'multipart/form-data'}}).then((response) => {
            afterSuccess(response, event)
        }).catch(({response}) => {
            afterError(response)
        }).finally(() => afterFinalResponse())
    }
}
</script>
<style lang="scss">
.remove-media {
    width: 18px;
    height: 18px;
    position: absolute;
    top: -5px;
    right: -5px;
    background: red;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #fff;
    cursor: pointer;
    opacity: 0.8;

    &:hover {
        opacity: 1;
    }

    i {
        font-size: 13px;
        top: 1px;
        position: relative;
    }
}
</style>

