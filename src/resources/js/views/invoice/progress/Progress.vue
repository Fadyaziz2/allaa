<template>
    <div class="height-5 bg-gray-300 w-100 rounded-pill my-2 overflow-hidden">
        <div
            class="widthgrowtransition height-5 rounded-pill"
            :class="[barColorClass]"
            :style="{ width: animatedWidth + '%', backgroundColor: barColor }"
        ></div>
    </div>
</template>

<script setup>
import { computed, ref, watch } from "vue";
const props = defineProps({
    amount: {
        type: [String, Number],
        required: false,
    },
    maxAmount: {
        type: [String, Number],
        required: false,
        default: 100,
    },
    barColorClass: {
        type: String,
        default: () => "bg-primary",
    },
    barColor: String
});

const percentage = computed(
    () => (parseInt(props.amount) / parseInt(props.maxAmount)) * 100
);

const animatedWidth = ref(0);

// Start the animation loop on mounted
watch(
    () => props.amount,
    () => {
        animate();
    },
    { immediate: true }
);

// Animation function
function animate() {
    let start = null; // Variable to store the start timestamp of the animation

    // Define the animation step function
    function step(timestamp) {
        if (!start) {
            start = timestamp; // Set the start timestamp if it's not defined
        }

        const progress = timestamp - start; // Calculate the progress of the animation
        const duration = 1000; // Duration of the animation in milliseconds
        const width = Math.min((progress / duration) * 100, percentage.value); // Calculate the width value based on the progress

        animatedWidth.value = width; // Update animatedWidth with the calculated width value

        if (width !== percentage.value) {
            // Continue the animation until it reaches the duration
            requestAnimationFrame(step);
        }
    }

    // Start the animation loop with requestAnimationFrame
    window.requestAnimationFrame(step);
}
</script>
