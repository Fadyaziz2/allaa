<template>
    <div class="content-wrapper">
        <app-breadcrumb :page-title="$t('customer_import')" />
        <div class="row mt-5 ">
            <div class="col-md-12">
                <div class="top-info">
                    <h5>The field labels marked with * are required input fields</h5>
                    <p class="m-0 mt-3">The correct column order is (image, name*, code*, type*, brand, category*,
                        unit_code*, cost*, price*,
                        product_details, variant_name, item_code, additional_price) and you must follow this.</p>
                </div>
            </div>
        </div>
        <form action="">
            <div class="row mt-5 ">
                <div class="col-md-6 import">
                    <p class="label">
                        Field must be in <span>CSV</span> format
                    </p>
                    <p>
                        <input type="file" class="import-file">
                    </p>
                    <p class="mt-4">
                        sample file <br>
                        <button type="submit" class="btn btn-success text-white my-3">
                            <i class="bi bi-box-arrow-down"></i> Download</button>
                    </p>
                </div>
                <div class="col-md-6">
                    <div class="right-info">
                        <div class="rows">
                            <div class="items">
                                <div class="badge">This field is required</div>
                            </div>
                        </div>
                        <div class="rows">
                            <div class="items">
                                <div class="badge">This field is required</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-12">
                    <div class="form-group mt-4">
                        <button type="submit" class="btn btn-primary-without-outline me-2 border-0"> Cancel</button>
                        <button type="submit" class="btn btn-primary">Submit</button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</template>
<script>
import { useI18n } from 'vue-i18n';
export default {
    setup() {
        const { t } = useI18n();
    }
}
</script>

<style scoped lang="scss">
.top-info {
    padding: 25px;
    background-color: var(--jumbotron);
    border-radius: 10px;

    h5 {
        font-size: 18px;
        color: var(--font-color);
    }

    p {
        font-size: 14px;
        color: var(--font-color);
    }
}

.import {
    .label {
        font-size: 14px;

        span {
            font-weight: bold;
        }
    }

    .import-file {
        &::file-selector-button {
            margin-right: 20px;
            border: none;
            background: var(--primary);
            padding: 10px 20px;
            border-radius: 10px;
            color: var(--white);
            cursor: pointer;
        }
    }


}

.right-info {
    padding: 25px;
    background: var(--import-board);
    border-radius: 10px;

    .rows {
        display: flex;
        align-items: center;
        column-gap: 15px;
        padding: 15px 0;
        border-bottom: 1px solid var(--btn-secondary-bg);

        &:nth-child(3) {
            .items:nth-child(2) {
                .badge {
                    border-color: var(--primary);
                    color: var(--primary);
                }
            }
        }

        .items {
            font-size: 12px;

            &:nth-child(1) {
                min-width: 75px;
            }

            label {
                font-size: 12px;
            }

            .badge {
                font-size: 12px;
                border-radius: 4px;
                border: 1px solid var(--success);
                padding: 5px 10px;
                color: var(--success);
            }

        }
    }
}
</style>
