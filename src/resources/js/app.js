import "./bootstrap";

import "bootstrap-icons/font/bootstrap-icons.scss";
import {createApp} from "vue";
import router from "./router";
import {i18n} from "@i18n";

// Directives
import detectOutsideClick from "./directives/click/detectOutsideClick";

import store from "./store";
import progressbar from "./plugins/progressbar/index";

import mitt from "mitt";

const emitter = mitt();

// Validation Error

import ValidationErrors from "@/core/global/input/errors/ValidationErrors";

//Toaster
import Toast from "vue-toastification";

const toastOptions = {
    position: "top-center",
};
import "vue-toastification/dist/index.css";

const progressbarOptions = {
    // 2B8768
    color: "#00aaf0",
    gradient: "linear-gradient(to right, #00aaf0, #00ff00)",
    failedColor: "#ed213a",
    failedGradient: "linear-gradient(to right, #00aaf0, #00ff00)",
    thickness: "5px",
    transition: {
        speed: "0.2s",
        opacity: "0.6s",
        termination: 300,
    },
    autoRevert: true,
    location: "top",
    inverse: false,
};


import App from "./App.vue";
import {defineGlobalComponents} from "./global-components";

const app = createApp(App);
defineGlobalComponents(app);
app.config.globalProperties.emitter = emitter;
app.config.globalProperties.$errors = ValidationErrors;
app.directive("click-outside", detectOutsideClick)
    .use(i18n)
    .use(progressbar, progressbarOptions)
    .use(Toast, toastOptions)
    .use(router)
    .use(store)
    .mount("#app");
