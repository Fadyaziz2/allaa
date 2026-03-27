<template>
    <div class="row" v-if="componentData">
        <div class="col-md-8 pt-2">
            <div class="form-group">
                <app-input type="text"
                           id="name"
                           :label="t('subject')"
                           label-required
                           :placeholder="t('subject')"
                           v-model="formData.subject"/>
            </div>
            <div class="form-group mt-4 mb-2">
                <label for="">Email Content</label>
            </div>
            <div class="form-group ">
                <app-input type="editor" ref="quillEditor"
                           v-model="formData.description"/>

            </div>
            <div v-if="canAccess('update_notification_template')" class="form-group mt-4">
                <button type="button"
                        class="btn btn-primary"
                        @click.prevent="submit">
                    <app-button-loader v-if="preloader"/>
                    <i class="bi bi-download"></i>
                    {{ $t('save_changes') }}
                </button>
            </div>

        </div>
        <div class="col-md-4">
            <div class="template-variables mt-4">
                <p class="title">{{ $t('template_variables') }}</p>
                <div class="variables">
                    <button v-for="(tag, index) in allTags" :key="index"
                            class="btn btn-transparent btn-sm d-block text-muted m-0 text-start"
                            @click.prevent="insertVariables(tag.tag)">
                        {{ tag.tag }}

                    </button>
                </div>

            </div>
        </div>
    </div>
</template>


<script setup>
import {onMounted, ref, computed} from "vue"
import Axios from "@services/axios";
import {NOTIFICATION_TEMPLATE} from "@services/endpoints";
import {useToast} from "vue-toastification";
import usePermission from '@/core/global/composable/usePermission';
import {useI18n} from "vue-i18n";

const {t} = useI18n();

const { canAccess } = usePermission();
const props = defineProps({
    componentData:{}
})

const toast = useToast()

const formData = ref({
    subject: '',
    description: ''
})
const getAllTags = ref({
    '{receiver_name}': 'the_profile_who_will_receive_the_notification',
    '{first_name}': 'the_profile_who_will_receive_the_notification',
    '{last_name}': 'the_profile_who_will_receive_the_notification',
    '{email}': 'the_profile_who_will_receive_the_notification',
    '{password}': 'the_profile_who_will_receive_the_notification',
    '{name}': 'the_profile_who_will_receive_the_notification',
    '{company_name}': 'the_profile_who_will_receive_the_notification',
    '{invoice_number}': 'the_profile_who_will_receive_the_notification',
    '{due_date}': 'the_profile_who_will_receive_the_notification',
    '{estimate_number}': 'the_profile_who_will_receive_the_notification',
    '{app_url}': 'the_profile_who_will_receive_the_notification',
    '{app_logo}': 'the_profile_who_will_receive_the_notification',
    '{app_name}': 'the_profile_who_will_receive_the_notification',
    '{action_by}': 'the_profile_who_will_receive_the_notification',
    '{button_url}': 'the_profile_who_will_receive_the_notification',
    '{otp_number}' : 'the_profile_who_will_receive_the_notification'
})

const allTags = computed(() => {
    const tags = Object.keys(getAllTags.value).filter(tag => {
        if (1 === props.componentData.id) {
            return ['{app_name}', '{receiver_name}', '{app_logo}', '{button_url}', '{otp_number}'].includes(tag)
        } else if (2 === props.componentData.id) {
            return ['{app_name}', '{receiver_name}', '{app_logo}', '{button_url}', '{action_by}'].includes(tag)
        } else if (3 === props.componentData.id) {
            return ['{app_name}', '{receiver_name}', '{name}', '{app_logo}', '{company_name}'].includes(tag)
        } else if (5 === props.componentData.id) {
            return ['{app_name}', '{receiver_name}', '{app_logo}', '{email}', '{password}', '{button_url}'].includes(tag)
        } else if (6 === props.componentData.id) {
            return ['{app_name}', '{receiver_name}', '{invoice_number}', '{due_date}', '{app_logo}'].includes(tag)
        } else if (7 === props.componentData.id) {
            return ['{app_name}', '{receiver_name}', '{invoice_number}', '{app_logo}'].includes(tag)
        } else if (8 === props.componentData.id) {
            return ['{app_name}', '{receiver_name}', '{quotation_number}', '{app_logo}'].includes(tag)
        } else {
            return ['{name}', '{action_by}'].includes(tag)
        }
    })

    return tags.map(tag => {
        return {tag, description: getAllTags.value[tag]}
    })
})
const quillEditor = ref();
const insertVariables = (text) => {
    const quill = quillEditor.value.quill.getQuill();
    if (quill.getSelection()) {
        let cursorPosition = quill.getSelection().index;
        quill.insertText(cursorPosition, text);
    }
}
const preloader = ref(false)
const submit = () => {
    preloader.value = true
    Axios.patch(`${NOTIFICATION_TEMPLATE}/${props.componentData.id}`, formData.value).then(({data}) => {
        toast.success(data?.message);
    }).finally(() => preloader.value = false)
}
onMounted(() => {
    if (props.componentData) {
        formData.value.subject = props.componentData?.subject
        formData.value.description = props.componentData?.custom_content ?? props.componentData?.default_content
    }
})

</script>
