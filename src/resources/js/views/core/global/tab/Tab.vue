<template>
    <div class="profile-page-wrapper">
        <div class="user-info-column rounded-default overflow-hidden p-0">
            <slot></slot>
            <div class="user-tab-menu rounded-default overflow-hidden">
                <div class="nav nav-pills border-top-0 border-start-0 border-end-0" :class="{
                    'flex-column': type === 'vertical',
                    'border': props.showBorder,
                },`border-${props.borderWidth}`" id="v-pills-tab" role="tablist"
                     :aria-orientation="type">
                    <template v-for="(tab, index) in filteredTab" :key="index">
                        <button class="nav-link" :class="{ 'active': tab.key === activeTab }"
                                @click="setActiveTab(tab)"
                                :id="`v-pills-${tab.key}-tab`" data-bs-toggle="pill"
                                :data-bs-target="`#v-pills-${tab.key}`"
                                type="button" role="tab" :aria-controls="`v-pills-${tab.key}`" aria-selected="true">

                            <template v-if="tab.icon">
                                <i :class="tab.icon"/>
                            </template>
                            {{ tab.title.replace("_", " ") }}
                        </button>
                    </template>
                </div>
            </div>
        </div>
        <div class="user-details-column shadow-sm">
            <div class="tab-content" id="v-pills-tabContent">
                <template v-for="(tab, index) in filteredTab" :key="index">
                    <div v-if="tab.key === activeTab" class="tab-pane fade"
                         :class="{ 'show active': tab.key === activeTab }" :id="`v-pills-${tab.key}`" role="tabpanel"
                         :aria-labelledby="`v-pills-${tab.key}-tab`">

                        <div v-if="tab.showHeader"
                             class="tab-pane-header d-flex align-items-center justify-content-between">
                            <h5 class="mb-0 fs-6">{{ tab.title }}</h5>
                            <button
                                v-if="!isUndefined(tab.headerButton && tab.headerButton.label && tab.headerButton.permission) && tab.headerButton.permission"
                                :class="tab.headerButton.class ? tab.headerButton.class : 'btn btn-primary'"
                                @click.prevent="headerBtnClicked(activeTab)">
                                {{ tab.headerButton.label }}
                            </button>
                        </div>

                        <div class="tab-pane-content" :class="{'pt-20': tab.showHeader}">
                            <template v-if="componentProps">
                                <component :is="tab.component" :componentData="componentProps" :id="activeTab"/>
                            </template>
                            <template v-else>
                                <component :is="tab.component" :id="activeTab"/>
                            </template>

                        </div>
                    </div>
                </template>
            </div>
        </div>
    </div>
</template>

<script setup>
import {objectToQueryString} from "@/core/global/helpers/QueryHelper";
import {ref, onMounted, computed} from "vue"
import {useCoreAppFunction} from "@/core/global/helpers/CoreLibrary";
import router from "@router/index";
import useEmitter from "@/core/global/composable/useEmitter";

const props = defineProps({
    tabs: {
        type: Array,
        required: true
    },
    id: {
        type: String,
        required: true,
    },
    type: {
        type: String,
        default: 'vertical'
    },
    borderWidth: {
        type: [String, Number],
        default: '1'
    },
    showBorder: Boolean,
    componentProps: {
        type: [String, Object, Array],
        required: false,
    }
})
const emitter = useEmitter()
const {isUndefined} = useCoreAppFunction()
const filteredTab = computed(() => props.tabs.filter(tab => (isUndefined(tab.permission) || tab.permission !== false)))

const activeTab = ref('')
const componentProps = ref('')
const currentIndex = ref(0)
const setTabByName = () => {
    let currentTab = {}, result = {};
    result = filteredTab.value.find((item, index) => {
        if (item.title) {
            currentIndex.value = index;
            return item;
        }
    });
    currentTab = result ? result : filteredTab.value[currentIndex.value];
    setActiveTab(currentTab)
}
const i = ref(0)
const setActiveTab = (tab) => {
    componentProps.value = tab.props
    let tabName = `tab-${props.id}`,
        qObj = {};
    if (i.value) {
        qObj[tabName] = tab.key;
        activeTab.value = tab.key;
    } else {
        qObj[tabName] = router.currentRoute.value.query['tab-setting-tab'] || tab.key;
        activeTab.value = router.currentRoute.value.query['tab-setting-tab'] || tab.key;
        i.value++;
    }

    let query = objectToQueryString(qObj),
        pageTitle = document.title;
    history.replaceState({...history.state}, pageTitle, `?${query}`);

}

const headerBtnClicked = (activeTab) => {
    emitter.emit('headerButtonTiger-' + activeTab);
}


onMounted(() => {
    setTabByName()
})

</script>

