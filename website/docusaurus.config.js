module.exports = {
  title: "Riverpod",
  tagline: "Provider, but different",
  url: "https://riverpod.dev",
  baseUrl: "/",
  favicon: "img/logo.svg",
  organizationName: "rrousselgit", // Usually your GitHub org/user name.
  projectName: "riverpod", // Usually your repo name.
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
      additionalLanguages: ["dart", "yaml"],
    },
    image: '/img/cover.png',

    navbar: {
      title: "Riverpod",
      logo: {
        alt: "Riverpod logo",
        src: "img/logo.png",
      },
      items: [
        {
          to: "docs/getting_started",
          activeBasePath: "docs",
          label: "Docs",
          position: "left",
        },
        {
          href: "https://github.com/rrousselGit/river_pod",
          label: "GitHub",
          position: "right",
        },
      ],
    },
    footer: {
      style: "dark",
      logo: {
        alt: "Riverpod logo",
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
      copyright: `Copyright © ${new Date().getFullYear()} Remi Rousselet. Built with Docusaurus.`,
    },
  },
  presets: [
    [
      "@docusaurus/preset-classic",
      {
        docs: {
          // It is recommended to set document id as docs home page (`docs/` path).
          sidebarPath: require.resolve("./sidebars.js"),
          // Please change this to your repo.
          editUrl: "https://github.com/rrousselGit/river_pod/edit/master/website/",
        },
        theme: {
          customCss: require.resolve("./src/css/custom.css"),
        },
      },
    ],
  ],
};
