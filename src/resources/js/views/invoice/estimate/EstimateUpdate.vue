<template>
    <div class="content-wrapper">
        <app-breadcrumb
            :page-title="$t('update_estimate')"
        />
        <app-loader v-if="pageLoader"></app-loader>
        <form v-else>
            <div class="row update-details p-3 mb-4 mx-0">
                <div class="col-md-4 mb-3">
                    <app-input
                        type="advance-search-select"
                        id="customer"
                        :label="$t('customer')"
                        label-required
                        listValueField="full_name"
                        v-model="formData.customer_id"
                        :loading-length="10"
                        :fetch-url="SELECTED_CUSTOMER"
                        :choose-label="$t('choose_a_customer')"
                        :errors="$errors(errors, 'customer_id')"
                    />
                </div>
                <div class="col-md-4 mb-3">
                    <app-input
                        type="date"
                        :label="$t('date')"
                        label-required
                        :placeholder="$t('date')"
                        v-model="formData.date"
                        :enable-time-picker="false"
                        auto-apply
                        :errors="$errors(errors, 'date')"
                    />
                </div>
                <div class="col-md-4 mb-3">
                    <label for="selectInvoice" class="mb-2"
                    >{{ $t("select_estimate_template") }}
                        <span class="text-danger">*</span></label
                    >
                    <button
                        class="btn btn-primary d-flex align-items-center gap-2 py-2"
                        @click.prevent="openInvoiceTempModal"
                    >
                        <template v-if="selectedInvoiceTemplate">
                            {{
                                invoiceTemplates.filter(
                                    (temp) => temp.id == selectedInvoiceTemplate
                                )[0].name
                            }}
                        </template>
                        <template v-else>
                            {{ $t("select_estimate_template") }}
                        </template>
                        <i class="bi bi-pencil-square"></i>
                    </button>
                </div>
                <div class="col-md-9 mb-3">
                    <app-input
                        type="advance-search-select"
                        id="products"
                        :label="$t('product')"
                        label-required
                        listValueField="name"
                        v-model="product_id"
                        :loading-length="10"
                        :fetch-url="SELECTED_PRODUCT"
                        :selected-disable="false"
                        :choose-label="$t('choose_a_product')"
                        @searchSelect="changeProduct($event)"
                    />
                </div>
                <div class="col-md-3 mb-3 d-flex justify-content-center flex-column" v-if="canAccess('create_products')">
                    <label class="invisible mb-2"> &nbsp; </label>
                    <button
                        type="submit"
                        class="btn btn-primary"
                        @click.prevent="isModalActive = true"
                    >
                        {{ $t("add_new_product") }}
                    </button>
                </div>

                <div class="col-12 mb-4 row align-items-center">
                    <div
                        class="labels col-12 row border-bottom p-3 product-table_head"
                    >
                        <div class="text-muted col-md-4">
                            {{ $t("products") }}
                        </div>
                        <div class="text-muted col-md-3">
                            {{ $t("quantity") }}
                        </div>
                        <div class="text-muted col-md-2">
                            {{ $t("unit_price") }}
                        </div>
                        <div class="text-muted col-md-2">
                            {{ $t("total_amount") }}
                        </div>
                        <div class="text-muted col-md-1 text-right">
                            {{ $t("action") }}
                        </div>
                    </div>
                    <div
                        v-for="(product, index) in productDetails"
                        class="row align-items-baseline justify-content-between align-items-center col-md-12 border-bottom px-3"
                        :key="index"
                    >
                        <div class="col-md-4">
                            <div
                                class="d-flex justify-content-between py-2 flex-wrap"
                            >
                                <div class="heading-title flex-1">
                                    Product Name:
                                </div>
                                <div class="flex-1">{{ product.name }}</div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div
                                class="d-flex justify-content-between align-items-center align-items-center py-2 flex-wrap"
                            >
                                <div class="heading-title flex-1">
                                    Product Qty:
                                </div>
                                <div
                                    class="d-flex align-items-center flex-1 gap-2"
                                >
                                    <a
                                        @click.prevent="
                                            quantityDecrement(
                                                product,
                                                product.quantity
                                            )
                                        "
                                        class="text-brand text-decoration-none fs-3 fw-bold cursor-pointer"
                                    >
                                        <i class="bi bi-dash-circle"></i>
                                    </a>
                                    <app-input
                                        type="text"
                                        :id="`${index}-quantity`"
                                        v-model="product.quantity"
                                        @input="changeQuantity(product)"
                                    />

                                    <a
                                        @click.prevent="
                                            quantityIncrement(product)
                                        "
                                        class="text-brand text-decoration-none fs-3 fw-bold cursor-pointer"
                                    >
                                        <i class="bi bi-plus-circle"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div
                                class="d-flex justify-content-between align-items-center py-2 flex-wrap"
                            >
                                <div class="heading-title flex-1">
                                    unit price:
                                </div>
                                <div class="flex-1">
                                    <app-input
                                        type="number"
                                        :id="`${index}-price`"
                                        v-model="product.price"
                                        @input="changePrice(product)"
                                    />
                                </div>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div
                                class="d-flex justify-content-between align-items-center py-2 flex-wrap"
                            >
                                <div class="heading-title flex-1">
                                    Total amount:
                                </div>
                                <div class="flex-1">
                                    {{
                                        numberWithCurrencySymbol(
                                            product.total_amount
                                        )
                                    }}
                                </div>
                            </div>
                        </div>

                        <div class="col-md-1">
                            <div
                                class="d-flex justify-content-between align-items-center py-2 flex-wrap"
                            >
                                <div class="heading-title flex-1">
                                    Delete this Product
                                </div>
                                <div class="flex-1">
                                    <a
                                        @click="removeCartItem(product, index)"
                                        class="cursor-pointer fs-25"
                                    >
                                        <i class="bi bi-trash text-danger"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row h-auto">
                <div class="col-lg-6 mb-4">
                    <div class="update-details p-4">
                        <div class="row">
                            <div class="col-md-6">
                                <app-input
                                    type="select"
                                    id="discount_type"
                                    :label="$t('choose_discount_type')"
                                    :options="discountTypeList"
                                    list-value-field="name"
                                    :choose-label="$t('choose_a_discount')"
                                    v-model="formData.discount_type"
                                    :errors="$errors(errors, 'discount_type')"
                                    @selectInput="selectDiscountType($event)"
                                />
                            </div>
                            <div class="col-md-6">
                                <app-input
                                    type="number"
                                    id="discount_amount"
                                    :label="$t('discount_amount')"
                                    :label-required="
                                        formData.discount_type ===
                                            'percentage' ||
                                        formData.discount_type === 'fixed'
                                    "
                                    v-model="formData.discount_amount"
                                    :placeholder="$t('discount_amount')"
                                    :disabled="
                                        !(
                                            formData.discount_type ===
                                                'percentage' ||
                                            formData.discount_type === 'fixed'
                                        )
                                    "
                                    :errors="$errors(errors, 'discount_amount')"
                                />
                            </div>
                            <div class="col-md-12">
                                <app-input
                                    type="advance-search-select"
                                    :fetchUrl="`${SELECTED_NOTE}?type=estimate`"
                                    listValueField="name"
                                    listKeyField="note"
                                    class="cursor-pointer d-flex justify-content-between align-items-center my-2"
                                    :label="$t('note')"
                                    label-class="mb-0"
                                    :selected-disable="false"
                                    :chooseLabel="$t('select_a_note')"
                                    @update:modelValue="
                                        (v) => (formData.note = v)
                                    "
                                />
                                <div class="w-100 position-relative">
                                    <app-input
                                        v-model="formData.note"
                                        type="editor"
                                    />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="update-details p-4">
                        <div class="d-flex">
                            <div class="col-6">
                                <h6 class="mb-0">{{ $t("subtotal") }}:</h6>
                            </div>
                            <div class="col-6 fw-bold">
                                {{ numberWithCurrencySymbol(totalUnitePrice) }}
                            </div>
                        </div>
                        <div class="d-flex">
                            <div class="col-6">
                                <h6 class="mb-0">{{ $t("discount") }}:</h6>
                            </div>
                            <div class="col-6 fw-bold">
                                {{
                                    numberWithCurrencySymbol(
                                        totalDiscountAmount
                                    )
                                }}
                            </div>
                        </div>
                        <div class="d-flex border-bottom pb-2 mb-2">
                            <div class="col-6">
                                <h6 class="mb-0">{{ $t("total") }}:</h6>
                            </div>
                            <div class="col-6 fw-bold">
                                {{
                                    numberWithCurrencySymbol(
                                        totalWithDiscountAmount
                                    )
                                }}
                            </div>
                        </div>
                        <div class="d-flex justify-content-between my-2">
                            <div class="col-6 d-flex align-items-center">
                                <h6 class="mb-0">{{ $t("tax") }}:</h6>
                            </div>
                            <div class="col-6">
                                <app-input
                                    type="select"
                                    id="taxes"
                                    listValueField="name"
                                    v-model="formData.tax_id"
                                    :options="taxList"
                                    @selectInput="addMoreTax($event)"
                                    :choose-label="$t('choose_a_taxes')"
                                />
                            </div>
                        </div>
                        <div
                            class="d-flex justify-content-between my-2"
                            v-for="(tax, taxIndex) in taxInfo"
                            :key="taxIndex"
                        >
                            <div class="name col-6 fs-14">
                                {{ tax.name }}({{ tax.rate }} %)
                            </div>

                            <div class="col-6 d-flex align-items-center">
                                <div class="tax-value fw-bold">
                                    {{
                                        numberWithCurrencySymbol(
                                            totalWithDiscountAmount *
                                            (tax.rate / 100)
                                        )
                                    }}
                                </div>

                                <div class="tax-remove mx-2">
                                    <a
                                        @click="removeTaxItem(tax, taxIndex)"
                                        class="cursor-pointer fs-15"
                                    >
                                        <i
                                            class="bi bi-trash text-danger cursor-pointer fs-4"
                                        ></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                        <div class="d-flex border-top pt-2 mt-2">
                            <div class="name col-6 fs-14">
                                <h6 class="mb-0">{{ $t("grand_total") }}:</h6>
                            </div>
                            <div class="col-6 fw-bold">
                                {{
                                    numberWithCurrencySymbol(
                                        totalTaxAppliedAmount
                                    )
                                }}
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row mt-3">
                    <div class="col-12 d-flex gap-3">
                        <button
                            class="btn btn-success text-white"
                            :disabled="sendPreloader || preloader"
                            @click.prevent="submit()"
                        >
                            <app-button-loader v-if="preloader"/>
                            <i class="bi bi-download"></i>
                            {{ $t("save") }}
                        </button>
                        <button
                            class="btn btn-primary"
                            :disabled="preloader || sendPreloader"
                            @click.prevent="submit('send')"
                        >
                            <app-button-loader v-if="sendPreloader"/>
                            <i class="bi bi-envelope-at-fill"></i>
                            {{ $t("save_and_send") }}
                        </button>
                    </div>
                </div>
            </div>
        </form>

        <product-modal
            v-if="isModalActive"
            table-id="product-table"
            modal-id="product-modal"
            :selected-url="selectedData"
            @close="closeModal"
        />

        <InvoiceTemplateChooseModal
            v-if="isInviteTemplateChooseModalActive"
            modal-id="InvoiceChooseModal"
            :invoice-templates="invoiceTemplates"
            @close="closeInvoiceTempModal"
            v-model="selectedInvoiceTemplate"
        />
    </div>
</template>

<script setup>
import {computed, onMounted, reactive, ref} from "vue";

const {canAccess} = usePermission();

import {
    SELECTED_CUSTOMER,
    SELECTED_PRODUCT,
    SELECTED_NOTE,
    SELECTED_TAXES,
    ESTIMATES,
} from "@services/endpoints/invoice";
import {useOpenModal} from "@/core/global/composable/modal/useOpenModal";
import ProductModal from "@/invoice/product/ProductModal.vue";
import InvoiceTemplateChooseModal from "@/invoice/Invoice/InvoiceTemplateChooseModal.vue";
import {numberWithCurrencySymbol} from "@utilities/helpers";
import {useI18n} from "vue-i18n";
import Axios from "@services/axios";
import moment from "moment/moment";
import {useToast} from "vue-toastification";
import usePermission from "@/core/global/composable/usePermission";

const props = defineProps({
    id: {},
});
const {t} = useI18n();
const {isModalActive, selectedData, closeModal} = useOpenModal();

const formData = ref({});
const errors = ref({});

const product_id = ref(null);

const productDetails = ref([]);
const changeProduct = (item) => {
    if (item) {
        const checkProduct = productDetails.value.find(
            (p) => p.product_id == item.id
        );
        if (checkProduct) {
            checkProduct.quantity++;
            checkProduct.total_amount =
                checkProduct.quantity * checkProduct.price;
        } else {
            productDetails.value.push({
                product_id: item.id,
                name: item.name,
                quantity: 1,
                price: item.price,
                total_amount: item.price,
            });
        }
    }
};

const changeQuantity = (product) => {
    if (Number(product.quantity) > 0) {
        product.total_amount = Number(product.price * product.quantity);
    } else {
        product.quantity = 1;
    }
};

const quantityIncrement = (productInfo) => {
    let data = productDetails.value.find(
        (product) => product.product_id === productInfo.product_id
    );
    productInfo.total_amount = Number(data.price * ++data.quantity);
};
const quantityDecrement = (productInfo, quantity) => {
    if (Number(quantity) > 1) {
        const data = productDetails.value.find(
            (product) => product.product_id === productInfo.product_id
        );
        productInfo.total_amount = Number(data.price * --data.quantity);
    } else {
        productInfo.quantity = 1;
    }
};

const changePrice = (product) =>
    (product.total_amount = Number(product.price * product.quantity));

const removeProduct = ref([]);
const removeCartItem = (product, index) => {
    if (product.id) {
        removeProduct.value.push(product.id);
    }
    productDetails.value.splice(index, 1);
};

const totalUnitePrice = computed(() => {
    let subTotal = 0;
    productDetails.value.forEach(
        (item) => (subTotal += Number(item.quantity * item.price))
    );
    return subTotal;
});

const totalDiscountAmount = computed(() => {
    if (formData.value.discount_type === "fixed" && formData.value.discount_amount > 0) {
        return Number(formData.value.discount_amount);
    } else if (formData.value.discount_type === "percentage" && formData.value.discount_amount > 0) {
        return Number((totalUnitePrice.value * formData.value.discount_amount) / 100);
    } else {
        formData.value.discount_amount = null;
        return 0;
    }
});

const totalWithDiscountAmount = computed(() =>
    Number(totalUnitePrice.value - totalDiscountAmount.value)
);

const taxInfo = ref([]);
const addMoreTax = (tax) => {
    if (tax) {
        const checkTax = taxInfo.value.find((item) => item.tax_id == tax.id);
        if (checkTax) {
            toast.error(t("tax_has_been_applied_already"));
        } else {
            taxInfo.value.push({
                tax_id: tax.id,
                name: tax.name,
                rate: tax.rate,
            });
        }
    }
};

const removeTax = ref([]);
const removeTaxItem = (tax, index) => {
    if (tax.id) {
        removeTax.value.push(tax.id);
    }
    taxInfo.value.splice(index, 1);
};

const totalTaxAppliedAmount = computed(() => {
    let total = 0;
    taxInfo.value.forEach(
        (item) =>
            (total += Number(totalWithDiscountAmount.value * (item.rate / 100)))
    );
    return Number(totalWithDiscountAmount.value + total);
});

const discountTypeList = reactive([
    {
        id: "fixed",
        name: t("fixed"),
    },
    {
        id: "percentage",
        name: t("percentage"),
    },
]);

const invoiceTemplates = ref([
    {
        id: 1,
        name: t("template_one"),
        image: "/assets/images/estimate.png",
    },
    {
        id: 2,
        name: t("template_two"),
        image: "/assets/images/estimate-2.png",
    },
    {
        id: 3,
        name: t("template_three"),
        image: "/assets/images/estimate-3.png",
    },
]);
const isInviteTemplateChooseModalActive = ref(false);
const selectedInvoiceTemplate = ref(1);
const openInvoiceTempModal = () => {
    isInviteTemplateChooseModalActive.value = true;
};
const closeInvoiceTempModal = () => {
    isInviteTemplateChooseModalActive.value = false;
};

const toast = useToast();
const preloader = ref(false);
const sendPreloader = ref(false);
const submit = (type = null) => {
    if (!productDetails.value.length) {
        toast.error(t("select_at_least_one_product"));
        return;
    }
    let data = {
        ...formData.value,
        date: formData.value.date
            ? moment(formData.value.date).format("YYYY-MM-DD")
            : null,
        sub_total: totalUnitePrice.value,
        total_amount: totalWithDiscountAmount.value,
        grand_total: totalTaxAppliedAmount.value,
        products: productDetails.value,
        taxes: taxInfo.value,
        estimate_template: selectedInvoiceTemplate.value,
        submit_type: type,
    };
    type ? (sendPreloader.value = true) : (preloader.value = true);
    if (props.id) {
        if (removeProduct.value) {
            data.remove_product = removeProduct.value;
        }
        if (removeTax.value) {
            data.remove_tax = removeTax.value;
        }
        Axios.patch(`${ESTIMATES}/${props.id}`, data)
            .then(({data}) => {
                toast.success(data?.message);
                formData.value.tax_id = null;
                errors.value = {};
            })
            .catch(({response}) => {
                if (response.status === 422)
                    errors.value = response?.data?.errors;
                else {
                    toast.error(response?.data?.message);
                }
            })
            .finally(() =>
                type ? (sendPreloader.value = false) : (preloader.value = false)
            );
    }
};
const resetData = () => {
    formData.value = {
        note: null,
        tax_id: null,
    };
    product_id.value = "";
    productDetails.value = [];
    taxInfo.value = [];
    errors.value = {};
};
const taxList = ref([]);
const getTax = () => {
    Axios.get(SELECTED_TAXES).then(({data}) => {
        taxList.value = data;
    });
};

const pageLoader = ref(false);
const getEstimateEditData = () => {
    pageLoader.value = true;
    Axios.get(`${ESTIMATES}/${props.id}`)
        .then(({data}) => {
            formData.value = data;
            selectedInvoiceTemplate.value = data.estimate_template;
            productDetails.value = data.estimate_details.map((item) => {
                return {
                    id: item.id,
                    product_id: item.product_id,
                    name: item?.product?.name,
                    quantity: item.quantity,
                    price: item.price,
                    total_amount: item.price * item.quantity,
                };
            });
            taxInfo.value = data.taxes.map((taxItem) => {
                return {
                    id: taxItem.id,
                    tax_id: taxItem.tax_id,
                    name: taxItem.tax?.name,
                    rate: taxItem.tax?.rate,
                };
            });
        })
        .finally(() => (pageLoader.value = false));
};

const selectDiscountType = (type) => {
    formData.value.discount_amount = null;
};

onMounted(() => {
    getTax();
    if (props.id) {
        getEstimateEditData();
    }
});
</script>

<style lang="scss">
.product-table_head {
    @media (max-width: 768px) {
        display: none;
    }
}

.heading-title {
    display: none;

    @media (max-width: 768px) {
        display: block;
    }
}

.flex-1 {
    flex: 1;
}
</style>
