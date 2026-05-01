import { defineConfig } from 'astro/config';

// https://astro.build/config
export default defineConfig({
  site: 'https://velvz.com',
  trailingSlash: 'ignore',
  build: {
    format: 'directory',
  },
  compressHTML: true,
});
