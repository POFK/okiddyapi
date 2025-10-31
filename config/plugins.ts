// ./config/plugins.ts`

export default ({ env }) => ({
  // see https://market.strapi.io/plugins/strapi-plugin-preview-button
  "preview-button": {
    config: {
      contentTypes: [
        {
          uid: "api::homepage.homepage",
          draft: {
            url: `${env("CLIENT_URL")}/preview`,
            query: {
              type: "home",
              id: "{documentId}",
            },
            openTarget: "_blank",
            copy: false,
            //alwaysVisible: true,
          },
          published: {
            url: env("CLIENT_URL"),
          },
        },
        {
          uid: "api::post.post",
          draft: {
            url: `${env("CLIENT_URL")}/preview`,
            query: {
              type: "post",
              id: "{documentId}",
            },
            openTarget: "_blank",
            copy: false,
            //alwaysVisible: true,
          },
          published: {
            url: `${env("CLIENT_URL")}/post/{documentId}`,
            openTarget: "_blank",
          },
        },
      ],
    },
  },
});
