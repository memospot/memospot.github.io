import starlight from "@astrojs/starlight";
import tailwindcss from "@tailwindcss/vite";
import { defineConfig } from "astro/config";
import starlightChangelogs, { makeChangelogsSidebarLinks } from "starlight-changelogs";
import starlightImageZoom from "starlight-image-zoom";

// https://astro.build/config
export default defineConfig({
    base: "",
    integrations: [
        starlight({
            plugins: [starlightChangelogs(), starlightImageZoom()],
            logo: { src: "/src/assets/memospot.webp" },
            favicon: "/favicon.ico",
            title: "Memospot",
            editLink: {
                baseUrl: "https://github.com/memospot/memospot.github.io/tree/main/"
            },
            components: {
                Hero: "./src/components/Hero.astro"
            },
            customCss: [
                "@fontsource-variable/open-sans/index.css",
                "@fontsource-variable/cascadia-code/index.css",
                "@fontsource-variable/tilt-neon/full.css",
                "@fontsource/staatliches/latin-400.css",
                "./src/styles/global.css",
                "./src/styles/theme.css",
                "./src/styles/aside.css",
                "./src/styles/code.css"
            ],
            social: [
                {
                    icon: "github",
                    label: "GitHub",
                    href: "https://github.com/memospot/memospot"
                }
            ],
            sidebar: [
                {
                    label: "Guides",
                    items: [
                        // Each item here is one entry in the navigation menu.
                        { label: "Installation", slug: "guides/installation" },
                        { label: "Troubleshooting", slug: "guides/troubleshooting" },
                        { label: "Configuration", slug: "guides/configuration" },
                        { label: "Updating Memos", slug: "guides/updating-memos" },
                        { label: "Data migration", slug: "guides/data-migration" },
                        { label: "Debugging", slug: "guides/debugging" },
                        { label: "Contributing", slug: "guides/contributing" }
                    ]
                },
                {
                    label: "Changelog",
                    items: [
                        ...makeChangelogsSidebarLinks([
                            {
                                type: "all",
                                base: "changelog",
                                label: "All versions"
                            },
                            {
                                type: "recent",
                                base: "changelog",
                                count: 3
                            }
                        ])
                    ]
                }
            ]
        })
    ],
    vite: {
        plugins: [tailwindcss()]
    }
});
