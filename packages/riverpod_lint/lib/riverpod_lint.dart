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
//  "Avoid passing providers as parameter to objects"
        const AvoidExposingProviderRef(),
        const AvoidExposingWidgetRef(),
        const AvoidGlobalProviderContainer(),
        const AvoidReadAutoDispose(),
        const AvoidReadInsideBuild(),
        const AvoidWatchOutsideBuild(),
        const DontModifyProvidersDuringInit(),
//  async ref.watch(autoDispose) (typically inside FutureProviders)
        const DontModifyProvidersInsideWidgetLifecycles(),
        const PreferFinalProvider(),
        const ProviderMissingDependency(),
        const ProviderUnsusedDependency(),
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
        StatelessToStatefulProvider(),
        StatefulToStatelessProvider(),
      ];
}
