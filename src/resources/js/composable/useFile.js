import { ref } from "vue";
export const useFile = () => {
    const error = ref("");
    const validateFileSize = (file, fileSize = 1) => {
        const fileSizeInMB = file.size / (1024 * 1024 * fileSize);
        if (fileSizeInMB > 1) {
            error.value = `Sorry! Maximum allowed size for an image is ${fileSize}MB`;
        } else {
            error.value = "";
        }
    };

    return {
        error,
        validateFileSize,
    };
};
