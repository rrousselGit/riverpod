import 'dart:async';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/error/error.dart';
import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:custom_lint_builder/src/node_lint_visitor.dart';
import 'package:meta/meta.dart';
import 'package:riverpod_analyzer_utils/src/riverpod_ast.dart';
import 'package:riverpod_analyzer_utils/src/riverpod_visitor.dart';
import 'package:test/test.dart';

/// Due to [resolveSource] throwing if trying to interact with the resolver
/// after the future completed, we change the syntax to make sure our test
/// executes within the resolver scope.
@isTest
void testSource(
  String description,
  Future<void> Function(Resolver resolver) run, {
  required String source,
}) {
  test(
    description,
    () {
      final enclosingZone = Zone.current;

      return resolveSource('library foo;$source', (resolver) {
        try {
          final originalZone = Zone.current;
          return runZoned(
            () => run(resolver),
            zoneSpecification: ZoneSpecification(
              // Somehow prints are captured inside the callback. Let's restore them
              print: (self, parent, zone, line) => enclosingZone.print(line),
              handleUncaughtError: (self, parent, zone, error, stackTrace) {
                originalZone.handleUncaughtError(error, stackTrace);
                // enclosingZone.print('Oy $error\n$stackTrace');
                enclosingZone.handleUncaughtError(error, stackTrace);
              },
            ),
          );
        } catch (err, stack) {
          enclosingZone.handleUncaughtError(err, stack);
        }
      });
    },
  );
}

extension ResolverX on Resolver {
  Future<Map<String, LegacyProviderDeclaration>>
      parseAllLegacyProviderDeclaration(
    List<String> names, {
    String libraryName = 'foo',
  }) async {
    final declarations =
        await parseAllProviderDeclaration(names, libraryName: libraryName);
    return Map.from(declarations);
  }

  Future<Map<String, GeneratorProviderDeclaration>>
      parseAllGeneratorProviderDeclaration(
    List<String> names, {
    String libraryName = 'foo',
  }) async {
    final declarations =
        await parseAllProviderDeclaration(names, libraryName: libraryName);
    return Map.from(declarations);
  }

  Future<Map<String, ProviderDeclaration>> parseAllProviderDeclaration(
    List<String> names, {
    String libraryName = 'foo',
  }) async {
    final nodeLintRegistry = NodeLintRegistry(
      LintRegistry(),
      enableTiming: false,
    );
    final lintRuleNodeRegistry = LintRuleNodeRegistry(
      nodeLintRegistry,
      '',
    );
    final visitor = RiverpodVisitor(
      lintRuleNodeRegistry,
    );

    final declarations = <String, ProviderDeclaration>{};
    visitor.addProviderDeclaration((p0) => declarations[p0.name.lexeme] = p0);

    final library = await findLibraryByName(libraryName);
    final libraryAst =
        await library!.session.getResolvedLibraryByElement(library);

    libraryAst as ResolvedLibraryResult;
    libraryAst.units.first.unit.accept(
      LinterVisitor(nodeLintRegistry),
    );

    return Map.fromEntries(
      names.map((name) {
        final declaration = declarations[name];
        if (declaration == null) {
          throw StateError('No declaration found for $name');
        }
        return MapEntry(name, declaration);
      }),
    );
  }

  Future<LibraryElement> requireFindLibraryByName([
    String libraryName = 'foo',
  ]) async {
    final library = await findLibraryByName(libraryName);
    if (library == null) {
      throw StateError('No library found for name "$libraryName"');
    }

    final errorResult = await library.session
        .getErrors('/_resolve_source/lib/_resolve_source.dart');

    if (errorResult is ErrorsResult) {
      final errors = errorResult.errors
          // Infos are only recommendations. There's no reason to fail just for this
          .where((e) => e.severity != Severity.info)
          // Since we're using code-generation, some types may be undefined.
          // To avoid having to include a fake generated code to silence errors,
          // we explicitly ignore errors related to missing generated elements.
          .where((e) => !e.isMissingRefType && !e.isMissingBaseNotifierClass)
          .toList();

      if (errors.isNotEmpty) {
        throw StateError('''
The parsed library has errors:
${errors.map((e) => '- $e\n').join()}
''');
      }
    }

    return library;
  }
}

extension LibraryElementX on LibraryElement {
  Element findElementWithName(String name) {
    return topLevelElements.singleWhere(
      (element) => !element.isSynthetic && element.name == name,
      orElse: () => throw StateError('No element found with name "$name"'),
    );
  }
}

extension on AnalysisError {
  bool get isMissingRefType {
    return errorCode.name == 'UNDEFINED_CLASS' &&
        RegExp(r"Undefined class '\w+Ref'.").hasMatch(message);
  }

  bool get isMissingBaseNotifierClass {
    return errorCode.name == 'EXTENDS_NON_CLASS' &&
        message == 'Classes can only extend other classes.';
  }
}
