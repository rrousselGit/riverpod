module.exports = {
  title: 'Riverpod',
  tagline: 'Provider, but different',
  url: 'https://riverpod.dev',
  baseUrl: '/',
  favicon: 'img/favicon.ico',
  organizationName: 'rrousselgit', // Usually your GitHub org/user name.
  projectName: 'riverpod', // Usually your repo name.
  themeConfig: {
    prism: {
      additionalLanguages: ['dart', 'yaml'],
    },
    navbar: {
      title: 'My Site',
      logo: {
        alt: 'My Site Logo',
        src: 'img/logo.svg',
      },
      links: [
        {
          to: 'docs/fundamentals/getting_started',
          activeBasePath: 'docs',
          label: 'Docs',
          position: 'left',
        },
        {
          href: 'https://github.com/facebook/docusaurus',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Docs',
          items: [
            {
              label: 'Getting started',
              to: 'docs/fundamentals/getting_started',
            },
          ],
        },
        {
          title: 'Community',
          items: [
            {
              label: 'Stack Overflow',
              href: 'https://stackoverflow.com/questions/tagged/flutter',
            },
            {
              label: 'Twitter',
              href: 'https://twitter.com/remi_rousselet',
            },
            {
              label: 'GitHub',
              href: 'https://github.com/rrousselgit/riverpod',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} Remi Rousselet. Built with Docusaurus.`,
    },
  },
  presets: [
    [
      '@docusaurus/preset-classic',
      {
        docs: {
          // It is recommended to set document id as docs home page (`docs/` path).
          homePageId: 'doc1',
          sidebarPath: require.resolve('./sidebars.js'),
          // Please change this to your repo.
          editUrl:
            'https://github.com/facebook/docusaurus/edit/master/website/',
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      },
    ],
  ],
};
