<template>
    <div class="row" v-if="componentData">
        <div class="col-md-8 pt-2">
            <div class="form-group">
                <app-input type="text"
                           id="name"
                           label="Subject"
                           label-required
                           placeholder="Subject"
                           v-model="formData.description"/>
            </div>

            <div class="form-group mt-4">
                <button v-if="canAccess('update_notification_template')" type="submit" class="btn btn-primary"
                        @click.prevent="submit">
                    <app-button-loader v-if="preloader"/>
                    <i class="bi bi-download"></i>
                    {{ $t('save_changes') }}
                </button>
            </div>

        </div>
        <div class="col-md-4">
            <div class="template-variables">
                <p class="title">Template Variables</p>
                <div class="variables">
                    <button v-for="(tag, index) in Object.keys(getAllTags)" :key="index"
                            class="btn btn-transparent btn-sm d-block text-muted m-0 text-start"
                            @click.prevent="insertVariables(tag)">
                        {{ tag }}
                        <!-- - {{ getAllTags[tag] }} -->
                    </button>
                </div>

            </div>
        </div>
    </div>
</template>


<script setup>
import {ref, onMounted} from "vue"
import Axios from "@services/axios";
import {NOTIFICATION_TEMPLATE} from "@services/endpoints";
import {useToast} from "vue-toastification";
import usePermission from "@/core/global/composable/usePermission";
const { canAccess } = usePermission();

const props = defineProps({
    componentData:{}
})


const toast = useToast()
const formData = ref({})
const preloader = ref(false)

const getAllTags = ref({
    '{app_name}': 'the_profile_who_will_receive_the_notification',

})
const quillEditor = ref();
const insertVariables = (text) => {

}
const submit = () => {
    Axios.patch(`${NOTIFICATION_TEMPLATE}/${props.componentData.id}`, formData.value).then(({data}) => {
        toast.success(data?.message);
    })
}

onMounted(() => {
    if (props.componentData) {
        formData.value.description = props.componentData?.custom_content ?? props.componentData?.default_content
    }
})


</script>

