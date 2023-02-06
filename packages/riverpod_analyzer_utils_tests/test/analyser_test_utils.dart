import 'dart:async';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/error/error.dart';
import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:meta/meta.dart';
import 'package:riverpod_analyzer_utils/src/riverpod_visitor.dart';
import 'package:riverpod_generator/src/riverpod_generator2.dart';
import 'package:test/test.dart';

/// Due to [resolveSource] throwing if trying to interact with the resolver
/// after the future completed, we change the syntax to make sure our test
/// executes within the resolver scope.
@isTest
void testSource(
  String description,
  Future<void> Function(Resolver resolver) run, {
  required String source,
  bool runGenerator = false,
}) {
  test(
    description,
    () async {
      final sourceWithLibrary = 'library foo;$source';

      final enclosingZone = Zone.current;

      String? generated;
      if (runGenerator) {
        final analysisResult = await resolveSources(
          {'test_lib|lib/foo.dart': sourceWithLibrary},
          (resolver) {
            return resolver.resolveRiverpodAnalyssiResult();
          },
        );
        generated = RiverpodGenerator2(const {}).runGenerator(analysisResult);
      }

      await resolveSources({
        'test_lib|lib/foo.dart': sourceWithLibrary,
        if (generated != null) 'test_lib|lib/foo.g.dart': generated,
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
  Future<RiverpodAnalysisResult> resolveRiverpodAnalyssiResult({
    String libraryName = 'foo',
  }) async {
    final library = await _requireFindLibraryByName(libraryName);
    final libraryAst =
        await library.session.getResolvedLibraryByElement(library);

    libraryAst as ResolvedLibraryResult;
    return parseRiverpod(libraryAst.units.first.unit);
  }

  Future<LibraryElement> _requireFindLibraryByName([
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
