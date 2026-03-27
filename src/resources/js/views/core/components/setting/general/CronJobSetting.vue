<template>
    <app-loader class="mt-4" v-if="preloader"/>
    <div v-else class="cron-job">
        <PrimaryNote
            :description="$t('cron_job_notice')"
            :title="$t('note')"
            class="p-4"
        />
        <div class="cronjob-service-provider mt-5">
            <CommandCopy
                v-for="command in commands"
                :command="command"
                :command-name="cronjobInfo.cron_job_command"
            />
        </div>
    </div>
</template>

<script setup>
import {onMounted, ref} from "vue";
import Axios from "@services/axios";
import {CRONJOB_SETTING} from "@services/endpoints";
import CommandCopy from "@/core/components/setting/general/CronTabComponents/CommandCopy.vue";
import {useI18n} from "vue-i18n";
import PrimaryNote from "@/core/global/note/PrimaryNote.vue";

const props = defineProps({
    id: {}
})

const cronjobInfo = ref({});
const {t} = useI18n();
const preloader = ref(false);
const getCronJobSetting = () => {
    preloader.value = true;
    Axios.get(CRONJOB_SETTING)
        .then(({data}) => {
            cronjobInfo.value = data;
        })
        .finally(() => (preloader.value = false));
};
const commands = ref([
    {
        title: t("cron_job_command"),
        instruction: t("copy_command_instruction"),
        commandName: t("command_with_php_path"),
    },
]);

onMounted(() => {
    getCronJobSetting();
});
</script>
