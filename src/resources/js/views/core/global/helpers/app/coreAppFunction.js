export default class coreAppFunction {
    static baseUrl() {
        const appUrl = window.localStorage.getItem('base_url');
        const metaUrl = document.querySelector('meta[name="app-base-url"]')?.getAttribute('content');
        const url = metaUrl || appUrl || window.location.origin;

        return typeof url === "string" ? url.replace(/\/+$/, '') : window.location.origin;
    }

    static getAppUrl(path) {
        return `${this.baseUrl()}/${path}`;
    }

    static getQueryStringValue(key) {
        const urlParams = new URLSearchParams(window.location.search);
        return urlParams.get(key);
    }

    static isFunction(func) {
        return typeof func === "function";
    }

    static isUndefined(obj) {
        return typeof obj === "undefined";
    }

    static splitNameBySlas(item) {
        if (typeof item !== "string") {
            return "";
        }
        if (item.includes("/")) {

            let itemArr = item.split("/");
            return itemArr[itemArr.length - 1];
        }
        return item;
    }
}
