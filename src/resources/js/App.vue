<template>
    <vue-progress-bar />
    <router-view v-slot="{ Component }">
        <template v-if="Component">
            <Transition mode="out-in">
                <Suspense>
                    <!-- main content -->
                    <component :is="Component"></component>

                    <!-- loading state -->
                    <template #fallback>
                        <div
                            class="h-100vh d-flex flex-column justify-content-center align-items-center bg-white"
                        >
                            <div class="custom-loader" />
                        </div>
                    </template>
                </Suspense>
            </Transition>
        </template>
    </router-view>
</template>
<script setup>
import { onMounted } from "vue";
import { Dropdown } from "bootstrap";
const close = () => {
    const dropdownMenu = document.querySelector(".dropdown-menu.show");
    if (!dropdownMenu) {
        return;
    }
    const dropdownInstance = Dropdown.getInstance(dropdownMenu);
    if (dropdownInstance) {
        dropdownInstance.hide();
    } else {
        new Dropdown(dropdownMenu).hide();
    }
};
function findParentClass(node, clsName) {
    if (node && !node.className) {
        return findParentClass(node.parentNode, clsName);
    } else if (node && node.className) {
        if (!node.classList.contains(clsName)) {
            return findParentClass(node.parentNode, clsName);
        } else {
            return true;
        }
    }
}
const closeDropdown = (e) => {
    if (findParentClass(e.target, "dropdown")) {
        // clicked inside the dropdown
        if (findParentClass(e.target, "dropdown-menu")) {
            // Clicked inside the dropdown menu
            close(); // Close the dropdown
        }
    } else {
        // clicked outside the dropdown
        close(); // Close the dropdown
    }
};
onMounted(() => {
    document.addEventListener("click", closeDropdown);
});
</script>
<script>
export default {
    created() {
        //  [App.vue specific] When App.vue is first loaded start the progress bar
        this.$Progress.start();
        //  hook the progress bar to start before we move router-view
        this.$router.beforeEach((to, from, next) => {
            //  does the page we want to go to have a meta.progress object
            if (to.meta.progress !== undefined) {
                let meta = to.meta.progress;
                // parse meta tags
                this.$Progress.parseMeta(meta);
            }
            //  start the progress bar
            this.$Progress.start();
            //  continue to next page
            next();
        });
        //  hook the progress bar to finish after we've finished moving router-view
        this.$router.afterEach((to, from) => {
            //  finish the progress bar
            this.$Progress.finish();
        });
    },
};
</script>
