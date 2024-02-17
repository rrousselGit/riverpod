import 'dart:async';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:meta/meta.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:riverpod_analyzer_utils/src/riverpod_ast.dart'
    show
        // ignore: invalid_use_of_internal_member
        RiverpodAnalysisResult;
import 'package:riverpod_generator/src/riverpod_generator.dart';
import 'package:test/test.dart';

int _testNumber = 0;

/// Due to [resolveSource] throwing if trying to interact with the resolver
/// after the future completed, we change the syntax to make sure our test
/// executes within the resolver scope.
@isTest
void testSource(
  String description,
  Future<void> Function(Resolver resolver) run, {
  required String source,
  Map<String, String> files = const {},
  bool runGenerator = false,
  Timeout? timeout,
}) {
  final testId = _testNumber++;
  test(
    description,
    timeout: timeout,
    () async {
      // Giving a unique name to the package to avoid the analyzer cache
      // messing up tests.
      final packageName = 'test_lib$testId';
      final sourceWithLibrary = 'library foo;$source';

      final enclosingZone = Zone.current;

      final otherSources = {
        for (final entry in files.entries)
          '$packageName|lib/${entry.key}':
              'library "${entry.key}"; ${entry.value}',
      };

      String? generated;
      if (runGenerator) {
        final analysisResult = await resolveSources(
          {
            '$packageName|lib/foo.dart': sourceWithLibrary,
            ...otherSources,
          },
          (resolver) {
            return resolver.resolveRiverpodLibraryResult(
              ignoreErrors: true,
            );
          },
        );
        generated = RiverpodGenerator(const {}).runGenerator(analysisResult);
      }

      await resolveSources({
        '$packageName|lib/foo.dart': sourceWithLibrary,
        if (generated != null)
          '$packageName|lib/foo.g.dart': 'part of "foo.dart";$generated',
        ...otherSources,
      }, (resolver) async {
        try {
          final originalZone = Zone.current;
          return runZoned(
            () => run(resolver),
            zoneSpecification: ZoneSpecification(
              // Somehow prints are captured inside the callback. Let's restore them
              print: (self, parent, zone, line) => enclosingZone.print(line),
              handleUncaughtError: (self, parent, zone, error, stackTrace) {
                originalZone.handleUncaughtError(error, stackTrace);
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

extension MapTake<Key, Value> on Map<Key, Value> {
  Map<Key, Value> take(List<Key> keys) {
    return <Key, Value>{
      for (final key in keys)
        if (!containsKey(key))
          key: throw StateError('No key $key found')
        else
          key: this[key] as Value,
    };
  }
}

extension ResolverX on Resolver {
  // ignore: invalid_use_of_internal_member
  Future<RiverpodAnalysisResult> resolveRiverpodAnalysisResult({
    String libraryName = 'foo',
    bool ignoreErrors = false,
  }) async {
    final riverpodAst = await resolveRiverpodLibraryResult(
      libraryName: libraryName,
      ignoreErrors: ignoreErrors,
    );

    final result = RiverpodAnalysisResult();

    for (final unit in riverpodAst.units) {
      unit.accept(result);
    }

    if (!ignoreErrors) {
      final errors =
          result.riverpodCompilationUnits.expand((e) => e.errors).toList();
      if (errors.isNotEmpty) {
        throw StateError(errors.map((e) => '- $e\n').join());
      }
    }

    return result;
  }

  Future<ResolvedRiverpodLibraryResult> resolveRiverpodLibraryResult({
    String libraryName = 'foo',
    bool ignoreErrors = false,
  }) async {
    final library = await requireFindLibraryByName(
      libraryName,
      ignoreErrors: ignoreErrors,
    );
    final libraryAst =
        await library.session.getResolvedLibraryByElement(library);
    libraryAst as ResolvedLibraryResult;

    final result = ResolvedRiverpodLibraryResult.from(
      libraryAst.units.map((e) => e.unit).toList(),
    );

    expectValidParentChildrenRelationship(result);

    return result;
  }

  Future<LibraryElement> requireFindLibraryByName(
    String libraryName, {
    required bool ignoreErrors,
  }) async {
    final library = await findLibraryByName(libraryName);
    if (library == null) {
      throw StateError('No library found for name "$libraryName"');
    }

    if (!ignoreErrors) {
      final errorResult =
          await library.session.getErrors('/test_lib/lib/foo.dart');
      errorResult as ErrorsResult;

      final errors = errorResult.errors
          // Infos are only recommendations. There's no reason to fail just for this
          .where((e) => e.severity != Severity.info)
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

/// Visit all the nodes of the AST and ensure that that all children
/// have the correct parent.
void expectValidParentChildrenRelationship(
  ResolvedRiverpodLibraryResult result,
) {
  for (final unit in result.units) {
    unit.accept(_ParentRiverpodVisitor(null));
  }
}

class _ParentRiverpodVisitor extends GeneralizingRiverpodAstVisitor {
  _ParentRiverpodVisitor(this.expectedParent);

  final RiverpodAst? expectedParent;

  @override
  void visitRiverpodAst(
    RiverpodAst node,
  ) {
    expect(
      node.parent,
      expectedParent,
      reason: 'Node ${node.runtimeType} should have $expectedParent as parent',
    );
    node.visitChildren(_ParentRiverpodVisitor(node));
  }
}

extension TakeList<T extends ProviderDeclaration> on List<T> {
  Map<String, T> takeAll(List<String> names) {
    final result = Map.fromEntries(map((e) => MapEntry(e.name.lexeme, e)));
    return result.take(names);
  }

  T findByName(String name) {
    return singleWhere((element) => element.name.lexeme == name);
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
