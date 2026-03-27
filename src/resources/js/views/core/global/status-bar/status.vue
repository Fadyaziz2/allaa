<template>
    <div>
        <div class="status-bar">

            <!-- card items  -->

            <div class="items">
                <div class="left">
                    <div class="icon-box">
                        <i class="bi bi-receipt"></i>
                    </div>
                </div>
                <div class="right">
                    <div class="total">Total</div>
                    <div class="invoices"><b>24</b><span class="ms-2">Invoices</span></div>
                    <div class="amount">$275.43</div>
                </div>
            </div>
            <div class="items">
                <div class="left">
                    <div class="icon-box">
                        <i class="bi bi-check-circle-fill"></i>
                    </div>
                </div>
                <div class="right">
                    <div class="total">paid</div>
                    <div class="invoices"><b>4</b><span class="ms-2">Invoices</span></div>
                    <div class="amount">$446.26</div>
                </div>
            </div>
            <div class="items">
                <div class="left">
                    <div class="icon-box">
                        <i class="bi bi-clock-fill"></i>
                    </div>
                </div>
                <div class="right">
                    <div class="total">unpaid</div>
                    <div class="invoices"><b>8</b><span class="ms-2">Invoices</span></div>
                    <div class="amount">$490</div>
                </div>
            </div>
            <div class="items">
                <div class="left">
                    <div class="icon-box">
                        <i class="bi bi-bell-fill"></i>
                    </div>
                </div>
                <div class="right">
                    <div class="total">overdue</div>
                    <div class="invoices"><b>8</b><span class="ms-2">Invoices</span></div>
                    <div class="amount">$601.43</div>
                </div>
            </div>
            <div class="items">
                <div class="left">
                    <div class="icon-box">
                        <i class="bi bi-file-earmark-fill"></i>
                    </div>
                </div>
                <div class="right">
                    <div class="total">draft</div>
                    <div class="invoices"><b>4</b><span class="ms-2">Invoices</span></div>
                    <div class="amount">$739.43</div>
                </div>
            </div>

        </div>
    </div>
</template>

<style lang="scss">
.status-bar {
    display: flex;
    flex-wrap: wrap;
    background-color: var(--card-color);
    padding: 20px;
    box-shadow: var(--box-shadow);
    border-radius: 10px;
    gap: 8px;
    margin: 15px 0;
    @media(max-width:600px) {
        flex-direction: column;
    }

    .items {
        flex-basis: 19%;
        padding: 0 8px;
        gap: 10px;
        display: flex;
        align-items: center;
        justify-content: space-between;

        @media(max-width:1024px) {
            flex-basis: auto;
        }

        @media(max-width:960px) {
            flex-basis: 32.5%;
            padding: 7px;
            border: 1px dashed var(--border-color);
        }

        @media(max-width:768px) {
            flex-basis: 49%;
            padding: 7px;
            border: 1px dashed var(--border-color);
        }

        &:not(:last-child) {
            border-right: 1px dashed var(--border-color);
        }

        .left {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;

            .icon-box {
                height: 60px;
                width: 60px;
                border-radius: 50%;
                border: 5px solid var(--primary);
                border-top-color: var(--bs-gray-300);
                display: flex;
                align-items: center;
                justify-content: center;
                transform: rotate(-45deg);
                opacity: 0.6;

                i {
                    font-size: 1.7rem;
                    transform: rotate(45deg);
                    color: var(--bs-brand);
                }
            }
        }

        .right {
            flex: 1;
            row-gap: 6px;
            display: flex;
            flex-direction: column;

            @media(max-width:768px){
                row-gap: 2px;
            }

            .total {
                font-weight: bolder;
                font-size: 18px;
                color: var(--font-color);
                text-transform: capitalize;
            }

            .invoices {
                color: var(--bs-gray-500);

                b {
                    color: var(--font-color);
                }
            }

            .amount {
                color: var(--primary);
                font-size: 16px;
                font-weight: 500;
            }
        }

        &:nth-child(2) {
            .left {
                .icon-box {
                    border: 5px solid var(--success);
                    border-top-color: var(--bs-gray-300);

                    i {
                        color: var(--success);
                    }
                }
            }

            .right {
                .amount {
                    color: var(--success);
                }
            }
        }

        &:nth-child(3) {
            .left {
                .icon-box {
                    border: 5px solid var(--warning);
                    border-top-color: var(--bs-gray-300);

                    i {
                        color: var(--warning);
                    }
                }
            }

            .right {
                .amount {
                    color: var(--warning);
                }
            }
        }

        &:nth-child(4) {
            .left {
                .icon-box {
                    border: 5px solid var(--danger);
                    border-top-color: var(--bs-gray-300);

                    i {
                        color: var(--danger);
                    }
                }
            }

            .right {
                .amount {
                    color: var(--danger);
                }
            }
        }

        &:nth-child(5) {
            .left {
                .icon-box {
                    border: 5px solid var(--secondary);
                    border-top-color: var(--bs-gray-300);
                    i {
                        color: var(--secondary);
                    }
                }
            }

            .right {
                .amount {
                    color: var(--secondary);
                }
            }
        }
    }

    &.rtl{
        direction: rtl;
        .items{
            &:not(:last-child){
                border-left: 1px dashed var(--border-color);

            }
            border-right: 0;
        }
    }
}

.rtl {
    .status-bar{
        .items{
            &:not(:last-child){
                border-left: 1px dashed var(--border-color);
            }
            border-right: 0;
        }
    }
}
</style>
