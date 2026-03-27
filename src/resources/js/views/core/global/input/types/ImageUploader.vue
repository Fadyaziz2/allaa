<template>
    <div
        class="image-uploader-wrapper position-relative"
        :class="{
            'is-uploading': uploadProgress > 0 && uploadProgress < 100,
        }"
    >
        <div
            class="uploading flex-column justify-content-center align-items-center overflow-hidden"
        >
            <span
                class="h-100 upload-percentage position-absolute top-0 left-0"
                :style="{
                    width: `${uploadProgress}%`,
                }"
            />
            <!-- <span class="spinner-grow w-50 h-50 text-secondary" /> -->
            <span
                class="position-absolute top-50 left-50 translate-middle fw-semibold text-white"
                >{{ uploadProgress }}%</span
            >
        </div>
        <div class="image-area rounded d-flex">
            <img
                v-if="imageUrl"
                :src="imageUrl"
                class="img-fluid rounded mx-auto my-auto h-100"
            />
        </div>
        <div class="input-area">
            <label id="upload-label" @click="$refs.file.click()">
                {{ data.label || $t("choice_your_file") }}
            </label>
            <input
                ref="file"
                type="file"
                class="form-control d-none"
                @change="getFile"
            />
        </div>
    </div>
</template>

<script>
import { ref } from "vue";
import coreAppFunction from "@/core/global/helpers/app/coreAppFunction";

export default {
    name: "ImageUploader",
    props: {
        data: {},
        value: {},
    },
    watch: {
        value: {
            handler: "initComponent",
            immediate: true,
        },
    },
    methods: {
        changed() {
            this.$emit("getFile", this.fieldValue);
        },
        initComponent() {
            if (typeof this.value == "string") {
                if (this.value) {
                    this.imageUrl = this.value;
                    this.getDataUrl(this.value).then(
                        (data) => (this.fieldValue = data)
                    );
                } else {
                    this.imageUrl = "";
                    this.fieldValue = "";
                }
            }
            if (!this.value) {
                this.imageUrl = "";
                this.fieldValue = "";
            }
        },

        getDataUrl(item) {
            let fileName = coreAppFunction.splitNameBySlas(item),
                url = this.data.generateFileUrl
                    ? coreAppFunction.getAppUrl(
                          item
                              .split("/")
                              .filter((p) => p)
                              .join("/")
                      )
                    : item;

            return new Promise((resolve, reject) => {
                fetch(url)
                    .then((response) => response.blob())
                    .then((blob) => this.blobToFile(blob, fileName))
                    .then((data) => {
                        data.url = URL.createObjectURL(data);
                        resolve(data);
                    });
            });
        },

        blobToFile(theBlob, fileName) {
            const dateValue = new Date(),
                timeValue = dateValue.getTime();

            theBlob.name = fileName;
            theBlob.lastModified = timeValue;
            theBlob.lastModifiedDate = dateValue;
            theBlob.webkitRelativePath = "";

            return theBlob;
        },
    },
    setup(props, { emit }) {
        const uploadProgress = ref(0);
        const imageUrl = ref(null);
        const fieldValue = ref(null);
        const getFile = (event) => {
            fieldValue.value = event.target.files[0];
            imageUrl.value = URL.createObjectURL(fieldValue.value);
            emit("getFile", fieldValue.value);
        };
        return { imageUrl, getFile, uploadProgress };
    },
};
</script>

<style lang="scss">
.image-uploader-wrapper {
    background-color: var(--card-color);
    width: 100px;
    height: 100px;
    border-radius: 0.25rem;
    .uploading {
        display: none;
    }
    &.is-uploading {
        .uploading {
            display: flex;
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.3);
            .upload-percentage {
                background-color: rgba(153, 153, 153, 0.3);
            }
        }
    }
    .image-area {
        width: 100px;
        height: 100px;
        border-radius: 0.25rem;
    }

    &:hover {
        .input-area {
            opacity: 1;
        }
    }

    .input-area {
        position: absolute;
        right: 0;
        bottom: 0;
        left: 0;
        opacity: 0;
        padding: 5px 0;
        background-color: rgba(0, 0, 0, 0.4);
        border-bottom-left-radius: 0.25rem;
        border-bottom-right-radius: 0.25rem;
        transition: all 0.25s ease-in-out;

        #upload-label {
            width: 100%;
            font-size: 90%;
            cursor: pointer;
            margin-bottom: 0;
            text-align: center;
            color: #fff !important;
        }
    }
}
</style>
