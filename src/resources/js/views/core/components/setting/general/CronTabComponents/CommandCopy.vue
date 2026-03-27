<template>
    <div>
        <h5>
            <b>{{ props.command?.title }}</b>
        </h5>
        <!-- <p>{{ props.command?.instruction }}</p> -->
        <div class="d-flex gap-3 align-items-center">
            <!-- <p class="text-nowrap m-0">{{ props.command?.commandName }}</p> -->
            <p
                class="text-nowrap overflow-auto custom-scrollbar m-0"
                @click.prevent="selectText"
                readonly
            >
                <code>{{ props.commandName }}</code>
            </p>
            <button
                type="button"
                class="btn has-shadow btn-primary btn-sm text-white gap-2 width-80 text-center"
                @click="copy(props.commandName)"
            >
                <!-- <i class="bi bi-clipboard-plus lh-1"></i> -->
                {{ $t("copy") }}
            </button>
        </div>
    </div>
</template>
<script setup>
import { useToast } from "vue-toastification";
import { useI18n } from "vue-i18n";

const { t } = useI18n();

const toast = useToast();
const props = defineProps({
    command: Object,
    commandName: String,
});
const selectText = (e) => {
    window.getSelection().selectAllChildren(e.currentTarget);
};
const copy = async (text) => {
    // Navigator clipboard api needs a secure context (https)
    if (navigator.clipboard && window.isSecureContext) {
        await navigator.clipboard.writeText(text).then(() => {
            toast.success(t("copied_has_been_successfully"));
        });
    } else {
        // Use the 'out of viewport hidden text area' trick
        const textArea = document.createElement("textarea");
        textArea.value = text;

        // Move textarea out of the viewport so it's not visible
        textArea.style.position = "absolute";
        textArea.style.left = "-999999px";

        document.body.prepend(textArea);
        textArea.select();

        try {
            document.execCommand("copy");
            toast.success(t("copied_has_been_successfully"));
        } catch (error) {
            console.error(error);
        } finally {
            textArea.remove();
        }
    }
};
</script>
