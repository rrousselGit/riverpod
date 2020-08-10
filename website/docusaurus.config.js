module.exports = {
  title: "Riverpod",
  tagline: "Provider, but different",
  url: "https://riverpod.dev",
  baseUrl: "/",
  favicon: "img/favicon.ico",
  organizationName: "rrousselgit", // Usually your GitHub org/user name.
  projectName: "riverpod", // Usually your repo name.
  themeConfig: {
    sidebarCollapsible: false,
    googleAnalytics: {
      trackingID: "UA-138675999-4",
    },
    algolia: {
      apiKey: '2a84d9068bda0a387816a77f366d855d',
      indexName: 'riverpod',
    },
    prism: {
      additionalLanguages: ["dart", "yaml"],
    },
    navbar: {
      title: "Riverpod",
      // logo: {
      //   alt: "My Site Logo",
      //   src: "img/logo.svg",
      // },
      links: [
        {
          to: "docs/fundamentals/getting_started",
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
      links: [
        {
          title: "Docs",
          items: [
            {
              label: "Getting started",
              to: "docs/fundamentals/getting_started",
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
          homePageId: "doc1",
          sidebarPath: require.resolve("./sidebars.js"),
          // Please change this to your repo.
          editUrl: "https://github.com/rrousselGit/river_pod",
        },
        theme: {
          customCss: require.resolve("./src/css/custom.css"),
        },
      },
    ],
  ],
};
