import { defineConfig, loadEnv } from "vite";
import laravel from "laravel-vite-plugin";
import vue from "@vitejs/plugin-vue";
import path from "path";

export default ({ mode }) => {
    const env = loadEnv(mode, process.cwd(), "");
    return defineConfig({
        define: {
            "process.env": env,
        },
        plugins: [
            laravel({
                input: ["resources/sass/app.scss", "resources/js/app.js"],
                refresh: true,
            }),
            vue({
                template: {
                    transformAssetUrls: {
                        base: null,
                        includeAbsolute: false,
                    },
                },
            }),
        ],

        resolve: {
            alias: {
                "@": path.resolve(__dirname, "./resources/js/views"),
                "@router": path.resolve(__dirname, "./resources/js/router"),
                "@services": path.resolve(__dirname, "./resources/js/services"),
                "@utilities": path.resolve(
                    __dirname,
                    "./resources/js/utilities"
                ),
                "@store": path.resolve(__dirname, "./resources/js/store"),
                "@i18n": path.resolve(__dirname, "./resources/js/i18n"),
                "~": path.resolve(__dirname, "./resources/js"),
            },
        },
        server: {
            host: true,
            port: 5174,
            strictPort: true,
            hmr: {
                host: "billing-api.test",
            },
            cors: true,
        },
    });
};
