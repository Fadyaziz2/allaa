<template>
    <div class="row text-nowrap">
        <div class="col-6 col-md-5 col-lg-4 col-xl-3 mb-0 d-flex gap-1 text-gray-600">
      <span>
        {{ label }}:
      </span>
            <span :class="`text-${type} fw-semibold`">
        {{ count }}
      </span>
        </div>
        <div class="col-6 col-md-7 col-lg-8 col-xl-9">
            <Progress v-bind="$attrs" :bar-color-class="`bg-${type}`"/>
        </div>
    </div>
</template>

<script setup>
import Progress from "@/invoice/progress/Progress.vue";
defineOptions({
    inheritAttrs: false,
});
defineProps({
    label: String,
    count: [String, Number],
    type: String,
});
</script>
