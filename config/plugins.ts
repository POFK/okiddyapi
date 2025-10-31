// ./config/plugins.ts`
const { env } = require("@strapi/utils");

const clientUrl = env("CLIENT_URL");

export default () => ({
  // see https://market.strapi.io/plugins/strapi-plugin-preview-button
  "preview-button": {
    config: {
      contentTypes: [
        {
          uid: "api::homepage.homepage",
          draft: {
            url: `${clientUrl}/preview`,
            query: {
              type: "home",
              id: "{documentId}",
            },
            openTarget: "_blank",
            copy: false,
            //alwaysVisible: true,
          },
          published: {
            url: clientUrl,
          },
        },
        {
          uid: "api::post.post",
          draft: {
            url: `${clientUrl}/preview`,
            query: {
              type: "post",
              id: "{documentId}",
            },
            openTarget: "_blank",
            copy: false,
            //alwaysVisible: true,
          },
          published: {
            url: `${clientUrl}/post/{documentId}`,
            openTarget: "_blank",
          },
        },
      ],
    },
  },
});
