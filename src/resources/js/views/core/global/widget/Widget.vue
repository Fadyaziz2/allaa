<template>
    <widget-square v-if="type === 'square'" :data="props"></widget-square>
    <widget-normal v-else :data="props"></widget-normal>
</template>

<script setup>
import WidgetNormal from "@/core/global/widget/WidgetNormal.vue";
import WidgetSquare from "@/core/global/widget/WidgetSquare.vue";

const props = defineProps({
    type: {
        type: String,
        default: 'normal'
    },
    title: {
        type: [String, Number],
        required: true
    },
    subTitle: {
        type: String
    },
    icon: {
        type: String,
        required: true
    },
    colorize: {
        type: String
    }

})
</script>

