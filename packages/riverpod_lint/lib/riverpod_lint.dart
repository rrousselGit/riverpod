import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/assists/stateful_to_stateless_provider.dart';
import 'src/assists/stateless_to_stateful_provider.dart';
import 'src/lints/avoid_dynamic_providers.dart';
import 'src/lints/avoid_exposing_provider_ref.dart';
import 'src/lints/avoid_exposing_widget_ref.dart';
import 'src/lints/avoid_global_provider_container.dart';
import 'src/lints/avoid_read_auto_dispose.dart';
import 'src/lints/avoid_read_inside_build.dart';
import 'src/lints/avoid_watch_outside_build.dart';
import 'src/lints/dont_modify_providers_during_init.dart';
import 'src/lints/dont_modify_providers_inside_widget_lifecycles.dart';
import 'src/lints/prefer_final_provider.dart';
import 'src/lints/provider_missing_dependency.dart';
import 'src/lints/provider_unused_dependency.dart';

PluginBase createPlugin() => _RiverpodPlugin();

class _RiverpodPlugin extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        const AvoidDynamicProviders(),
        const AvoidExposingProviderRef(),
        const AvoidExposingWidgetRef(),
        const AvoidGlobalProviderContainer(),
        const AvoidReadAutoDispose(),
        const AvoidReadInsideBuild(),
        const AvoidWatchOutsideBuild(),
        const DontModifyProvidersDuringInit(),
        const DontModifyProvidersInsideWidgetLifecycles(),
        const PreferFinalProvider(),
        const ProviderMissingDependency(),
        const ProviderUnsusedDependency(),
      ];

  @override
  List<Assist> getAssists() => [
        StatelessToStatefulProvider(),
        StatefulToStatelessProvider(),
      ];
}
