import coreAppFunction from "@/core/global/helpers/app/coreAppFunction";

export const useCoreAppFunction = () => {
    const isFunction = (func) => coreAppFunction.isFunction(func)
    const getAppUrl = (url) => coreAppFunction.getAppUrl(url)
    const isUndefined = (obj) => coreAppFunction.isUndefined(obj)
    const getQueryStringValue = (key) => coreAppFunction.getQueryStringValue(key);

    return {isFunction, getAppUrl, isUndefined, getQueryStringValue}
}
