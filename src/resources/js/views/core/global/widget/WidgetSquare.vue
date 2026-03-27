<template>
    <div class="status-card-square">
        <div class="items">
            <div class="title">
                {{ data.title }}
            </div>
            <div class="sub-title" v-if="data.subTitle">
                {{ data.subTitle }}
            </div>
        </div>
        <div class="items" :class="data.colorize" v-if="data.icon">
            <img :src="data.icon" alt="">
        </div>
    </div>
</template>

<script setup>

const props = defineProps({
    data: {}
})
</script>

<style lang="scss"> .status-card-square {
    margin-bottom: 15px;
    flex-direction: column-reverse;
    background: var(--card-color);
    text-align: center;
    padding: 20px;
    border-radius: var(--round-default);
    display: flex;
    align-items: center;
    justify-content: center;
    flex-wrap: wrap;
    gap: 8px;

    .items {

        &:nth-child(1) {
            flex: 1 1 auto;

            .title {
                font-size: 16px;
                font-weight: bold;
                color: var(--font-color);
            }

            .sub-title {
                font-size: 12px;
                font-weight: lighter;
                text-transform: capitalize;
                color: var(--primary);
            }
        }

        &:nth-child(2) {
            border-radius: 50%;
            background-color: transparentize(#00aaf0, .9);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 15px;
            color: var(--primary);
            height: 75px;
            width: 75px;

            &.violet {
                background-color: transparentize(#00aaf0, .9);

                i {
                    color: #ffffff;
                }
            }

            &.lightgreen {
                background-color: transparentize(#4BCCB8, .9);

                i {
                    color: #4BCCB8;
                }
            }

            &.lightpink {
                background-color: transparentize(#F36FAD, .9);

                i {
                    color: #F36FAD;
                }
            }

            &.lightblue {
                background-color: transparentize(#36B9F5, .9);

                i {
                    color: #36B9F5;
                }
            }

            i {
                font-size: 2.5rem;
            }
        }
    }
}</style>
