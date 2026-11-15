// Resolving the sources takes a while, even more so with coverage.
@Timeout.factor(4)
library;

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:test/test.dart';

void main() {
  test('parses dependencies imported with a prefix', () async {
    final errors = <RiverpodAnalysisError>[];
    final previousErrorReporter = errorReporter;
    errorReporter = errors.add;
    addTearDown(() => errorReporter = previousErrorReporter);

    final dependencies = await resolveSources(
      {
        'riverpod_analyzer_utils|test/src/nodes/prefixed.dart': r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
int functional(Ref ref) => 0;

@riverpod
class ClassBased extends _$ClassBased {
  @override
  int build() => 0;
}
''',
        'riverpod_analyzer_utils|test/src/nodes/main.dart': '''
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'prefixed.dart' as p;

@riverpod
int unprefixed(Ref ref) => 0;

@Riverpod(dependencies: [p.functional, p.ClassBased, unprefixed])
int provider(Ref ref) => 0;
''',
      },
      (resolver) async {
        final library = await resolver.libraryFor(
          AssetId.parse('riverpod_analyzer_utils|test/src/nodes/main.dart'),
        );
        final result =
            await library.session.getResolvedLibraryByElement(library)
                as ResolvedLibraryResult;

        return result.units.single.unit.declarations
            .whereType<FunctionDeclaration>()
            .last
            .provider!
            .annotation
            .dependencyList!
            .values!
            .map((e) => (e.provider.name, e.importPrefix))
            .toList();
      },
      readAllSourcesFromFilesystem: true,
    );

    expect(dependencies, [
      ('functional', 'p'),
      ('ClassBased', 'p'),
      ('unprefixed', null),
    ]);
    expect(errors, isEmpty);
  });
}
