<template>
    <div>
        <div
            class="dropdown-menu dropdown-menu-lg-end custom-scrollbar"
            id="shortcutDropdown"
            aria-labelledby="shortcutDropdown"
        >
            <ul class="linkItems">
                <li v-if="canAccess('create_products')">
                    <a
                        @click.prevent="isProductModalActive = true"
                        href="#"
                        class="d-flex align-items-center"
                    >
                        <i class="bi bi-box-seam-fill me-2 fs-5"></i>
                        {{ $t("add_product") }}
                    </a>
                </li>
                <li v-if="canAccess('create_customers')">
                    <a
                        @click.prevent="isCustomerModalActive = true"
                        href="#"
                        class="d-flex align-items-center"
                    >
                        <i class="bi bi-person-vcard-fill me-2 fs-5"></i>
                        {{ $t("add_customer") }}
                    </a>
                </li>
                <li v-if="canAccess('create_invoices')">
                    <router-link
                        :to="{ name: 'createInvoice' }"
                        class="d-flex align-items-center"
                    >
                        <i class="bi bi-stickies-fill me-2 fs-5"></i>
                        {{ $t("create_invoice") }}
                    </router-link>
                </li>
                <li v-if="canAccess('create_estimates')">
                    <router-link
                        :to="{ name: 'CreateEstimates' }"
                        class="d-flex align-items-center"
                    >
                        <i class="bi bi-calculator-fill me-2 fs-5"></i>
                        {{ $t("add_estimate") }}
                    </router-link>
                </li>
            </ul>
        </div>
        <product-modal
            v-if="isProductModalActive"
            table-id="product-table"
            modal-id="product-modal"
            :selected-url="selectedData"
            @close="closeModal"
        />

        <customer-modal
            v-if="isCustomerModalActive"
            table-id="customer-table"
            :selected-url="selectedData"
            modal-id="customer-modal"
            @close="closeModal"
        />
    </div>
</template>
<script setup>
import productModal from "@/invoice/product/ProductModal.vue";
import customerModal from "@/invoice/customer/CustomerModal.vue";
import { ref } from "vue";
import usePermission from "@/core/global/composable/usePermission";
const {canAccess} = usePermission();

const isCustomerModalActive = ref(false);
const selectedData = ref("");
const isProductModalActive = ref(false);
const closeModal = () => {
    isProductModalActive.value = false;
    isCustomerModalActive.value = false;
};
</script>
<style lang="scss" scoped>
.dropdown-menu {
    border-radius: var(--round-default);
    min-width: 170px;

    @media (min-width: 580px) {
        min-width: 320px;
    }

    .linkItems {
        padding: 15px;
        display: flex;
        flex-wrap: wrap;
        align-items: center;
        justify-content: center;
        row-gap: 5px;

        li {
            list-style: none;
            flex-basis: 50%;

            @media (max-width: 580px) {
                flex-basis: 100%;
            }
        }

        a {
            display: block;
            padding: 5px 8px;
            color: var(--font-color);
            border-radius: 4px;
            i{
               color: var(--menubar-font-color);
            }
            &:hover {
                color: var(--primary);
                background: var(--base-color);
                i{
                    color: var(--primary);
                }
            }
        }
    }
}
</style>
