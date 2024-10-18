import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';

SourceRange sourceRangeFrom({required int start, required int end}) {
  return SourceRange(start, end - start);
}

String refNameFor(ProviderDeclaration provider) => 'Ref';

String classNameFor(ProviderDeclaration provider) {
  return provider.name.lexeme.titled;
}

String generatedClassNameFor(ProviderDeclaration provider) {
  return '_\$${provider.name.lexeme.titled.public}';
}

extension CaseChangeExtension on String {
  String get titled {
    return replaceFirstMapped(
      RegExp('[a-zA-Z]'),
      (match) => match.group(0)!.toUpperCase(),
    );
  }

  String get lowerFirst {
    return replaceFirstMapped(
      RegExp('[a-zA-Z]'),
      (match) => match.group(0)!.toLowerCase(),
    );
  }

  String get public {
    if (startsWith('_')) return substring(1);
    return this;
  }
}

abstract class RiverpodAssist extends DartAssist with _ParseRiverpod {
  @override
  Future<void> startUp(
    CustomLintResolver resolver,
    CustomLintContext context,
    SourceRange target,
  ) async {
    await _setupRiverpod(resolver, context);
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
    await _setupRiverpod(resolver, context);
    await super.startUp(resolver, context);
  }
}

abstract class RiverpodFix extends DartFix with _ParseRiverpod {
  @override
  Future<void> startUp(
    CustomLintResolver resolver,
    CustomLintContext context,
  ) async {
    await _setupRiverpod(resolver, context);
    await super.startUp(resolver, context);
  }
}

mixin _ParseRiverpod {
  static final _contextKey = Object();

  Future<void> _setupRiverpod(
    CustomLintResolver resolver,
    CustomLintContext context,
  ) async {
    if (context.sharedState.containsKey(_contextKey)) return;
    // Only run the riverpod parsing logic once
    final registry = context.sharedState[_contextKey] = RiverpodAstRegistry();

    final unit = await resolver.getResolvedUnitResult();
    final result = ResolvedRiverpodLibraryResult.from([unit.unit]);

    context.addPostRunCallback(() => registry.run(result));
  }

  RiverpodAstRegistry riverpodRegistry(CustomLintContext context) {
    final registry = context.sharedState[_contextKey] as RiverpodAstRegistry?;
    if (registry == null) {
      throw StateError('RiverpodAstRegistry not initialized');
    }
    return registry;
  }
}
