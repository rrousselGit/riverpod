import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/assists/class_based_to_functional_provider.dart';
import 'src/assists/convert_to_stateful_base_widget.dart';
import 'src/assists/convert_to_stateless_base_widget.dart';
import 'src/assists/convert_to_widget_utils.dart';
import 'src/assists/functional_to_class_based_provider.dart';
import 'src/assists/wrap_with_consumer.dart';
import 'src/assists/wrap_with_provider_scope.dart';
import 'src/lints/avoid_generated_classes_as_return_type.dart';
import 'src/lints/avoid_manual_providers_as_generated_provider_dependency.dart';
import 'src/lints/avoid_public_notifier_properties.dart';
import 'src/lints/avoid_ref_inside_state_dispose.dart';
import 'src/lints/functional_ref.dart';
import 'src/lints/missing_provider_scope.dart';
import 'src/lints/notifier_build.dart';
import 'src/lints/notifier_extends.dart';
import 'src/lints/provider_dependencies.dart';
import 'src/lints/provider_parameters.dart';
import 'src/lints/scoped_providers_should_specify_dependencies.dart';
import 'src/lints/unsupported_provider_value.dart';

PluginBase createPlugin() => _RiverpodPlugin();

class _RiverpodPlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        const AvoidGeneratedClassesAsReturnType(),
        const AvoidPublicNotifierProperties(),
        const FunctionalRef(),
        const MissingProviderScope(),
        const ProviderParameters(),
        const NotifierExtends(),
        const ProviderDependencies(),
        const AvoidManualProvidersAsGeneratedProviderDependency(),
        const ScopedProvidersShouldSpecifyDependencies(),
        const UnsupportedProviderValue(),
        const AvoidRefInsideStateDispose(),
        const NotifierBuild(),
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
        ...StatelessBaseWidgetType.values.map(
          (targetWidget) => ConvertToStatelessBaseWidget(
            targetWidget: targetWidget,
          ),
        ),
        ...StatefulBaseWidgetType.values.map(
          (targetWidget) => ConvertToStatefulBaseWidget(
            targetWidget: targetWidget,
          ),
        ),

// StateProvider to SyncClassBasedProvider
// convert FutureProvider <> AsyncNotifierProvider
// convert Provider <> NotifierProvider
// convert *Notifier <> autoDispose/family
// Notifier/AsyncNotifier/FutureProvider -> generator
// Convert StateNotifier -> Notifier
// Convert StateNotifier<AsyncValue> -> AsyncNotifier

        FunctionalToClassBasedProvider(),
        ClassBasedToFunctionalProvider(),
      ];
}
