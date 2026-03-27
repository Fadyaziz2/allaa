<template>
    <div class="status-card mb-21px">
        <div class="items">
            <div class="title">
                {{data.title}}
            </div>
            <div class="sub-title" v-if="data.subTitle">
                {{data.subTitle}}
            </div>
        </div>
        <div class="items" v-if="data.icon">
            <img :src="data.icon" alt="">
        </div>
    </div>
</template>

<script setup>
const props = defineProps({
    data: {}
})
</script>

<style lang="scss">
.status-card {
    background: var(--card-color);
    padding: 20px;
    border-radius: var(--round-default);
    display: flex;
    align-items: center;
    justify-content: center;
    flex-wrap: wrap;
    gap: 15px;
    .items {

        &:nth-child(1) {
            flex: 1 1 auto;

            .title {
                font-size: 16px;
                font-weight: bold;
                color: var(--font-color);
            }

            .sub-title {
                font-size: 13px;
                font-weight: lighter;
                text-transform: capitalize;
                color: var(--primary);
            }
        }

        &:nth-child(2) {
            border-radius: var(--round-default);
            background-color: transparentize(#00aaf0, .2);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 15px;
            color: #ffffff;
            flex-basis: 60px;
            height: 60px;
            i{
                font-size:2.1rem;
            }
        }
    }
}

</style>


