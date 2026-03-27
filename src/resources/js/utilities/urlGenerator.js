import coreAppFunction from "@/core/global/helpers/app/coreAppFunction";

export const urlGenerator = (url) => {
    if (!url || typeof url !== 'string') {
        return '';
    }

    return url.includes(coreAppFunction.baseUrl()) ? url : `${coreAppFunction.baseUrl()}/${url.split('/').filter(d => d).join('/')}`;
};
