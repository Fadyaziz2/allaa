<template>
    <div class="container py-5 my-5 installer-container">
        <div class="overflow-auto custom-scrollbar">
            <ul class="multi-steps text-nowrap">
                <li :class="{'is-active': currentTab === 1}">Server Requirement</li>
                <li :class="{'is-active': currentTab === 2}">Database Configure</li>
                <li :class="{'is-active': currentTab === 3}">Admin Information</li>
                <li :class="{'is-active': currentTab === 4}">Company information</li>
                <li :class="{'is-active': currentTab === 5}">Email setup</li>
            </ul>
        </div>

        <div class="installation-body">
            <Installation v-if="currentTab === 1" @next="setNewTab"/>
            <EnvironmentSetup v-if="currentTab === 2" @next="setNewTab"/>
            <UserInfo v-if="currentTab === 3" @next="setNewTab"/>
            <CompanySetup v-if="currentTab === 4" @next="setNewTab"/>
            <EmailSetup v-if="currentTab === 5"/>
        </div>
    </div>

</template>

<style scoped>
.container {
    max-width: 60%;
    margin: 0 auto;
}
.multi-steps {
    width: 100%;
    overflow-x: auto;
}
.multi-steps li {
    list-style: none;
    display: inline-block;
    margin: 0 10px;
    font-size: 1rem;
}

.multi-steps li.is-active {
    color: #00aaf0;
}
</style>
<script setup>
import {defineAsyncComponent, ref} from 'vue';

const Installation = defineAsyncComponent(() => import('./Installation.vue'))
const EnvironmentSetup = defineAsyncComponent(() => import('./EnvironmentSetup.vue'))
const UserInfo = defineAsyncComponent(() => import('./UserInfo.vue'))
const CompanySetup = defineAsyncComponent(() => import('./CompanySetup.vue'))
const EmailSetup = defineAsyncComponent(() => import('./EmailSetup.vue'))


const currentTab = ref(1);

const setNewTab = (tab) => {
    currentTab.value = tab;
}
</script>
