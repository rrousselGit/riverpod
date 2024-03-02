import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/assists/class_based_to_functional_provider.dart';
import 'src/assists/convert_to_stateful_base_widget.dart';
import 'src/assists/convert_to_stateless_base_widget.dart';
import 'src/assists/convert_to_widget_utils.dart';
import 'src/assists/functional_to_class_based_provider.dart';
import 'src/assists/wrap_with_consumer.dart';
import 'src/assists/wrap_with_provider_scope.dart';
import 'src/lints/async_value_nullable_pattern.dart';
import 'src/lints/avoid_build_context_in_providers.dart';
import 'src/lints/avoid_manual_providers_as_generated_provider_dependency.dart';
import 'src/lints/avoid_public_notifier_properties.dart';
import 'src/lints/avoid_ref_inside_state_dispose.dart';
import 'src/lints/functional_ref.dart';
import 'src/lints/missing_provider_scope.dart';
import 'src/lints/notifier_build.dart';
import 'src/lints/notifier_extends.dart';
import 'src/lints/protected_notifier_properties.dart';
import 'src/lints/provider_dependencies.dart';
import 'src/lints/provider_parameters.dart';
import 'src/lints/scoped_providers_should_specify_dependencies.dart';
import 'src/lints/unsupported_provider_value.dart';

PluginBase createPlugin() => _RiverpodPlugin();

class _RiverpodPlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        const AvoidBuildContextInProviders(),
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
        const AsyncValueNullablePattern(),
        const ProtectedNotifierProperties(),
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
        FunctionalToClassBasedProvider(),
        ClassBasedToFunctionalProvider(),
      ];
}
