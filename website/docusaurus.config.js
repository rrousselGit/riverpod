module.exports = {
  title: "Riverpod",
  url: "https://riverpod.dev",
  baseUrl: "/",
  favicon: "img/logo.svg",
  organizationName: "rrousselgit", // Usually your GitHub org/user name.
  projectName: "riverpod", // Usually your repo name.
  plugins: ["docusaurus-plugin-sass"],
  trailingSlash: false,
  i18n: {
    defaultLocale: "en",
    locales: ["en", "fr", "ko", "ja", "es", "bn", "de", "it", "ru", "tr", "zh-Hans"],
  },
  themeConfig: {
    algolia: {
      appId: "0UST1QN21Y",
      apiKey: "30b20f424c381e1c6a1c00ffc2f6826b",
      indexName: "riverpod",
    },
    colorMode: {
      defaultMode: "dark",
    },
    prism: {
      defaultLanguage: "dart",
      additionalLanguages: ["dart", "yaml"],
      theme: require("prism-react-renderer/themes/vsLight"),
      darkTheme: require("prism-react-renderer/themes/dracula"),
    },
    image: "/img/cover.png",

    navbar: {
      title: "Riverpod",
      logo: {
        alt: "Riverpod",
        src: "img/logo.png",
      },
      items: [
        {
          to: "docs/introduction/why_riverpod",
          activeBasePath: "docs",
          label: "Docs",
          position: "right",
        },
        {
          type: "localeDropdown",
          position: "right",
        },
        {
          href: "https://github.com/rrousselGit/riverpod",
          label: "GitHub",
          position: "right",
        },
      ],
    },
    footer: {
      logo: {
        alt: "Riverpod",
        src: "img/full_logo.svg",
      },
      links: [
        {
          title: "Docs",
          items: [
            {
              label: "Why Riverpod?",
              to: "docs/introduction/why_riverpod",
            },
            {
              label: "Getting started",
              to: "docs/introduction/getting_started",
            },
          ],
        },
        {
          title: "Community",
          items: [
            {
              label: "Discord",
              href: "https://discord.gg/Bbumvej",
            },
            {
              label: "GitHub",
              href: "https://github.com/rrousselgit/riverpod",
            },
            {
              label: "Stack Overflow",
              href: "https://stackoverflow.com/questions/tagged/riverpod",
            },
            {
              label: "Twitter",
              href: "https://twitter.com/remi_rousselet",
            },
            {
              label: "Code of conduct",
              href: "https://github.com/rrousselGit/riverpod/blob/master/CODE_OF_CONDUCT.md",
            },
            {
              label: "Contributing guide",
              href: "https://github.com/rrousselGit/riverpod/blob/master/CONTRIBUTING.md",
            },
          ],
        },
        {
          title: "Sponsors",
          items: [
            {
              html: "<a href='https://www.netlify.com'><img src='https://www.netlify.com/img/global/badges/netlify-color-bg.svg' alt='Deploys by Netlify' /></a>",
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} Remi Rousselet.<br /> Built with Docusaurus.`,
    },
  },
  presets: [
    [
      "@docusaurus/plugin-google-analytics",
      {
        googleAnalytics: {
          trackingID: "UA-138675999-4",
        },
      },
    ],
    [
      "@docusaurus/preset-classic",
      {
        docs: {
          editLocalizedFiles: true,
          sidebarPath: require.resolve("./sidebars.js"),
          editUrl:
            "https://github.com/rrousselGit/riverpod/edit/master/website/",
        },
        theme: {
          customCss: require.resolve("./src/scss/main.scss"),
        },
      },
    ],
  ],
};
