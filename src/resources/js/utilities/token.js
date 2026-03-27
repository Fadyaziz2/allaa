export const getToken = () => {
    const token = localStorage.getItem("access_token");
    if (token) {
        const jwtPayload = parseJwt(token);
        if (jwtPayload.exp < Date.now() / 1000) {
            // token expired
            localStorage.removeItem('access_token');
            localStorage.removeItem('selectedTeam');
            localStorage.removeItem('authPermission');
            return null;
        }
        return token;
    }
}

export const setToken = (token) => {
    return localStorage.setItem("access_token", token)
}


export const parseJwt = (token) => {
    let base64Url = token.split('.')[1];
    let base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
    let jsonPayload = decodeURIComponent(window.atob(base64).split('').map(function (c) {
        return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
    }).join(''));

    return JSON.parse(jsonPayload);
}
