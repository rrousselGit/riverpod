module.exports = {
  Sidebar: [
    {
      type: "category",
      label: "Introduction",
      collapsible: false,
      items: ["introduction/why_riverpod", "introduction/getting_started"],
    },
    {
      type: "category",
      label: "Riverpod for Provider Users",
      items: [
        "from_provider/quickstart",
        "from_provider/provider_vs_riverpod",
        "from_provider/motivation/motivation",
      ],
    },
    {
      type: "category",
      label: "Essentials",
      collapsible: false,
      items: [
        "essentials/first_request",
        "essentials/side_effects",
        "essentials/passing_args",
        "essentials/websockets_sync",
        "essentials/combining_requests",
        "essentials/auto_dispose",
        // {
        //   type: "link",
        //   label: "Progress indicators and error pages (WIP)",
        //   href: "https://github.com/rrousselGit/riverpod/tree/master/examples/marvel",
        // },
        "essentials/eager_initialization",
        "essentials/testing",
        "essentials/provider_observer",
        "essentials/faq",
        "essentials/do_dont",
      ],
    },

    // Case studies
    {
      type: "category",
      label: "Case studies",
      collapsible: false,
      items: ["case_studies/pull_to_refresh", "case_studies/cancel"],
    },
    // {
    //   type: "link",
    //   label: "Infinite lists (WIP)",
    //   href: "https://github.com/rrousselGit/riverpod/tree/master/examples/marvel",
    // },
    // {
    //   type: "link",
    //   label: "Optimistic UI (WIP)",
    //   href: "https://github.com/rrousselGit/riverpod/tree/master/examples/marvel",
    // },
    // {
    //   type: "link",
    //   label: "HTTP polling (WIP)",
    //   href: "https://github.com/rrousselGit/riverpod/tree/master/examples/marvel",
    // },
    // {
    //   type: "link",
    //   label: "Debouncing requests (WIP)",
    //   href: "https://github.com/rrousselGit/riverpod/tree/master/examples/marvel",
    // },
    // {
    //   type: "link",
    //   label: "Cancelling unused network requests (WIP)",
    //   href: "https://github.com/rrousselGit/riverpod/tree/master/examples/marvel",
    // },
    // {
    //   type: "link",
    //   label: "Delaying requests until a certain value is set (WIP)",
    //   href: "https://github.com/rrousselGit/riverpod/tree/master/examples/marvel",
    // },
    // {
    //   type: "link",
    //   label: "Deduplicating network requests (WIP)",
    //   href: "https://github.com/rrousselGit/riverpod/tree/master/examples/marvel",
    // },
    // {
    //   type: "link",
    //   label: "Show snackbar on error (WIP)",
    //   href: "https://github.com/rrousselGit/riverpod/tree/master/examples/marvel",
    // },
    // {
    //   type: "link",
    //   label: "Search as we type (WIP)",
    //   href: "https://github.com/rrousselGit/riverpod/tree/master/examples/marvel",
    // },
    // {
    //   type: "link",
    //   label: "Reading InheritedWidgets inside providers (WIP)",
    //   href: "https://github.com/rrousselGit/riverpod/tree/master/examples/marvel",
    // },
    //   ],
    // },

    // Tutorials
    // {
    // type: "category",
    // label: "Tutorials",
    // collapsible: false,
    // items: [
    // {
    //   type: "link",
    //   label: "Multi-step forms (WIP)",
    //   href: "https://github.com/rrousselGit/riverpod/tree/master/examples/marvel",
    // },
    // {
    //   type: "link",
    //   label: "Building a login page (WIP)",
    //   href: "https://github.com/rrousselGit/riverpod/tree/master/examples/marvel",
    // },
    // ],
    // },

    // Advanced
    {
      type: "category",
      label: "Advanced topics",
      collapsible: false,
      items: [
        // {
        //   type: "link",
        //   label: "Scoping providers (WIP)",
        //   href: "https://github.com/rrousselGit/riverpod/tree/master/examples/marvel",
        // },
        "advanced/select",
      ],
    },

    // Concepts
    {
      type: "category",
      label: "Concepts",
      collapsible: false,
      items: [
        "concepts/about_code_generation",
        "concepts/about_hooks",
        // {
        //   type: "link",
        //   label: "Provider life-cycles (WIP)",
        //   href: "https://github.com/rrousselGit/riverpod/tree/master/examples/marvel",
        // },
        // {
        //   type: "link",
        //   label: "Why immutability (WIP)",
        //   href: "https://github.com/rrousselGit/riverpod/tree/master/examples/marvel",
        // },
      ],
    },

    // Migration guides
    {
      type: "category",
      label: "Migration guides",
      collapsible: false,
      items: [
        "migration/from_state_notifier",
        "migration/from_change_notifier",
        "migration/0.14.0_to_1.0.0",
        "migration/0.13.0_to_0.14.0",
      ],
    },

    // Official examples
    {
      type: "category",
      label: "Official examples",
      collapsed: true,
      items: [
        {
          type: "link",
          label: "Counter",
          href: "https://github.com/rrousselGit/riverpod/tree/master/examples/counter",
        },
        {
          type: "link",
          label: "Todo list",
          href: "https://github.com/rrousselGit/riverpod/tree/master/examples/todos",
        },
        {
          type: "link",
          label: "Pub.dev client",
          href: "https://github.com/rrousselGit/riverpod/tree/master/examples/pub",
        },
        {
          type: "link",
          label: "Marvel API",
          href: "https://github.com/rrousselGit/riverpod/tree/master/examples/marvel",
        },
      ],
    },

    // Third party examples
    {
      type: "category",
      label: "Third party examples",
      collapsed: true,
      items: [
        {
          type: "link",
          label: "DummyMart: Full CRUD app with authentication + go_router integration",
          href: "https://github.com/dhafinrayhan/dummymart",
        },
        {
          type: "link",
          label: "Easy Todo Riverpod Architecture",
          href: "https://github.com/ilovekimchi6/todo_easy_riverpod_architecture",
        },
        {
          type: "link",
          label: "Android Launcher",
          href: "https://github.com/lohanidamodar/fl_live_launcher",
        },
        {
          type: "link",
          label: "Worldtime Clock",
          href: "https://github.com/lohanidamodar/flutter_worldtime",
        },
        {
          type: "link",
          label: "Dictionary App",
          href: "https://github.com/lohanidamodar/fl_dictio",
        },
        {
          type: "link",
          label: "Time Tracking App (with Firebase)",
          href: "https://github.com/bizz84/starter_architecture_flutter_firebase",
        },
        {
          type: "link",
          label: "Firebase Phone Authentication with Riverpod",
          href: "https://github.com/julienlebren/flutter_firebase_phone_auth_riverpod",
        },
        {
          type: "link",
          label: "ListView paging with search",
          href: "https://github.com/tbm98/flutter_loadmore_search",
        },
        {
          type: "link",
          label: "Resocoder's Weather Bloc to Weather Riverpod V2",
          href: "https://github.com/coyksdev/flutter-bloc-library-v1-tutorial",
        },
        {
          type: "link",
          label: "Blood Pressure Tracker App",
          href: "https://github.com/UrosTodosijevic/blood_pressure_tracker",
        },
        {
          type: "link",
          label:
            "Firebase Authentication with Riverpod Following Flutter DDD Architecture Pattern",
          href: "https://github.com/pythonhubpy/firebase_authentication_flutter_DDD",
        },
        {
          type: "link",
          label: "Todo App with Backup and Restore feature",
          href: "https://github.com/TheAlphaApp/flutter_riverpod_todo_app",
        },
        {
          type: "link",
          label: "Integrating Hive database with Riverpod (simple example)",
          href: "https://github.com/GitGud31/theme_riverpod_hive",
        },
        {
          type: "link",
          label: "Browser App with Riverpod",
          href: "https://github.com/MarioCroSite/simple_browser_app",
        },
        {
          type: "link",
          label: "GoRouter with Riverpod",
          href: "https://github.com/lucavenir/go_router_riverpod",
        },
        {
          type: "link",
          label: "Piano Chords Test",
          href: "https://github.com/akvus/piano_fun",
        },
        {
          type: "link",
          label: "Movies API App with Caching & Pagination",
          href: "https://github.com/Roaa94/movies_app",
        },
        {
          type: "link",
          label: "AWS Amplify Storage Gallery App with Riverpod & Freezed",
          href: "https://github.com/offlineprogrammer/amplify_storage_app",
        },
        {
          type: "link",
          label: "Clean Architecture demonstration with Riverpod",
          href: "https://github.com/Uuttssaavv/flutter-clean-architecture-riverpod",
        },
        {
          type: "link",
          label: "Delivery App with Google Maps and Live Tracking",
          href: "https://github.com/AhmedLSayed9/deliverzler",
        },
        {
          type: "link",
          label: "ChatGPT Chat App with Riverpod",
          href: "https://github.com/never-inc/chat_gpt_boilerplate",
        },
      ],
    },

    {
      type: "link",
      label: "API reference",
      href: "https://pub.dev/documentation/hooks_riverpod/latest/hooks_riverpod/hooks_riverpod-library.html",
    },

    {
      type: "category",
      label: "Concepts 🚧",
      items: [
        "concepts/providers",
        "concepts/reading",
        "concepts/combining_providers",
        {
          type: "category",
          label: "Modifiers",
          items: [
            "concepts/modifiers/family",
            "concepts/modifiers/auto_dispose",
          ],
        },
        "concepts/provider_observer",
        "concepts/scopes",
        "concepts/provider_lifecycles",
        "concepts/why_immutability",
      ],
    },

    {
      type: "category",
      label: "All Providers 🚧",
      items: [
        "providers/provider",
        "providers/notifier_provider",
        "providers/state_notifier_provider",
        "providers/future_provider",
        "providers/stream_provider",
        "providers/state_provider",
        "providers/change_notifier_provider",
      ],
    },

    {
      type: "category",
      label: "Guides 🚧",
      items: ["cookbooks/testing"],
    },
  ],
};
