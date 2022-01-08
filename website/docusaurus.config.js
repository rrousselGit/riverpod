module.exports = {
  title: "Riverpod",
  url: "https://riverpod.dev",
  baseUrl: "/",
  favicon: "img/logo.svg",
  organizationName: "rrousselgit", // Usually your GitHub org/user name.
  projectName: "riverpod", // Usually your repo name.
  plugins: ["docusaurus-plugin-sass"],
  i18n: {
    defaultLocale: "en",
    locales: ["en", "fr", "ko"],
  },
  themeConfig: {
    googleAnalytics: {
      trackingID: "UA-138675999-4",
    },
    algolia: {
      apiKey: "2a84d9068bda0a387816a77f366d855d",
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
          to: "docs/getting_started",
          activeBasePath: "docs",
          label: "Docs",
          position: "right",
        },
        {
          type: "localeDropdown",
          position: "right",
        },
        {
          href: "https://github.com/rrousselGit/river_pod",
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
              label: "Getting started",
              to: "docs/getting_started",
            },
          ],
        },
        {
          title: "Community",
          items: [
            {
              label: "Stack Overflow",
              href: "https://stackoverflow.com/questions/tagged/flutter",
            },
            {
              label: "Twitter",
              href: "https://twitter.com/remi_rousselet",
            },
            {
              label: "GitHub",
              href: "https://github.com/rrousselgit/river_pod",
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} Remi Rousselet.<br /> Built with Docusaurus.`,
    },
  },
  presets: [
    [
      "@docusaurus/preset-classic",
      {
        docs: {
          editLocalizedFiles: true,
          sidebarPath: require.resolve("./sidebars.js"),
          editUrl:
            "https://github.com/rrousselGit/river_pod/edit/master/website/",
        },
        theme: {
          customCss: require.resolve("./src/scss/main.scss"),
        },
      },
    ],
  ],
};
