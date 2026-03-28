<template>
    <nav
        ref="SideBarNav"
        class="sidebar sidebar-off-canvas custom-scrollbar"
        id="sidebar">
        <div class="border-bottom sidebar-logo-section">
            <router-link
                :to="{ name: 'dashboard' }"
                class="navbar-brand brand-logo"
                @click="menuChanged"
            >
                <img
                    v-if="sidebarStatus === 'open'"
                    :src="
                        settingInfo && settingInfo.company_logo
                            ? urlGenerator(settingInfo.company_logo)
                            : '/assets/images/logo.svg'
                    "
                    alt="brand-logo"
                />
                <img
                    v-else
                    class="brand-logo-mini"
                    :src="
                        settingInfo && settingInfo.company_logo
                            ? urlGenerator(settingInfo.company_icon)
                            : '/assets/images/favicon.svg'
                    "
                    alt="brand-icon"
                />
            </router-link>
        </div>
        <ul class="nav p-0 mt-2" id="linkContainer">
            <template v-for="(item, index) in sidebarData" :key="index">
                <li
                    v-if="item.permission === true && !item.submenu"
                    class="nav-item"
                    @click="menuChanged"
                >
                    <router-link
                        :to="item.id ? '#' + item.id : item.url"
                        class="nav-link fs-6 d-flex gap-3"
                        @click="sidebarOffCanvas"
                    >
                        <div class="icon-wrapper">
                            <i :class="item.icon"/>
                        </div>
                        <span v-if="!item.submenu" class="menu-title">{{
                                item.name
                            }}</span>
                    </router-link>
                </li>
                <li
                    v-if="item.permission && item.id && item.submenu"
                    class="nav-item nav-item-dropdown"
                    :class="{ 'dropdown dropend': sidebarStatus !== 'open' }"
                >
                    <a
                        class="nav-link collapsible fs-6 d-flex gap-3"
                        :class="{ active: activeMenu === item.id }"
                        :data-bs-toggle="
                            sidebarStatus === 'open' ? 'collapse' : 'dropdown'
                        "
                        :href="`#${item.id}`"
                        role="button"
                        aria-expanded="false"
                        :aria-controls="item.id"
                    >
                        <div class="icon-wrapper">
                            <i :class="item.icon"/>
                        </div>
                        <div
                            class="w-100 d-flex justify-content-between align-items-center menu-title"
                        >
                            <span>{{ item.name }}</span>
                            <i class="bi bi-chevron-down"/>
                        </div>
                    </a>
                    <div
                        class="sidebarDropdownItems pb-2"
                        :class="{
                            collapse: sidebarStatus === 'open',
                            'dropdown-menu shadow-sm border-0':
                                sidebarStatus !== 'open',
                            'show ':
                                sidebarStatus === 'open' &&
                                activeMenu === item.id,
                        }"
                        data-bs-parent="#linkContainer"
                        :style="
                            sidebarStatus === 'open'
                                ? `position: relative;inset: none;margin: 0px;transform: none`
                                : ''
                        "
                        :id="item.id"
                    >
                        <ul class="nav flex-column sub-menu my-0">
                            <template v-for="menu in item.submenu">
                                <li v-if="menu.permission"
                                    class="nav-item"
                                    @click="activeMenu = item.id">
                                    <router-link
                                        :to="menu.url"
                                        class="nav-link"
                                    >
                                        <div class="dot-icon">
                                            <i class="bi bi-circle-fill"/>
                                        </div>
                                        <span class="submenu-title">{{
                                                menu.name
                                            }}</span>
                                    </router-link>
                                </li>
                            </template>
                        </ul>
                    </div>
                </li>
            </template>
        </ul>
    </nav>
</template>

<script setup>
import {ref, onMounted, computed} from "vue";
import store from "@store/index";
import {urlGenerator} from "@utilities/urlGenerator";
import {useI18n} from "vue-i18n";
import {Collapse} from "bootstrap";
import usePermission from "@/core/global/composable/usePermission";

const {canAccess} = usePermission();

const {t} = useI18n();
const sidebarData = ref([
    {
        url: "/dashboard",
        icon: "bi bi-pie-chart-fill",
        name: t("dashboard"),
        permission: true,
    },
    {
        icon: "bi bi-people-fill",
        name: t("administrator"),
        permission: canAccess("view_users"),
        id: "administrator",
        submenu: [
            {
                url: "/users",
                name: t("users"),
                permission: canAccess("view_users"),
            },
            {
                url: "/roles",
                name: t("roles"),
                permission: canAccess("view_roles"),
            },
        ]
    },

    {
        icon: "bi bi-box-seam-fill",
        name: t("products"),
        permission:
            canAccess("view_products") ||
            canAccess("view_units") ||
            canAccess("view_categories"),
        id: "products",
        submenu: [
            {
                url: "/products",
                name: t("product_list"),
                permission: canAccess("view_products"),
            },
            {
                url: "/categories",
                name: t("categories"),
                permission: canAccess("view_categories"),
            },
            {
                url: "/units",
                name: t("units"),
                permission: canAccess("view_units"),
            },
            {
                url: "/wastages",
                name: t("wastages"),
                permission: canAccess("view_products"),
            },
        ],
    },
    {
        url: "/customers",
        icon: "bi bi-person-vcard-fill",
        name: t("customers"),
        permission: canAccess("view_customers"),
    },
    {
        icon: "bi bi-clipboard2-pulse-fill",
        name: t("estimates"),
        id: "estimates",
        permission: canAccess("view_estimates") || canAccess("create_estimates"),
        submenu: [
            {
                url: "/create-quotation",
                name: t("add_estimate"),
                permission: canAccess("create_estimates"),
            }, {
                url: "/quotations",
                name: t("estimates"),
                permission: canAccess("view_estimates"),
            },
        ]
    },
    {
        icon: "bi bi-stickies-fill",
        name: t("invoices"),
        permission:
            canAccess("create_invoices") ||
            canAccess("view_invoices") ||
            canAccess("invoice_view_recurring"),
        id: "invoices",
        submenu: [
            {
                url: "/create-invoice",
                name: t("add_invoice"),
                permission: canAccess("create_invoices"),
            },
            {
                url: "/invoices",
                name: t("invoices"),
                permission: canAccess("view_invoices"),
            },
            {
                url: "/recurring-invoices",
                name: t("recurring_invoices"),
                permission: canAccess("invoice_view_recurring"),
            },
        ],
    },

    {
        url: "/transactions",
        icon: "bi bi-credit-card-2-front-fill",
        name: t("transactions"),
        permission: canAccess("view_transactions"),
    },
    {
        icon: "bi bi-dash-square-fill",
        name: t("expenses"),
        permission: canAccess("view_expenses") || canAccess("view_categories"),
        id: "expenses",
        submenu: [
            {
                url: "/expenses",
                name: t("all_expenses"),
                permission: canAccess("view_expenses"),
            },
            {
                url: "/expense/category",
                name: t("expense_category"),
                permission: canAccess("view_categories"),
            },
        ],
    },
    {
        icon: "bi bi-arrow-up-square-fill",
        name: t("imports"),
        permission: canAccess("product_import") || canAccess("expense_import"),
        id: "import",
        submenu: [
            {
                url: "/product-import",
                name: t("product_import"),
                permission: canAccess("product_import"),
            },
            {
                url: "/expense-import",
                name: t("expense_import"),
                permission: canAccess("expense_import"),
            },
        ],
    },
    {
        icon: "bi bi-clipboard-data-fill",
        name: t("reports"),
        permission:
            canAccess("payment_report_view") ||
            canAccess("transaction_report_view") ||
            canAccess("expense_report_view"),
        id: "reports",
        submenu: [
            {
                url: "/payment-report",
                name: t("payment_report"),
                permission: canAccess("payment_report_view"),
            },
            {
                url: "/transaction-report",
                name: t("transaction_report"),
                permission: canAccess("transaction_report_view"),
            },
            {
                url: "/income-report",
                name: t("income_report"),
                permission: canAccess("income_report_view"),
            },
            {
                url: "/expense-report",
                name: t("expense_report"),
                permission: canAccess("expense_report_view"),
            },
        ],
    },
    {
        url: "/notifications",
        icon: "bi bi-envelope-at-fill",
        name: t("email_templates"),
        permission: canAccess("view_notification_type"),
    },
    {
        icon: "bi bi-gear-fill",
        name: t("settings"),
        permission:
            canAccess("view_setting") ||
            canAccess("check_verify_update"),
        id: "settings",
        submenu: [
            {
                url: "/settings",
                name: t("app_setting"),
                permission: canAccess("view_setting"),
            },
            {
                url: "/app-update",
                name: t("update_app"),
                permission: canAccess("check_verify_update"),
            },
        ],
    },
]);
const activeMenu = ref("");
const sidebarStatus = computed(() => store.getters["setting/sidebarStatus"]);
const menuChanged = (e) => {
    const togglableMenu = document.querySelector(".collapse.show");
    if (togglableMenu) {
        const collapseInstance = Collapse.getInstance(togglableMenu);
        if (collapseInstance) {
            collapseInstance.hide();
        } else {
            new Collapse(togglableMenu).hide();
        }
    }
    activeMenu.value = "";
};

const settingInfo = computed(() => store.getters["setting/setting"]);
const SideBarNav = ref();
onMounted(() => {
    let element = SideBarNav.value.querySelectorAll(
        '[data-bs-toggle="collapse"]'
    );

    element.forEach((e) => {
        let sibling = e.nextElementSibling;
        if (sibling.classList.contains("collapse")) {
            const child = sibling.querySelectorAll("li .active");
            if (child.length) {
                activeMenu.value = e.getAttribute("aria-controls");
            }
        }
    });
});
const sidebarOffCanvas = (e, type = null) => {
    const sidebar = document.querySelector(".sidebar-off-canvas.active");
    if (sidebar) sidebar.classList.remove("active");
};
</script>

<style lang="scss">
.sidebar.sidebar-off-canvas {
    .sidebar-overlay {
        display: none;
        opacity: 0;
    }

    .sidebar-logo-section {
        margin-top: 0.15rem !important;
    }

    @media (max-width: 991px) {
        &.active + {
            .sidebar-overlay {
                display: block;
                position: fixed;
                backdrop-filter: blur(1px);
                height: 100%;
                width: 100%;
                background: var(--sidebar-open-overlay-color);
                z-index: 201;
                animation: fadeInOutAnimation 0.25s linear;
            }
        }
    }
}

.rtl {
    .sidebar.sidebar-off-canvas {
        .sidebar-overlay {
            display: none;
        }

        &.active {
            @media (max-width: 991px) {
                .sidebar-overlay {
                    display: block !important;
                    position: fixed;
                    backdrop-filter: blur(1px);
                    left: 0;
                    top: 0;
                    bottom: 0;
                    right: 240px;
                    background: var(--sidebar-open-overlay-color);
                }
            }
        }
    }
}

@keyframes fadeInOutAnimation {
    0% {
        opacity: 0;
    }

    100% {
        opacity: 1;
    }
}
</style>
