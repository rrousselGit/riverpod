import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

abstract class RiverpodAssist extends DartAssist with _ParseRiverpod {
  @override
  Future<void> startUp(
    CustomLintResolver resolver,
    CustomLintContext context,
    SourceRange target,
  ) async {
    _setupRiverpod(context);
    await super.startUp(resolver, context, target);
  }
}

abstract class RiverpodLintRule extends DartLintRule with _ParseRiverpod {
  const RiverpodLintRule({required super.code});

  @override
  Future<void> startUp(
    CustomLintResolver resolver,
    CustomLintContext context,
  ) async {
    _setupRiverpod(context);
    await super.startUp(resolver, context);
  }
}

abstract class RiverpodFix extends DartFix with _ParseRiverpod {
  @override
  Future<void> startUp(
    CustomLintResolver resolver,
    CustomLintContext context,
  ) async {
    _setupRiverpod(context);
    await super.startUp(resolver, context);
  }
}

mixin _ParseRiverpod {
  static final _contextKey = Object();

  void _setupRiverpod(CustomLintContext context) {
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
