import axios from "axios";
import coreAppFunction from "@/core/global/helpers/app/coreAppFunction";
import {getToken} from "@utilities/token";
import {useAuth} from "@services/auth";
import {useToast} from "vue-toastification";
import router from "@router/index";

const toast = useToast();
const {logout} = useAuth();

const instance = axios.create({
    headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
    },
});

instance.defaults.timeout = 10000;
instance.defaults.baseURL = coreAppFunction.baseUrl();
instance.interceptors.request.use(
    async (config) => {
        const token = getToken()
        if (!token) {
            logout();
        } else {
            config.headers.Authorization = `Bearer ${token}`
            return config;
        }
    },

    (error => Promise.reject(error))
);

instance.interceptors.response.use(function (response) {
    // Any status code that lie within the range of 2xx cause this function to trigger
    // Do something with response data
    return response;
}, function (error) {
    if (error.response.status === 401) {
        logout();
    }
    if (error.response.status === 424) {
        toast.error('Failed to create the resource due to a dependency failure. Please make sure all required dependencies are fulfilled.');
    }
    if (error.response.status === 419) {
        router.push({name: '419'})
    }
    if (error.response.status === 403) {
        let message = error.response.data.message + ' for '+ error.response.data.result;
        toast.error(message);
    }
    // Any status codes that falls outside the range of 2xx cause this function to trigger
    // Do something with response error
    return Promise.reject(error);
});

export default instance;
