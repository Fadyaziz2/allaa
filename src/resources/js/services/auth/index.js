import axios from "axios";
import {urlGenerator} from "@utilities/urlGenerator";
import router from "@router";
import {LOGIN_API} from "@services/endpoints";
import {removePermission} from "@utilities/permission";

export const useAuth = () => {
    const login = (payload) => {
        return axios.post(urlGenerator(LOGIN_API), payload)
    }
    const logout = () => {
        localStorage.removeItem('access_token')
        removePermission();
        router.push({name: 'login'})
    }

    return {logout, login}

}
