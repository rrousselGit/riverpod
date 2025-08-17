module.exports = {
  Sidebar: [
    "whats_new",
    "3.0_migration",
    "introduction/getting_started",
    "root/faq",
    "root/do_dont",
    // Concepts
    {
      type: "category",
      label: "Concepts",
      collapsible: false,
      items: [
        "concepts/about_code_generation",
        "concepts/about_hooks",
        "concepts2/providers",
        "concepts2/consumers",
        "concepts2/refs",
        "concepts2/family",
        "concepts2/containers",
        "concepts2/auto_dispose",
        "concepts2/mutations",
        "concepts2/offline",
        "concepts2/retry",
        "concepts2/observers",
        "concepts2/overrides",
        "concepts2/scoping",
      ],
    },
    {
      type: "category",
      label: "References",
      collapsible: false,
      items: [
        {
          type: "category",
          label: "All Providers",
          items: [
            {
              type: "link",
              label: "Provider",
              href: "https://pub.dev/documentation/hooks_riverpod/3.0.0-dev.17/hooks_riverpod/Provider-class.html",
            },
            {
              type: "link",
              label: "FutureProvider",
              href: "https://pub.dev/documentation/hooks_riverpod/3.0.0-dev.17/hooks_riverpod/FutureProvider-class.html",
            },
            {
              type: "link",
              label: "StreamProvider",
              href: "https://pub.dev/documentation/hooks_riverpod/3.0.0-dev.17/hooks_riverpod/StreamProvider-class.html",
            },
            {
              type: "link",
              label: "NotifierProvider",
              href: "https://pub.dev/documentation/hooks_riverpod/3.0.0-dev.17/hooks_riverpod/NotifierProvider-class.html",
            },
            {
              type: "link",
              label: "AsyncNotifierProvider",
              href: "https://pub.dev/documentation/hooks_riverpod/3.0.0-dev.17/hooks_riverpod/AsyncNotifierProvider-class.html",
            },
            {
              type: "link",
              label: "StreamNotifierProvider",
              href: "https://pub.dev/documentation/hooks_riverpod/3.0.0-dev.17/hooks_riverpod/StreamNotifierProvider-class.html",
            },
            // Legacy
            {
              type: "link",
              label: "ChangeNotifierProvider (legacy)",
              href: "https://pub.dev/documentation/hooks_riverpod/3.0.0-dev.17/legacy/ChangeNotifierProvider-class.html",
            },
            {
              type: "link",
              label: "StateNotifierProvider (legacy)",
              href: "https://pub.dev/documentation/hooks_riverpod/3.0.0-dev.17/legacy/StateNotifierProvider-class.html",
            },
            {
              type: "link",
              label: "StateProvider (legacy)",
              href: "https://pub.dev/documentation/hooks_riverpod/3.0.0-dev.17/legacy/StateProvider-class.html",
            },
          ],
        },
        {
          type: "category",
          label: "Containers/Scopes",
          items: [
            {
              type: "link",
              label: "ProviderContainer",
              href: "https://pub.dev/documentation/hooks_riverpod/3.0.0-dev.17/hooks_riverpod/ProviderContainer-class.html",
            },
            {
              type: "link",
              label: "ProviderScope",
              href: "https://pub.dev/documentation/hooks_riverpod/3.0.0-dev.17/hooks_riverpod/ProviderScope-class.html",
            },
            {
              type: "link",
              label: "UncontrolledProviderScope",
              href: "https://pub.dev/documentation/hooks_riverpod/3.0.0-dev.17/hooks_riverpod/UncontrolledProviderScope-class.html",
            },
          ],
        },
        {
          type: "category",
          label: "Refs",
          items: [
            {
              type: "link",
              label: "Ref",
              href: "https://pub.dev/documentation/hooks_riverpod/3.0.0-dev.17/hooks_riverpod/Ref-class.html",
            },
            {
              type: "link",
              label: "WidgetRef",
              href: "https://pub.dev/documentation/hooks_riverpod/3.0.0-dev.17/hooks_riverpod/WidgetRef-class.html",
            },
          ],
        },
        {
          type: "category",
          label: "Consumers",
          items: [
            {
              type: "link",
              label: "ConsumerWidget",
              href: "https://pub.dev/documentation/hooks_riverpod/3.0.0-dev.17/hooks_riverpod/ConsumerWidget-class.html",
            },
            {
              type: "link",
              label: "ConsumerStatefulWidget",
              href: "https://pub.dev/documentation/hooks_riverpod/3.0.0-dev.17/hooks_riverpod/ConsumerStatefulWidget-class.html",
            },
            {
              type: "link",
              label: "Consumer",
              href: "https://pub.dev/documentation/hooks_riverpod/3.0.0-dev.17/hooks_riverpod/Consumer-class.html",
            },
            {
              type: "link",
              label: "HookConsumerWidget",
              href: "https://pub.dev/documentation/hooks_riverpod/3.0.0-dev.17/hooks_riverpod/HookConsumerWidget-class.html",
            },
            {
              type: "link",
              label: "HookConsumer",
              href: "https://pub.dev/documentation/hooks_riverpod/3.0.0-dev.17/hooks_riverpod/HookConsumer-class.html",
            },
          ],
        },
        {
          type: "category",
          label: "Offline persistence (experimental)",
          items: [
            {
              type: "link",
              label: "Storage (experimental)",
              href: "https://pub.dev/documentation/hooks_riverpod/3.0.0-dev.17/experimental_persist/Storage-class.html",
            },
            {
              type: "link",
              label: "Persistable (experimental)",
              href: "https://pub.dev/documentation/hooks_riverpod/3.0.0-dev.17/experimental_persist/Persistable-mixin.html",
            },
          ],
        },
        {
          type: "category",
          label: "Mutations (experimental)",
          items: [
            {
              type: "link",
              label: "Mutation",
              href: "https://pub.dev/documentation/hooks_riverpod/3.0.0-dev.17/experimental_mutation/Mutation-class.html",
            },
            {
              type: "link",
              label: "MutationTransaction",
              href: "https://pub.dev/documentation/hooks_riverpod/3.0.0-dev.17/experimental_mutation/MutationTransaction-class.html",
            },
            {
              type: "link",
              label: "MutationState",
              href: "https://pub.dev/documentation/hooks_riverpod/3.0.0-dev.17/experimental_mutation/MutationState-class.html",
            },
          ],
        },
        {
          type: "category",
          label: "core",
          items: [
            {
              type: "link",
              label: "AsyncValue",
              href: "https://pub.dev/documentation/hooks_riverpod/3.0.0-dev.17/hooks_riverpod/AsyncValue-class.html",
            },
            {
              type: "link",
              label: "ProviderObserver",
              href: "https://pub.dev/documentation/hooks_riverpod/3.0.0-dev.17/hooks_riverpod/ProviderObserver-class.html",
            },
            {
              type: "link",
              label: "ProviderSubscription",
              href: "https://pub.dev/documentation/hooks_riverpod/3.0.0-dev.17/hooks_riverpod/ProviderSubscription-class.html",
            },
          ],
        },

        {
          type: "link",
          label: "misc",
          href: "https://pub.dev/documentation/hooks_riverpod/3.0.0-dev.17/misc/",
        },
      ],
    },

    {
      type: "category",
      label: "How to",
      collapsible: false,
      items: ["how_to/eager_initialization", "how_to/testing", "how_to/select"],
    },

    // Case studies
    {
      type: "category",
      label: "Case studies",
      collapsible: false,
      items: ["case_studies/pull_to_refresh", "case_studies/cancel"],
    },

    // Migration guides
    {
      type: "category",
      label: "Migration guides",
      collapsible: false,
      items: [
        {
          type: "category",
          label: "Riverpod for Provider Users",
          items: [
            "from_provider/quickstart",
            "from_provider/provider_vs_riverpod",
            "from_provider/motivation/motivation",
          ],
        },
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
          label:
            "DummyMart: Full CRUD app with authentication + go_router integration",
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
  ],
};
