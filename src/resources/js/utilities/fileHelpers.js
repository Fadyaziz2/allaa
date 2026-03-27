const zipTypes = ['application/zip', 'application/x-7z-compressed', 'application/x-rar-compressed', 'application/vnd.rar'];
const docTypes = ['application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'];
const excelTypes = [
    'application/vnd.ms-excel',                                     // .xls (Excel 97-2003)
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', // .xlsx (Excel 2007+)
    'text/csv'                                                      // .csv (CSV)
  ];
const pptTypes = [
    'application/vnd.ms-powerpoint',                         // .ppt (PowerPoint 97-2003)
    'application/vnd.openxmlformats-officedocument.presentationml.presentation'  // .pptx (PowerPoint 2007+)
];

export const getFileType = (file)=>{
    if(file.type.startsWith("image/")) return 'image';
    else if(file.type === "text/plain") return 'text';
    else if (pptTypes.includes(file.type)) return 'ppt';
    else if (docTypes.includes(file.type)) return 'doc';
    else if (zipTypes.includes(file.type)) return 'zip';
    else if(file.type === "application/pdf") return 'pdf';
    else if(file.type.startsWith("video/")) return 'video';
    else if (excelTypes.includes(file.type)) return 'spreadsheet';
    else return 'other';
}

export const getFileSize = (fileSizeInBytes) => {
    const kilobyte = 1024;
    const megabyte = kilobyte * 1024;
    const gigabyte = megabyte * 1024;

    if (fileSizeInBytes >= gigabyte) {
        return (fileSizeInBytes / gigabyte).toFixed(2) + " GB";
    } else if (fileSizeInBytes >= megabyte) {
        return (fileSizeInBytes / megabyte).toFixed(2) + " MB";
    } else if (fileSizeInBytes >= kilobyte) {
        return (fileSizeInBytes / kilobyte).toFixed(2) + " KB";
    } else {
        return fileSizeInBytes + " bytes";
    }
};
export const getModifiedName = (originalFileName) => {
    const fileExtension = originalFileName.slice(
        originalFileName.lastIndexOf(".")
    );
    const fileNameWithoutExtension = originalFileName.slice(
        0,
        originalFileName.lastIndexOf(".")
    );
    const fileNameLength = fileNameWithoutExtension.length;

    if (fileNameLength <= 5) {
        return originalFileName;
    }
    const modifiedFileName =
        fileNameWithoutExtension.slice(0, 5) + ".." + fileExtension;
    return modifiedFileName;
};

export function getVideoCover(file, seekTo = 0.0) {
    console.log("getting video cover for file: ", file);
    return new Promise((resolve, reject) => {
        // load the file to a video player
        const videoPlayer = document.createElement('video');
        videoPlayer.setAttribute('src', URL.createObjectURL(file));
        videoPlayer.load();
        videoPlayer.addEventListener('error', (ex) => {
            reject("error when loading video file", ex);
        });
        // load metadata of the video to get video duration and dimensions
        videoPlayer.addEventListener('loadedmetadata', () => {
            // seek to user defined timestamp (in seconds) if possible
            if (videoPlayer.duration < seekTo) {
                reject("video is too short.");
                return;
            }
            // delay seeking or else 'seeked' event won't fire on Safari
            setTimeout(() => {
              videoPlayer.currentTime = seekTo;
            }, 200);
            // extract video thumbnail once seeking is complete
            videoPlayer.addEventListener('seeked', () => {
                console.log('video is now paused at %ss.', seekTo);
                // define a canvas to have the same dimension as the video
                const canvas = document.createElement("canvas");
                canvas.width = videoPlayer.videoWidth;
                canvas.height = videoPlayer.videoHeight;
                // draw the video frame to canvas
                const ctx = canvas.getContext("2d");
                ctx.drawImage(videoPlayer, 0, 0, canvas.width, canvas.height);
                // return the canvas image as a blob
                ctx.canvas.toBlob(
                    blob => {
                        resolve(blob);
                    },
                    "image/jpeg",
                    0.75 /* quality */
                );
            });
        });
    });
}
