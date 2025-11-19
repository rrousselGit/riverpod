import 'dart:io';

import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';

import 'src/assists/consumers/convert_to_stateful_base_widget.dart';
import 'src/assists/consumers/convert_to_stateless_base_widget.dart';
import 'src/assists/providers/class_based_to_functional_provider.dart';
import 'src/assists/providers/functional_to_class_based_provider.dart';
import 'src/assists/wrap/wrap_with_consumer.dart';
import 'src/assists/wrap/wrap_with_provider_scope.dart';
import 'src/lints/async_value_nullable_pattern.dart';
import 'src/lints/avoid_build_context_in_providers.dart';
import 'src/lints/avoid_public_notifier_properties.dart';
import 'src/lints/avoid_ref_inside_state_dispose.dart';
import 'src/lints/functional_ref.dart';
import 'src/lints/missing_provider_scope.dart';
import 'src/lints/notifier_build.dart';
import 'src/lints/notifier_extends.dart';
import 'src/lints/only_use_keep_alive_inside_keep_alive.dart';
import 'src/lints/protected_notifier_properties.dart';
import 'src/lints/provider_dependencies.dart';
import 'src/lints/provider_parameters.dart';
import 'src/lints/riverpod_syntax_error.dart';
import 'src/lints/scoped_providers_should_specify_dependencies.dart';
import 'src/lints/unsupported_provider_value.dart';

final plugin = _RiverpodPlugin();

void log(Object obj) {
  File('/Users/remirousselet/dev/rrousselGit/riverpod/log.txt')
    ..createSync(recursive: true)
    ..writeAsStringSync('$obj\n', mode: FileMode.append);
}

class _RiverpodPlugin extends Plugin {
  @override
  String get name => 'riverpod_lint';

  @override
  void register(PluginRegistry registry) {
    registry.registerWarningRule(AsyncValueNullablePattern());
    registry.registerFixForRule(
      AsyncValueNullablePattern.code,
      RemoveNullCheckPatternAndAddHasDataCheck.new,
    );

    registry.registerWarningRule(AvoidBuildContextInProviders());
    registry.registerWarningRule(AvoidPublicNotifierProperties());
    registry.registerWarningRule(AvoidRefInsideStateDispose());
    
    registry.registerWarningRule(FunctionalRef());
    registry.registerFixForRule(FunctionalRef.code, FunctionalRefFix.new);

    registry.registerWarningRule(MissingProviderScope());
    registry.registerFixForRule(MissingProviderScope.code, AddProviderScope.new);

    registry.registerWarningRule(NotifierBuild());
    registry.registerFixForRule(NotifierBuild.code, AddBuildMethodFix.new);

    registry.registerWarningRule(NotifierExtends());
    registry.registerFixForRule(NotifierExtends.code, NotifierExtendsFix.new);

    registry.registerWarningRule(OnlyUseKeepAliveInsideKeepAlive());
    registry.registerWarningRule(ProtectedNotifierProperties());

    registry.registerWarningRule(ProviderDependencies());
    registry.registerFixForRule(ProviderDependencies.code, ProviderDependenciesFix.new);

    registry.registerWarningRule(ProviderParameters());
    registry.registerWarningRule(RiverpodSyntaxError());
    registry.registerWarningRule(ScopedProvidersShouldSpecifyDependencies());
    registry.registerWarningRule(UnsupportedProviderValue());

    registry.registerAssist(WrapWithConsumer.new);
    registry.registerAssist(WrapWithProviderScope.new);

    registry.registerAssist(ClassBasedToFunctionalProvider.new);
    registry.registerAssist(FunctionalToClassBasedProvider.new);

    // Stateless widget conversions
    registry.registerAssist(ConvertToHookConsumerWidget.new);
    registry.registerAssist(ConvertToHookWidget.new);
    registry.registerAssist(ConvertToConsumerWidget.new);
    registry.registerAssist(ConvertToStatelessWidget.new);

    // Stateful widget conversions
    registry.registerAssist(ConvertToStatefulHookConsumerWidget.new);
    registry.registerAssist(ConvertToStatefulHookWidget.new);
    registry.registerAssist(ConvertToConsumerStatefulWidget.new);
    registry.registerAssist(ConvertToStatefulWidget.new);
  }
}
