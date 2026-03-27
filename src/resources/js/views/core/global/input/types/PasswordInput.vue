<template>
    <div class="password-input flex-shrink-0">
        <input :type="type"
               :id="data.id"
               class="form-control"
               :value="value"
               v-bind="$attrs">
        <template v-if="data.showHideEffect">
            <i v-if="showingPassword"
               @click.prevent="showingPassword = false; type = 'password'"
               class="bi bi-eye fs-6 eye-icon cursor-pointer"
            />
            <i v-else
               @click.prevent="showingPassword = true; type = 'text'"
               class="bi bi-eye-slash eye-icon cursor-pointer"
            />
        </template>
    </div>
</template>

<script setup>
import {ref} from "vue"

const props = defineProps({
    value: {},
    data: {}
})

const showingPassword = ref(false)
const type = ref('password')
</script>

<style lang="scss">
.password-input {
    position: relative;

    .eye-icon {
        position: absolute;
        top: 50%;
        right: 0.85rem;
        color: var(--font-color);
        transform: translateY(-50%);
    }
}
.rtl{
    .eye-icon {
        left: 0.85rem;
        right:unset;
    }
}
</style>

