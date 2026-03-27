<template>
    <div>
        <template v-if="rowData">
            <div class="dropdown">
                <router-link :to="url">{{ rowData.invoice_full_number }}</router-link>
            </div>
        </template>
        <template v-else> -</template>
    </div>
</template>

<script setup>
import {ref} from "vue";

const props = defineProps({
    rowData: {
        type: Object,
        required: true,
    },
});

const url = ref(`${props.rowData.recurring != null ? 'invoice' : 'quotation'}/${props.rowData.id}/details`)

</script>
