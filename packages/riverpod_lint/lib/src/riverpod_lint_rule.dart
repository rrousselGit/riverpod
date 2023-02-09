import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

abstract class RiverpodLintRule extends DartLintRule {
  const RiverpodLintRule({required super.code});

  static final _contextKey = Object();

  @override
  Future<void> startUp(
    CustomLintResolver resolver,
    CustomLintContext context,
  ) async {
    await super.startUp(resolver, context);

    if (context.sharedState.containsKey(_contextKey)) return;
    // Only run the riverpod parsing logic once
    context.sharedState[_contextKey] = RiverpodRegistry(context.registry);
  }

  RiverpodRegistry riverpodRegistry(CustomLintContext context) {
    final registry = context.sharedState[_contextKey] as RiverpodRegistry?;
    if (registry == null) {
      throw StateError('RiverpodRegistry not initialized');
    }
    return registry;
  }
}
