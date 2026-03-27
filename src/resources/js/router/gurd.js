import {getToken} from "@utilities/token";

export const alreadyLogin = (to, from, next) => {
    if (getToken()) {
        next();
    } else {
        next({name: "login"})
    }
}
export const notLoginYet = (to, from, next) => {
    if (getToken()) {
        next({name: "dashboard"})
    } else {
        next();
    }
}
