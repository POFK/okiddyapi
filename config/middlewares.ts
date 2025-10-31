export default ({ env }) => [
    "strapi::logger",
    "strapi::errors",
    "strapi::security",
    "strapi::cors",
    "strapi::poweredBy",
    "strapi::query",
    "strapi::body",
    "strapi::session",
    "strapi::favicon",
    "strapi::public",
    // cloudflare R2 as image upload server
    {
        name: "strapi::security",
        config: {
            contentSecurityPolicy: {
                useDefaults: true,
                directives: {
                    "connect-src": ["'self'", "https:"],
                    "img-src": [
                        "'self'",
                        "data:",
                        "blob:",
                        "market-assets.strapi.io",
                        // 保持原始逻辑，确保最终结果是字符串类型
                        (env("CF_PUBLIC_ACCESS_URL")
                            ? env("CF_PUBLIC_ACCESS_URL")?.replace(
                                  /^https?:\/\//,
                                  "",
                              )
                            : "") as string,
                    ],
                    "media-src": [
                        "'self'",
                        "data:",
                        "blob:",
                        "market-assets.strapi.io",
                        // 保持原始逻辑，确保最终结果是字符串类型
                        (env("CF_PUBLIC_ACCESS_URL")
                            ? env("CF_PUBLIC_ACCESS_URL")?.replace(
                                  /^https?:\/\//,
                                  "",
                              )
                            : "") as string,
                    ],
                    // TypeScript 中 null 是一个有效的类型，保持不变
                    upgradeInsecureRequests: null,
                },
            },
        },
    },
];
