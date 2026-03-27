<template>
    <div class="dropzone multi-image-uploader border border-1" @dragover="dragover" @dragleave="dragleave" @drop="drop">
        <input type="file" multiple name="file" id="fileInput" class="d-none" @change="onChange" ref="file" />
        <div class="py-3 px-4 d-flex flex-wrap justify-content-start align-items-center gap-3" v-if="files.length">
            <div v-for="file in files" :key="file.name" class="mt-2 h-100 images-container p-1 rounded-3 position-relative">
                <div class="previews d-flex flex-column justify-content-between align-items-center">
                    <div class="preview-img">
                        <img v-if="getFileType(file) === 'image'" :src="generateThumbnail(file)"  alt="image"/>
                        <span v-else>
                            <i class="bi display-5" :class="getThumbIcon(file)"></i>
                        </span>
                    </div>
                    <div>
                        {{ getModifiedName(file.name) }}
                    </div>
                    <small>
                        {{ getFileSize(file.size) }}
                    </small>
                </div>
                <button class="clear-file p-0 px-1 border-0 position-absolute fs-4 fw-normal lh-1 rounded-circle" type="button"
                    @click.prevent="remove($event, files.indexOf(file))" title="Remove file">
                    <span>&times;</span>
                </button>
            </div>
            <label v-if="files.length < maxLength" for="fileInput" class="border border-2 px-2 rounded upload-icon cursor-pointer add-more-btn" :style="isDragging ? 'background-color: #83e1ff29': ''">
                <i class="bi bi-plus fs-1"></i>
            </label>
        </div>
        <label v-else for="fileInput" class="py-3 px-4 cursor-pointer w-100 h-100">
            <div class="d-flex justify-content-start align-items-center gap-3">
                <i class="bi bi-cloud-arrow-up fs-1 upload-icon"></i>
                <div>
                    <p class="m-0 fw-semibold">
                        <span v-if="isDragging">{{ $t('release_to_upload') }}</span>
                        <span v-else>{{ $t('drop_files_here_or_click_to_upload') }}</span>
                    </p>
                    <p class="m-0 instruction-text">
                        {{ $t('upload_files') }}
                    </p>
                </div>
            </div>
        </label>

    </div>
</template>

<script setup>
import { ref, watch } from 'vue';
import { getFileType, getFileSize, getModifiedName } from '@utilities/fileHelpers';

const props = defineProps({
    maxLength: {},
    afterUploadSuccess: {}
});

const emit = defineEmits(['getFiles']);

const isDragging = ref(false);
const files = ref([]);
const file = ref()

function onChange() {
    files.value = [...files.value , ...file.value.files];
    emit('getFiles', files.value);
}

function generateThumbnail(file) {
    let url = URL.createObjectURL(file);
    setTimeout(() => {
        URL.revokeObjectURL(url);
    }, 1000);
    return url;
}

function remove(e, i) {
    e.preventDefault();
    files.value.splice(i, 1);
    emit('getFiles', files.value);
}

function dragover(e) {
    e.preventDefault();
    isDragging.value = true;
}

function dragleave() {
    isDragging.value = false;
}

function drop(e) {
    e.preventDefault();
    file.value.files = e.dataTransfer.files;
    onChange();
    isDragging.value = false;
}

const getThumbIcon = (file)=>{

    const fileType = getFileType(file);

    switch (fileType) {
        case 'text':
            return 'bi-file-earmark-text-fill';
        case 'pdf':
            return 'bi-file-earmark-pdf-fill text-danger';
        case 'doc':
            return 'bi-file-earmark-word-fill text-primary';
        case 'spreadsheet':
            return 'bi-file-earmark-spreadsheet-fill text-info';
        case 'zip':
            return 'bi-file-earmark-zip-fill text-success';
        case 'ppt':
            return 'bi-file-earmark-ppt-fill text-warning';
        case 'other':
                return 'bi-file-earmark-fill text-secondary';
        default:
            return 'bi-file-earmark-fill text-secondary';
    }

}

watch(() => props.afterUploadSuccess, () => {
    files.value = []
});

</script>

<style scoped lang="scss">
.multi-image-uploader{
    background-color: var(--dropzone-bg-color);
    &.dropzone {
        --bs-border-color: var(--primary);
        --bs-border-style: dashed;
        width: 100%;
        position: relative;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-direction: column;
        border-radius: 8px;

        .upload-icon{
            color: var(--primary);
        }
        .instruction-text{
            color: var(--primary);
        }
        .preview-img {
            img {
                height: 50px;
            }
        }
        .clear-file{
            top: -0.5rem;
            right: -0.5rem;
            color: var(--bs-gray-600);
            background-color: var(--card-color);
        }
        .add-more-btn{
            &:hover{
                background-color: #83e1ff29;
            }
        }
    }
}


</style>
