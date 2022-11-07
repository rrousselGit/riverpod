import 'dart:async';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:test/test.dart';

/// Due to [resolveSource] throwing if trying to interact with the resolver
/// after the future completed, we change the syntax to make sure our test
/// executes within the resolver scope.
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
        return runZoned(
          () => run(resolver),
          zoneSpecification: ZoneSpecification(
            // Somehow prints are captured inside the callback. Let's restore them
            print: (self, parent, zone, line) => enclosingZone.print(line),
          ),
        );
      });
    },
  );
}

extension ResolverX on Resolver {
  Future<Map<String, ProviderDefinition>> parseAllProviderDefinitions(
    List<String> names, {
    String libraryName = 'foo',
  }) async {
    final library = await requireFindLibraryByName(libraryName);
    final definitions = await Future.wait([
      for (final name in names)
        ProviderDefinition.parse(
          library.findElementWithName(name),
          resolver: astNodeFor,
        ),
    ]);

    return {
      for (var i = 0; i < names.length; i++) names[i]: definitions[i],
    };
  }

  Future<LibraryElement> requireFindLibraryByName([
    String libraryName = 'foo',
  ]) async {
    final library = await findLibraryByName(libraryName);

    if (library == null) {
      throw StateError('No library found or name "$libraryName"');
    }

    final errorResult = await library.session
        .getErrors('/_resolve_source/lib/_resolve_source.dart');

    if (errorResult is ErrorsResult && errorResult.errors.isNotEmpty) {
      throw StateError('''
The parsed library has errors:
${errorResult.errors.map((e) => '- $e\n').join()}
''');
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
