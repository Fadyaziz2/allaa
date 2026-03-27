<template>
    <label :for="labelId" :class="labelClass">
        {{ label }} <span v-if="required" class="text-danger">*</span>
        <i v-if="hintTitle"
           class="bi bi-info-circle-fill ms-1"
           data-bs-toggle="tooltip"
           data-bs-html="true"
           data-bs-placement="top"
           :title="hintTitle"/>
    </label>
</template>

<script>
import {onMounted} from "vue"
import {Tooltip} from "bootstrap"

export default {
    name: "InputLabel",

    props: {
        labelId: {
            type: String,
            require: true
        },
        label: {
            type: String,
            require: true
        },
        labelClass: {
            type: String,
            default: 'mb-2'
        },
        required: {
            type: Boolean,
            default: false
        },
        hintTitle: {
            type: String
        }
    },

    setup() {
        onMounted(() => {
            let tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
            tooltipTriggerList.map((tooltipTriggerEl) => new Tooltip(tooltipTriggerEl))
        })
    }

}
</script>
