// ignore_for_file: invalid_use_of_internal_member

@Timeout.factor(2)
library;

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element2.dart';
import 'package:riverpod_analyzer_utils/src/nodes.dart';
import 'package:test/test.dart';

import 'analyzer_test_utils.dart';

void main() {
  testSource(
    'Rejects unrelated types',
    source: '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/misc.dart';

const random = 42;
ProviderBase? fromRiverpod = null;
Consumer? fromFlutterRiverpod = null;
''',
    (resolver, unit, units) async {
      final variables = unit.declarations
          .whereType<TopLevelVariableDeclaration>();

      for (final variable in variables) {
        expect(
          parseLegacyProviderType(
            variable.variables.variables.single.declaredFragment!.element.type,
          ),
          isNull,
          reason: variable.toString(),
        );
        expect(
          parseFirstProviderFor(
            variable.variables.variables.single.declaredFragment!.element
                as TopLevelVariableElement2,
            variable,
          ),
          isNull,
          reason: variable.toString(),
        );
      }

      expect(variables, hasLength(3));
    },
  );

  testSource(
    'Parses all generated providers',
    runGenerator: true,
    source: r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'foo.g.dart';

Never throws() => throw UnimplementedError();

@riverpod
int a(Ref ref) => throws();

@riverpod
class B extends _$B {
  @override
  int build() => throws();;
}

@riverpod
int c(Ref ref, int arg) => throws();

@riverpod
class D extends _$D {
  @override
  int build(int arg) => throws();
}


@riverpod
Future<int> a2(Ref ref) => throws();

@riverpod
class B2 extends _$B2 {
  @override
  Future<int> build() => throws();;
}

@riverpod
Future<int> c2(Ref ref, int arg) => throws();

@riverpod
class D2 extends _$D2 {
  @override
  Future<int> build(int arg) => throws();
}


@riverpod
Stream<int> a3(Ref ref) => throws();

@riverpod
class B3 extends _$B3 {
  @override
  Stream<int> build() => throws();;
}

@riverpod
Stream<int> c3(Ref ref, int arg) => throws();

@riverpod
class D3 extends _$D3 {
  @override
  Stream<int> build(int arg) => throws();
}
''',
    (resolver, unit, units) async {
      final generated = units
          .singleWhere((e) => e.path.endsWith('.g.dart'))
          .unit;

      final variables = generated.declarations
          .whereType<TopLevelVariableDeclaration>()
          .toList();

      expect(variables, hasLength(12));

      for (final variable in variables) {
        expect(
          parseFirstProviderFor(
            variable.variables.variables.single.declaredFragment!.element
                as TopLevelVariableElement2,
            variable,
          )?.$1,
          isNotNull,
          reason: variable.toString(),
        );
        expect(
          parseLegacyProviderType(
            variable.variables.variables.single.declaredFragment!.element.type,
          ),
          isNull,
          reason: variable.toString(),
        );
      }
    },
  );

  testSource(
    'Parses all legacy providers',
    source: '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/misc.dart';

Never throws() => throw UnimplementedError();

final provider = Provider((ref) => throws());
final providerFamily = Provider.family<int, int>((ref, id) => throws());

final stateProvider = StateProvider((ref) => throws());
final stateProviderFamily = StateProvider.family<int, int>((ref, id) => throws());

final futureProvider = FutureProvider((ref) async => throws());
final futureProviderFamily = FutureProvider.family<int, int>((ref, id) => throws());

final streamProvider = StreamProvider((ref) => throws());
final streamProviderFamily = StreamProvider.family<int, int>((ref, id) => throws());

final changeNotifierProvider = ChangeNotifierProvider((ref) => throws());
final changeNotifierProviderFamily = ChangeNotifierProvider.family<int, int>((ref, id) => throws());

final stateNotifierProvider = StateNotifierProvider((ref) => throws());
final stateNotifierProviderFamily = StateNotifierProvider.family<int, int>((ref, id) => throws());

final notifierProvider = NotifierProvider(() => throws());
final notifierProviderFamily = NotifierProvider.family<int, int>((ref, id) => throws());

final asyncNotifierProvider = AsyncNotifierProvider((ref) => throws());
final asyncNotifierProviderFamily = AsyncNotifierProvider.family<int, int>((ref, id) => throws());

final streamNotifierProvider = StreamNotifierProvider((ref) => throws());
final streamNotifierProviderFamily = StreamNotifierProvider.family<int, int>((ref, id) => throws());
''',
    (resolver, unit, units) async {
      final variables = unit.declarations
          .whereType<TopLevelVariableDeclaration>();

      expect(variables, hasLength(18));

      for (final variable in variables) {
        expect(
          parseLegacyProviderType(
            variable.variables.variables.single.declaredFragment!.element.type,
          ),
          isNotNull,
          reason: variable.toString(),
        );
        expect(
          parseFirstProviderFor(
            variable.variables.variables.single.declaredFragment!.element
                as TopLevelVariableElement2,
            variable,
          ),
          isNull,
          reason: variable.toString(),
        );
      }
    },
  );
}
