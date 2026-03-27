<template>
    <nav class="pagination-nav">
        <ul class="pagination">
            <li class="page-item" :class="{ disabled: activePage === 1 }">
                <a
                    class="page-link"
                    href="#"
                    @click.prevent="previous()"
                    tabindex="-1"
                    aria-disabled="true"
                >
                    <i class="bi bi-chevron-left" />
                </a>
            </li>
            <li class="page-item" v-for="(page, index) in pages" :key="index">
                <a
                    class="page-link"
                    :class="{
                        'active disabled': activePage === page,
                        disabled: typeof page != 'number',
                    }"
                    href="#"
                    @click.prevent="activatedPage(page)"
                >
                    {{ page }}
                </a>
            </li>
            <li
                class="page-item"
                :class="{ disabled: activePage === totalPages }"
            >
                <a class="page-link" href="#" @click.prevent="next()">
                    <i class="bi bi-chevron-right" />
                </a>
            </li>
        </ul>
    </nav>
</template>

<script>
import { ref, watch, computed } from "vue";

export default {
    props: {
        currentPage: {
            type: Number,
            required: true,
        },
        totalPages: {
            type: Number,
            required: true,
        },
    },

    setup(props, { emit }) {
        const activePage = ref(1);

        watch(
            props,
            (newValue) => {
                activePage.value = newValue.currentPage;
            },
            { immediate: true }
        );

        const pages = computed(() =>
            pagination(activePage.value, props.totalPages)
        );

        const next = () => {
            if (activePage.value === props.totalPages) {
                return;
            } else {
                activePage.value++;
            }
            activatedPage(activePage.value);
            scrollTop();
        };
        const previous = () => {
            if (activePage.value > 1) {
                activePage.value--;
            }
            activatedPage(activePage.value);
            scrollTop();
        };

        const activatedPage = (page) => {
            if (typeof page != "number") return;
            activePage.value = page;
            emit("paginate", page);
            scrollTop();
        };
        const scrollTop = () => {
            document.body.scrollTop = 0;
            document.documentElement.scrollTop = 0;
        };
        const getRange = (start, end) => {
            return Array(end - start + 1)
                .fill()
                .map((v, i) => i + start);
        };
        const pagination = (currentPage, pageCount) => {
            let delta;
            if (pageCount <= 7) {
                delta = 7;
            } else {
                delta = currentPage > 4 && currentPage < pageCount - 3 ? 2 : 4;
            }

            const range = {
                start: Math.round(currentPage - delta / 2),
                end: Math.round(currentPage + delta / 2),
            };

            if (range.start - 1 === 1 || range.end + 1 === pageCount) {
                range.start += 1;
                range.end += 1;
            }

            let pages =
                currentPage > delta
                    ? getRange(
                          Math.min(range.start, pageCount - delta),
                          Math.min(range.end, pageCount)
                      )
                    : getRange(1, Math.min(pageCount, delta + 1));

            const withDots = (value, pair) =>
                pages.length + 1 !== pageCount ? pair : [value];

            if (pages[0] !== 1) {
                pages = withDots(1, [1, "..."]).concat(pages);
            }

            if (pages[pages.length - 1] < pageCount) {
                pages = pages.concat(withDots(pageCount, ["...", pageCount]));
            }

            return pages;
        };

        return { activePage, pages, previous, activatedPage, next };
    },
};
</script>
