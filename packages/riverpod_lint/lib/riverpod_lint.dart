import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/assists/convert_to_consumer_stateful_widget.dart';
import 'src/assists/convert_to_consumer_widget.dart';
import 'src/assists/stateful_to_stateless_provider.dart';
import 'src/assists/stateless_to_stateful_provider.dart';
import 'src/assists/wrap_with_consumer.dart';
import 'src/assists/wrap_with_provider_scope.dart';
import 'src/lints/generator_class_extends.dart';
import 'src/lints/missing_provider_scope.dart';
import 'src/lints/provider_parameters.dart';
import 'src/lints/stateless_ref.dart';

PluginBase createPlugin() => _RiverpodPlugin();

class _RiverpodPlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        const StatelessRef(),
        const MissingProviderScope(),
        const ProviderParameters(),
        const GeneratorClassExtends(),
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

// Hook usage in non-hook widget
      ];

  @override
  List<Assist> getAssists() => [
        WrapWithConsumer(),
        WrapWithProviderScope(),
        ConvertToConsumerWidget(),
        ConvertToConsumerStatefulWidget(),

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
