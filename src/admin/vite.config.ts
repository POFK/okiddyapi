import { mergeConfig, type UserConfig } from 'vite';

export default (config: UserConfig) => {
  // Important: always return the modified config
  return mergeConfig(config, {
    resolve: {
      alias: {
        '@': '/src',
      },
    },
    server: {
      allowedHosts: [
        'okiddyapi.pangu.datalab', // Replace with your actual hostname
        'okiddyapi.pangu.datalab:1337', // Replace with your actual hostname
    ],
  },
  });
};
