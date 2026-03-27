<template>
    <div>
        <template v-if="rowData.note">
            <div class="dropdown">
                <a
                    :href="`#note${rowData.id}`"
                    class="mx-2 dropdown-toggle"
                    href="#"
                    role="button"
                    :id="`#note${rowData.id}`"
                    data-bs-toggle="dropdown"
                    data-bs-auto-close="outside"
                    aria-expanded="false"
                >
                    <i class="bi bi-journal-bookmark-fill fs-5 brand-color"></i>
                </a>
                <ul
                    class="dropdown-menu dropdown-menu-end noteContainer py-0 custom-scrollbar"
                    :aria-labelledby="`#note${rowData.id}`"
                    @click.stop="() => false"
                >
                    <div class="card card-body shadow-none">
                        <div class="card-title py-1 pb-1">
                            {{ $t("note") }}
                        </div>
                        <div class="note-details mb-3">
                            <span v-html="rowData.note"></span>
                        </div>
                        <div class="d-flex justify-content-end">
                            <button
                                @click="closeNote"
                                class="btn btn-primary"
                                data-bs-toggle="collapse"
                                :href="`#note${rowData.id}`"
                                role="button"
                                aria-expanded="false"
                                :aria-controls="`note${rowData.id}`"
                            >
                                {{ $t("close") }}
                            </button>
                        </div>
                    </div>
                </ul>
            </div>
        </template>
        <template v-else> - </template>
    </div>
</template>

<script setup>
const props = defineProps({
    rowData: {
        type: Object,
        required: true,
    },
});
const closeNote = () => {
    let element = document.querySelector(
        `ul[aria-labelledby='#note${props.rowData.id}']`
    );
    element?.classList.remove("show");
};
</script>

<style lang="scss" scoped>
.dropdown-toggle::after {
    content: unset;
}

table {
    position: relative;

    .noteContainer {
        position: absolute;
        min-width: 320px;
        max-width: 320px;
        z-index: 1;
        right: 0 !important;

        .card-title {
            color: var(--font-color);
            font-size: 15px;

            &::first-letter {
                text-transform: uppercase;
            }
        }

        .note-details {
            border-radius: 4px;
            padding: 14px 9px;
            background-color: var(--note-bg-color);
            color: var(--font-color);
            margin: 5px 0;
            display: inline-flex;
            border: 1px solid #dfdfdf36;
            white-space: wrap;
            max-height: 175px;
            overflow-x: hidden;
            text-align: justify;
            &::-webkit-scrollbar {
                background: var(--card-color);
                width: 4px;
            }

            &::-webkit-scrollbar-thumb {
                border-radius: 50px;
                background: var(--primary);
            }
        }
    }
}
</style>
