<template>
    <div>
    <span v-if="files.length" v-for="(file, index) in files" :key="index">
        <a :href="urlGenerator(file.path)" :title="$t('view_attachment')" target="_blank" class="mx-1">
            <i class="bi bi-paperclip brand-color fs-5"></i>
        </a>
    </span>
    <span v-else>
        -
    </span>
    </div>
</template>

<script setup>
import {urlGenerator} from "@utilities/urlGenerator";
import {computed} from "vue";

const props = defineProps({
    rowData: {}
})

const files = computed(() => props.rowData.attachments)
</script>

