<template>
    <quill-editor v-model="content"/>
</template>

<script setup>

import {ref} from 'vue'
import {QuillEditor} from '@vueup/vue-quill'
import '@vueup/vue-quill/dist/vue-quill.snow.css';

const props = defineProps({
    data: {},
    value: {}
})
const content = ref('')
</script>

