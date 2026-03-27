<template>
    <div :style="{height: `${height}px`}">
        <canvas :id="id" ref="canvas"></canvas>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import Chart from 'chart.js/auto'

const props = defineProps({
    id: {
        type: String,
        required: true
    },
    type: {
        type: String,
        required: true
    },
    title: {
        type: String,
    },
    labels: {
        type: Array,
        required: true
    },
    data: {
        type: Array,
        required: true
    },
    height: {
        type: Number,
        default: 400
    },
    chartTitle: {
        type: Array,
    },
    legend: {
        type: Boolean,
        default: false
    },
    tension: {
        type: Number,
        default: 0.4
    }

})

const canvas = ref()
onMounted(() => {
    let ctx = canvas.value.getContext('2d');
    new Chart(ctx, {
        type: props.type,
        data: {
            labels: props.labels,
            chartTitle: props.chartTitle,
            datasets: props.data
        },

        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: props.legend
                },
                title: {
                    display: true,
                    text: props.chartTitle,
                },
                tooltip: {
                    usePointStyle: false,
                }
            },

            elements: {
                line: {
                    tension: props.tension
                }
            }
        }
    });
})


</script>
