import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/assists/stateful_to_stateless_provider.dart';
import 'src/assists/stateless_to_stateful_provider.dart';
import 'src/lints/stateless_ref.dart';

PluginBase createPlugin() => _RiverpodPlugin();

class _RiverpodPlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        const StatelessRef(),
//         const AvoidDynamicProviders(),
// //  "Avoid passing providers as parameter to objects"
//         const AvoidExposingProviderRef(),
//         const AvoidExposingWidgetRef(),
//         const AvoidGlobalProviderContainer(),
//         const AvoidReadAutoDispose(),
//         const AvoidReadInsideBuild(),
//         const AvoidWatchOutsideBuild(),
//         const DontModifyProvidersDuringInit(),
// //  async ref.watch(autoDispose) (typically inside FutureProviders)
//         const DontModifyProvidersInsideWidgetLifecycles(),
//         const PreferFinalProvider(),
//         const ProviderMissingDependency(),
//         const ProviderUnsusedDependency(),
//  equivalent of use_build_context_synchronously for WidgetRef instead of BuildContext (proposal: extend use_build_context_synchronously to consider Riverpod's WidgetRef dart-lang/linter#3419)
//  ref.watch(family([])) (or other non-constant object instantiation with no == override)
//  check circular dependencies (ref.watch/read/listen checks instead of "dependencies" checks)

//  avoid overrides on non-root ProviderScope/ProviderContainer
//  no ProviderScope detected on runApp
      ];

  @override
  List<Assist> getAssists() => [
//  "wrap in a consumer"
//  "extract to consumer widget"
//  "convert to StatelessWidget to COnsumerWidget"
//  "convert to StatelessWidget to COnsumerHookWidget (if hooks_riverpod is installed)"
//  "convert to StatefulWidgetWidget to COnsumerStatefulWidget
//  "convert to StatefulWidgetWidget to StatefulHookConsumerWidget (if hooks_riverpod is installed)"

// StateProvider to SyncStatefulProvider
// convert FutureProvider <> AsyncNotifierProvider
// convert Provider <> NotifierProvider
// convert *Notifier <> autoDispose/family
// Notifier/AsyncNotifier/FutureProvider -> generator
// Convert StateNotifier -> Notifier
// Convert StateNotifier<AsyncValue> -> AsyncNotifier

        StatelessToStatefulProvider(),
        StatefulToStatelessProvider(),
      ];
}
