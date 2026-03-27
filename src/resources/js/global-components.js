import {defineAsyncComponent} from 'vue'

export const defineGlobalComponents = (app) => {

    app.component('app-breadcrumb', defineAsyncComponent(() => import("@/core/global/breadcrumb/Breadcrumb.vue")))
    app.component('app-input', defineAsyncComponent(() => import("@/core/global/input/FormInput.vue")))
    app.component('app-tab', defineAsyncComponent(() => import("@/core/global/tab/Tab.vue")))
    app.component('app-datatable', defineAsyncComponent(() => import("@/core/global/datatable/Datatable.vue")))
    app.component('app-filter', defineAsyncComponent(() => import("@/core/global/datatable/filters/Filter.vue")))
    app.component('app-modal', defineAsyncComponent(() => import("@/core/global/modal/Modal.vue")))
    app.component('app-delete-modal', defineAsyncComponent(() => import("@/core/global/modal/DeleteModal.vue")))
    app.component('app-loader', defineAsyncComponent(() => import("@/core/global/loader/LoaderSpin.vue")))
    app.component('app-button-loader', defineAsyncComponent(() => import("@/core/global/loader/ButtonLoader.vue")))
    app.component('app-chart', defineAsyncComponent(() => import("@/core/global/charts/Chart.vue")))
    app.component('app-widget', defineAsyncComponent(() => import("@/core/global/widget/Widget.vue")))
    app.component('app-note', defineAsyncComponent(() => import("@/core/global/note/Note.vue")))

}
