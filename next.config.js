const webpack = require('webpack');
const withPWA = require('next-pwa')
const isProd = process.env.NODE_ENV === 'production'
const withBundleAnalyzer = require('@next/bundle-analyzer')({
  enabled: process.env.ANALYZE === 'true',
})

const nextConfig = withPWA(
  {
    assetPrefix: isProd && process.env.CDN_URL_FOR_STATIC_RESOURCES ? process.env.CDN_URL_FOR_STATIC_RESOURCES : '',
    publicRuntimeConfig: {
      localeSubpaths: typeof process.env.LOCALE_SUBPATHS === 'string'
        ? process.env.LOCALE_SUBPATHS
        : 'none',
    },
    eslint: {
      // Warning: This allows production builds to successfully complete even if
      // your project has ESLint errors.
      ignoreDuringBuilds: true,
    },
    basePath:process.env.subFolder.slice(0, -1),
    webpack5: true,
    webpack: function (config) {
      config.plugins.push(new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery',
        'window.jQuery': 'jquery'
      }))
      return config
    },
    pwa: {
      disable: process.env.NODE_ENV === 'production' ? false : true,
      dest: "public",
      register: false,
    },
    images: {
      domains: [process.env.PUBLIC_URL.replace("http://",'').replace("https://",''),"localhost"],
    },
    poweredByHeader:false,
  }
);

module.exports = withBundleAnalyzer(nextConfig)
