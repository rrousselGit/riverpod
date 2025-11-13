import 'dart:async';
import 'dart:io';

import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';

import 'src/assists/providers/class_based_to_functional_provider.dart';
import 'src/assists/wrap/wrap_with_consumer.dart';
import 'src/lints/async_value_nullable_pattern.dart';

final plugin = _RiverpodPlugin();

void log(Object obj) {
  File('/Users/ext-remi.rousselet/dev/rrousselGit/riverpod/log.txt')
    ..createSync(recursive: true)
    ..writeAsStringSync('$obj\n', mode: FileMode.append);
}

class _RiverpodPlugin extends Plugin {
  @override
  String get name => 'riverpod_lint';

  @override
  FutureOr<void> register(PluginRegistry registry) {
    registry.registerWarningRule(AsyncValueNullablePattern());
    registry.registerFixForRule(
      AsyncValueNullablePattern.code,
      RemoveNullCheckPatternAndAddHasDataCheck.new,
    );

    registry.registerAssist(WrapWithConsumer.new);

    registry.registerAssist(ClassBasedToFunctionalProvider.new);
  }

  // @override
  // List<RiverpodLintRule> getLintRules(CustomLintConfigs configs) => [
  //   const AsyncValueNullablePattern(),
  //   const AvoidBuildContextInProviders(),
  //   const OnlyUseKeepAliveInsideKeepAlive(),
  //   const AvoidPublicNotifierProperties(),
  //   const AvoidRefInsideStateDispose(),
  //   const FunctionalRef(),
  //   const MissingProviderScope(),
  //   const NotifierBuild(),
  //   const NotifierExtends(),
  //   const ProtectedNotifierProperties(),
  //   const ProviderDependencies(),
  //   const ProviderParameters(),
  //   const RiverpodSyntaxError(),
  //   const ScopedProvidersShouldSpecifyDependencies(),
  //   const UnsupportedProviderValue(),
  // ];

  // @override
  // List<Assist> getAssists() => [
  //   WrapWithConsumer(),
  //   WrapWithProviderScope(),
  //   ...StatelessBaseWidgetType.values.map(
  //     (targetWidget) =>
  //         ConvertToStatelessBaseWidget(targetWidget: targetWidget),
  //   ),
  //   ...StatefulBaseWidgetType.values.map(
  //     (targetWidget) => ConvertToStatefulBaseWidget(targetWidget: targetWidget),
  //   ),
  //   FunctionalToClassBasedProvider(),
  //   ClassBasedToFunctionalProvider(),
  // ];
}
