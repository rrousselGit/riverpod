module.exports = {
  Sidebar: [
    "fundamentals/getting_started",
    {
      type: "category",
      label: "Concepts",
      items: [
        "fundamentals/concepts/providers",
        "fundamentals/concepts/reading",
        "fundamentals/concepts/combining_providers",
        "fundamentals/concepts/computed",
        "fundamentals/concepts/family",
      ],
    },
    {
      type: "category",
      label: "Cookbooks",
      items: ["cookbooks/testing"],
    },
    {
      type: "category",
      label: "Examples",
      items: [
        {
          type: "link",
          label: "Counter",
          href:
            "https://github.com/rrousselGit/river_pod/tree/master/examples/counter",
        },
        {
          type: "link",
          label: "Todo list",
          href:
            "https://github.com/rrousselGit/river_pod/tree/master/examples/todos",
        },
        {
          type: "link",
          label: "Marvel API",
          href:
            "https://github.com/rrousselGit/river_pod/tree/master/examples/marvel",
        },
      ],
    },
    {
      type: "category",
      label: "Api references",
      items: [
        {
          type: "link",
          label: "riverpod",
          href:
            "https://pub.dev/documentation/riverpod/latest/riverpod/riverpod-library.html",
        },
        {
          type: "link",
          label: "flutter_riverpod",
          href:
            "https://pub.dev/documentation/flutter_riverpod/latest/flutter_riverpod/flutter_riverpod-library.html",
        },
        {
          type: "link",
          label: "hooks_riverpod",
          href:
            "https://pub.dev/documentation/hooks_riverpod/latest/hooks_riverpod/hooks_riverpod-library.html",
        },
      ],
    },
  ],
};
