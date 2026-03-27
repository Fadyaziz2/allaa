import coreAppFunction from "@/core/global/helpers/app/coreAppFunction";

export const urlGenerator = (url) => {
    return url.includes(coreAppFunction.baseUrl()) ? url : `${coreAppFunction.baseUrl()}/${url.split('/').filter(d => d).join('/')}`;
};
