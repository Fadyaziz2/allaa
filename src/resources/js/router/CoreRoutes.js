import {alreadyLogin, notLoginYet} from "@router/gurd";
import usePermission from "@/core/global/composable/usePermission";

const {canAccess} = usePermission();

export default [
    {
        path: "/installation",
        component: () => import("@/core/components/installer/Layout.vue"),
        beforeEnter: [notLoginYet],
        children: [
            {
                path: "",
                name: "installation",
                component: () =>
                    import("@/core/components/installer/Installation.vue"),
            },
            {
                path: "/environment/setup",
                name: "environmentSetup",
                component: () =>
                    import(
                        "@/core/components/installer/EnvironmentSetup.vue"
                        ),
            },
            {
                path: "/user-info/setup",
                name: "userInfoSetup",
                component: () =>
                    import("@/core/components/installer/UserInfo.vue"),
            },
            {
                path: "/company/setup",
                name: "companySetup",
                component: () =>
                    import("@/core/components/installer/CompanySetup.vue"),
            },
            {
                path: "/email/setup",
                name: "emailSetup",
                component: () =>
                    import("@/core/components/installer/EmailSetup.vue"),
            },
        ],
    },
    {
        path: '/:catchAll(.*)',
        name: 'notFound',
        component: () => import("@/core/components/errors/404.vue")
    },
    {
        path: "/404",
        name: "404",
        component: () => import("@/core/components/errors/404.vue"),
    },
    {
        path: "/403",
        name: "403",
        component: () => import("@/core/components/errors/403.vue"),
    },
    {
        path: "/login",
        name: "login",
        component: () => import("@/core/components/auth/Login.vue"),
        beforeEnter: [notLoginYet],
    },

    {
        path: "/forget-password",
        name: "forgetPassword",
        component: () => import("@/core/components/auth/ForgetPassword.vue"),
        beforeEnter: [notLoginYet],
    },
    {
        path: "/confirm-password",
        name: "confirmPassword",
        component: () => import("@/core/components/auth/ConfirmPassword.vue"),
        beforeEnter: [notLoginYet],
    },
    {
        path: "/user-join",
        name: "userJoin",
        component: () => import("@/core/components/auth/UserJoin.vue"),
        beforeEnter: [notLoginYet],
    },
    {
        path: "/",
        component: () => import("@/core/layout/Layout.vue"),
        beforeEnter: [alreadyLogin],
        children: [
            {
                path: "",
                redirect: {name: "dashboard"},
            },
            {
                path: "profiles",
                name: "myProfile",
                component: () =>
                    import("@/core/components/profile/MyProfile.vue"),
            },
            {
                path: "dashboard",
                name: "dashboard",
                component: () =>
                    import("@/core/components/dashboard/Index.vue"),
            },
            {
                path: "users",
                name: "users",
                component: () =>
                    import("@/core/components/user/UserList.vue"),
                meta: {
                    hasPermission: () => canAccess("view_users"),
                },
            },
            {
                path: "settings",
                name: "setting",
                component: () =>
                    import("@/core/components/setting/Index.vue"),
                meta: {
                    hasPermission: () => canAccess("view_setting"),
                },
            },
            {
                path: "roles",
                name: "roles",
                component: () =>
                    import("@/core/components/setting/roles/Index.vue"),
                meta: {
                    hasPermission: () => canAccess("view_roles"),
                },
            },
            {
                path: "notifications",
                name: "notifications",
                component: () =>
                    import(
                        "@/core/components/setting/notification/NotificationList.vue"
                        ),
                meta: {
                    hasPermission: () => canAccess("view_notification_type"),
                },
            },
            {
                path: "all-notifications",
                name: "AllNotification",
                component: () =>
                    import(
                        "@/core/components/notification/AllNotification.vue"
                        ),
                meta: {
                    hasPermission: () => canAccess("view_all_notifications"),
                },
            },
            {
                path: "app-update",
                name: "app-update",
                component: () =>
                    import("@/core/components/setting/update/AppUpdate.vue"),
                meta: {
                    hasPermission: () => canAccess("check_verify_update"),
                },
            },
        ],
    },
];
