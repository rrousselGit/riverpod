// Regression test for https://github.com/rrousselGit/riverpod/issues/4372
// Resolving the sources takes a while, even more so with coverage.
@Timeout.factor(4)
library;

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:riverpod_generator/builder.dart';
import 'package:source_gen/builder.dart';
import 'package:test/test.dart';

void main() {
  group('Types sharing their name across imports keep their own prefix', () {
    late final String generated;

    setUpAll(() async {
      const main = 'riverpod_generator|test/same_name_types/main.dart';
      final readerWriter = TestReaderWriter(
        rootPackage: 'riverpod_generator',
        flattenOutput: true,
      );
      await readerWriter.testing.loadIsolateSources();
      final result = await testBuilders(
        [riverpodBuilder(BuilderOptions.empty), combiningBuilder()],
        {
          // Two unrelated classes share a name. As with `Locale` in the issue
          // (dart:ui, also exported by Flutter), one of them is also visible
          // without a prefix.
          'riverpod_generator|test/same_name_types/a.dart': 'class Model {}',
          'riverpod_generator|test/same_name_types/a_export.dart':
              "export 'a.dart';",
          'riverpod_generator|test/same_name_types/b.dart': 'class Model {}',
          main: r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'a.dart' as a;
import 'a_export.dart';
import 'b.dart' as b;

part 'main.g.dart';

@riverpod
b.Model functional(Ref ref, b.Model model, {a.Model? other}) => model;

@riverpod
Future<List<b.Model>> generic(Ref ref, Map<a.Model, b.Model> models) async {
  return models.values.toList();
}

@riverpod
Model unprefixed(Ref ref, Model model) => model;

@riverpod
class ClassBased extends _$ClassBased {
  @override
  a.Model build(a.Model model, {required b.Model other}) => model;
}
''',
        },
        generateFor: {main},
        rootPackage: 'riverpod_generator',
        readerWriter: readerWriter,
        flattenOutput: true,
      );
      expect(result.succeeded, isTrue, reason: result.errors.join('\n'));

      generated = readerWriter.testing
          .readString(AssetId.parse(main).changeExtension('.g.dart'))
          // The formatter splits long lines.
          .replaceAll(RegExp(r'\s'), '');
    });

    test('in functional providers', () {
      expect(generated, contains('b.Modelcreate(Refref)'));
      expect(
        generated,
        contains('FunctionalProvidercall(b.Modelmodel,{a.Model?other})'),
      );
    });

    test('nested in generics', () {
      expect(generated, contains('FutureOr<List<b.Model>>create(Refref)'));
      expect(
        generated,
        contains('GenericProvidercall(Map<a.Model,b.Model>models)'),
      );
    });

    test('in class-based providers', () {
      expect(
        generated,
        contains('a.Modelbuild(a.Modelmodel,{requiredb.Modelother});'),
      );
      expect(
        generated,
        contains('ClassBasedProvidercall(a.Modelmodel,{requiredb.Modelother})'),
      );
    });

    test('and unprefixed types never get the prefix of the other class', () {
      // `a.Model` and `Model` are the same class: both are valid.
      expect(
        generated,
        matches(RegExp(r'UnprefixedProvidercall\((a\.)?Modelmodel\)')),
      );
    });
  });
}
