export const LOGIN_API = "api/auth/login"
export const FORGET_PASSWORD = "api/users/password-reset"
export const CONFORM_PASSWORD = "api/users/confirm-password-reset"
export const USER_JOIN = "api/users/user-join"

// Profile
export const MY_PROFILE = "api/app/user/profile"
export const MY_PROFILE_UPDATE = "api/app/user/profile-update"
export const PASSWORD_CHANGE = "api/app/user/password-change"
export const UPDATE_PROFILE_PICTURE = "api/app/user/profile-picture"

//Users and role permission
export const USERS = "api/app/users"
export const USER_INVITE = "api/app/user-invite"
export const PERMISSIONS = "api/app/selectable/permissions"
export const ROLES = "api/app/roles"
export const DETACH_ROLE_USER = "api/app/detach/user-role"
export const ATTACH_ROLE_USER = "api/app/attach/user-role"
export const ROLE_WITHOUT_USER = "api/app/selectable/role/without-users"

//Settings
export const GENERAL_SETTING = "api/app/general-settings"
export const SETTING = "api/app/settings"
export const EMAIL_SETTINGS = "api/app/settings/email-settings"
export const EXIST_EMAIL_SETTINGS = "api/app/exist-mail-setup"
export const SEND_TEST_MAIL = "api/app/send-test-mail"
export const CRONJOB_SETTING = "api/app/cronjob-settings"


// Notification

export const NOTIFICATION_TYPE = "api/app/notification-type"
export const NOTIFICATION_TEMPLATE = "api/app/notification/template"
export const SELECTED_NOTIFICATION_TEMPLATE = "api/app/selectable/notification/template"
export const NOTIFICATIONS = "api/app/user/notifications"
export const READ_ALL_NOTIFICATIONS = "api/app/user/read-all-notifications"


//Selected
export const SELECTED_ROLE = "api/app/selectable/roles"

//Lang
export const LOCALES = `api/languages`
export const PUBLIC_SETTING = `api/app/public/settings`

//Payments
export const INITIATE_PAYMENT_API = 'api/payment/initiate'
export const PAYMENT_SUCCESS_API = 'api/payment/complete'
export const PAYMENT_FAILURE_API = 'api/payment/failure'
