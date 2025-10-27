import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_buffer/analyzer_buffer.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:test/test.dart';

import '../../analyzer_test_utils.dart';

void main() {
  testSource(
    'Parses element.isFamily',
    source: r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
T generic<T>(Ref ref) => throw UnimplementedError();

@riverpod
class GenericClass<T> extends _$GenericClass<T> {
  @override
  T build() => throw UnimplementedError();
}

@riverpod
int value(Ref ref) => throw UnimplementedError();

@riverpod
class ValueClass extends _$ValueClass {
  @override
  int build() => throw UnimplementedError();
}

@riverpod
int parametrized(Ref ref, int id) => throw UnimplementedError();

@riverpod
class ParametrizedClass extends _$ParametrizedClass {
  @override
  int build(int id) => throw UnimplementedError();
}
''',
    (resolver, unit, units) async {
      final generic = unit.declarations.findByName('generic').provider!;
      final genericClass =
          unit.declarations.findByName('GenericClass').provider!;
      final value = unit.declarations.findByName('value').provider!;
      final valueClass = unit.declarations.findByName('ValueClass').provider!;
      final parametrized =
          unit.declarations.findByName('parametrized').provider!;
      final parametrizedClass =
          unit.declarations.findByName('ParametrizedClass').provider!;

      expect(generic.providerElement.isFamily, true);
      expect(genericClass.providerElement.isFamily, true);

      expect(value.providerElement.isFamily, false);
      expect(valueClass.providerElement.isFamily, false);

      expect(parametrized.providerElement.isFamily, true);
      expect(parametrizedClass.providerElement.isFamily, true);
    },
  );

  testSource(
    'Parses Raw types',
    source: '''
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
Raw<Future<int>> value(Ref ref) async => 0;

@riverpod
Future<int> value2(Ref ref) async => 0;

@riverpod
Future<Raw<int>> value3(Ref ref) async => 0;
''',
    (resolver, unit, units) async {
      final value =
          unit.declarations.findByName<FunctionDeclaration>('value').provider!;
      final value2 =
          unit.declarations.findByName<FunctionDeclaration>('value2').provider!;
      final value3 =
          unit.declarations.findByName<FunctionDeclaration>('value3').provider!;
      expect(
        value.providerElement.createdTypeNode,
        '#{{package:riverpod_annotation/src/riverpod_annotation.dart|Raw}}<#{{dart:async|Future}}<#{{dart:core|int}}>>',
      );
      expect(
        value.providerElement.exposedTypeNode,
        '#{{package:riverpod_annotation/src/riverpod_annotation.dart|Raw}}<#{{dart:async|Future}}<#{{dart:core|int}}>>',
      );
      expect(
        value.providerElement.valueTypeNode.toCode(),
        '#{{package:riverpod_annotation/src/riverpod_annotation.dart|Raw}}<#{{dart:async|Future}}<#{{dart:core|int}}>>',
      );
      expect(value.providerElement.valueTypeNode.isRaw, true);

      expect(
        value2.providerElement.createdTypeNode,
        '#{{dart:async|FutureOr}}<#{{dart:core|int}}>',
      );
      expect(
        value2.providerElement.exposedTypeNode,
        '#{{riverpod|AsyncValue}}<#{{dart:core|int}}>',
      );
      expect(
        value2.providerElement.valueTypeNode.toCode(),
        '#{{dart:core|int}}',
      );
      expect(value2.providerElement.valueTypeNode.isRaw, false);
      expect(
        value3.providerElement.createdTypeNode,
        '#{{dart:async|FutureOr}}<#{{package:riverpod_annotation/src/riverpod_annotation.dart|Raw}}<#{{dart:core|int}}>>',
      );
      expect(
        value3.providerElement.exposedTypeNode,
        '#{{riverpod|AsyncValue}}<#{{package:riverpod_annotation/src/riverpod_annotation.dart|Raw}}<#{{dart:core|int}}>>',
      );
      expect(
        value3.providerElement.valueTypeNode.toCode(),
        '#{{package:riverpod_annotation/src/riverpod_annotation.dart|Raw}}<#{{dart:core|int}}>',
      );
      expect(value3.providerElement.valueTypeNode.isRaw, true);
    },
  );

  testSource(
    'Decode isScoped',
    source: '''
import 'package:riverpod_annotation/riverpod_annotation.dart';

@Riverpod(dependencies: [])
int scoped() => 0;

@riverpod
int plain(Ref ref) => 0;
''',
    (resolver, unit, units) async {
      final scoped =
          unit.declarations.findByName<FunctionDeclaration>('scoped').provider!;
      final plain =
          unit.declarations.findByName<FunctionDeclaration>('plain').provider!;

      expect(scoped.providerElement.isScoped, true);
      expect(plain.providerElement.isScoped, false);
    },
  );

  testSource(
    'Decode name',
    runGenerator: true,
    source: r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'foo.g.dart';

@riverpod
int first(Ref ref) => 0;

@Riverpod()
int second(Ref ref) => 0;

@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
}
''',
    (resolver, unit, units) async {
      final providers = unit.declarations.map((e) => e.provider).toList();

      expect(providers, [
        isA<FunctionalProviderDeclaration>()
            .having((e) => e.name.toString(), 'name', 'first')
            .having((e) => e.node.name.toString(), 'node.name', 'first'),
        isA<FunctionalProviderDeclaration>()
            .having((e) => e.name.toString(), 'name', 'second')
            .having((e) => e.node.name.toString(), 'node.name', 'second'),
        isA<ClassBasedProviderDeclaration>()
            .having((e) => e.name.toString(), 'name', 'Counter')
            .having((e) => e.node.name.toString(), 'node.name', 'Counter'),
      ]);
    },
  );

  testSource(
    'Decode isAutoDispose',
    runGenerator: true,
    source: r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'foo.g.dart';

@riverpod
int autoDispose(Ref ref) => 0;

@Riverpod(keepAlive: false)
int autoDispose2(Ref ref) => 0;

@Riverpod(keepAlive: true)
int keepAlive(Ref ref) => 0;

@riverpod
class AutoDisposeNotifierTest extends _$AutoDisposeNotifierTest {
  @override
  int build() => 0;
}

@Riverpod(keepAlive: false)
class AutoDisposeNotifier2 extends _$AutoDisposeNotifier2 {
  @override
  int build() => 0;
}

@Riverpod(keepAlive: true)
class KeepAliveNotifier extends _$KeepAliveNotifier {
  @override
  int build() => 0;
}
''',
    (resolver, unit, units) async {
      final providers =
          unit.declarations.map((e) => e.provider).nonNulls.toList();

      final autoDispose = providers.takeAll([
        'autoDispose',
        'AutoDisposeNotifierTest',
      ]);
      final explicitAutoDispose = providers.takeAll([
        'autoDispose2',
        'AutoDisposeNotifier2',
      ]);
      final keepAlive = providers.takeAll(['keepAlive', 'KeepAliveNotifier']);

      for (final provider in autoDispose.entries) {
        expect(
          provider.value.annotation.element.keepAlive,
          false,
          reason: '${provider.key} is autoDispose',
        );
        expect(
          provider.value.annotation.keepAliveNode,
          isNull,
          reason: '${provider.key} does not has annotation.keepAliveNode',
        );
      }
      for (final provider in explicitAutoDispose.entries) {
        expect(
          provider.value.annotation.element.keepAlive,
          false,
          reason: '${provider.key} is autoDispose',
        );
        expect(
          provider.value.annotation.keepAliveNode?.toSource(),
          'keepAlive: false',
          reason: '${provider.key} specifies annotation.keepAliveNode',
        );
      }
      for (final provider in keepAlive.entries) {
        expect(
          provider.value.annotation.element.keepAlive,
          true,
          reason: '${provider.key} is not autoDispose',
        );
        expect(
          provider.value.annotation.keepAliveNode?.toSource(),
          'keepAlive: true',
          reason: '${provider.key} specifies annotation.keepAliveNode',
        );
      }
    },
  );

  testSource(
    'Decode dependencies',
    runGenerator: true,
    source: r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'foo.g.dart';

@riverpod
int root(Ref ref) => 0;

@riverpod
class RootNotifier extends _$RootNotifier {
  @override
  int build() => 0;
}

@Riverpod(dependencies: [])
int empty(Ref ref) => 0;

@Riverpod(dependencies: [])
class EmptyNotifier extends _$EmptyNotifier {
  @override
  int build() => 0;
}

@Riverpod(dependencies: [empty, EmptyNotifier])
int providerDependency(Ref ref) => 0;

@Riverpod(dependencies: [empty, EmptyNotifier])
class ProviderDependencyNotifier extends _$ProviderDependencyNotifier {
  @override
  int build() => 0;
}

@Riverpod(dependencies: [providerDependency, ProviderDependencyNotifier])
int nestedDependency(Ref ref) => 0;

@Riverpod(dependencies: [providerDependency, ProviderDependencyNotifier])
class NestedDependencyNotifier extends _$NestedDependencyNotifier {
  @override
  int build() => 0;
}

@Riverpod(dependencies: [empty, EmptyNotifier])
int family(Ref ref) => 0;

@Riverpod(dependencies: [empty, EmptyNotifier])
class FamilyClass extends _$FamilyClass {
  @override
  int build() => 0;
}
''',
    (resolver, unit, units) async {
      final providers =
          unit.declarations.map((e) => e.provider).nonNulls.toList();

      final roots = providers.takeAll(['root', 'RootNotifier']);
      final empty = providers.takeAll(['empty', 'EmptyNotifier']);
      final direct = providers.takeAll([
        'providerDependency',
        'ProviderDependencyNotifier',
        'family',
        'FamilyClass',
      ]);
      final nesteds = providers.takeAll([
        'nestedDependency',
        'NestedDependencyNotifier',
      ]);

      for (final provider in roots.entries) {
        expect(
          provider.value.annotation.dependencyList,
          null,
          reason: '${provider.key} has no dependency',
        );
        expect(
          provider.value.annotation.element.dependencies,
          null,
          reason: '${provider.key} has no dependency',
        );
        expect(
          provider.value.annotation.element.allTransitiveDependencies,
          null,
          reason: '${provider.key} has no dependency',
        );
      }
      for (final provider in empty.entries) {
        expect(
          provider.value.annotation.dependencyList?.values,
          isEmpty,
          reason: '${provider.key} has an empty list of dependencies',
        );
        expect(
          provider.value.annotation.element.dependencies,
          isEmpty,
          reason: '${provider.key} has an empty list of dependencies',
        );
        expect(
          provider.value.annotation.element.allTransitiveDependencies,
          isEmpty,
          reason: '${provider.key} has an empty list of dependencies',
        );
        expect(
          provider.value.annotation.dependenciesNode?.toSource(),
          'dependencies: []',
          reason: '${provider.key} has an empty list of dependencies',
        );
        expect(
          provider.value.annotation.dependencyList?.node?.toSource(),
          '[]',
          reason: '${provider.key} has an empty list of dependencies',
        );
      }

      for (final provider in direct.entries) {
        expect(
          provider.value.annotation.dependencyList?.values,
          hasLength(2),
          reason: '${provider.key} has two explicit dependencies',
        );
        expect(
          provider.value.annotation.element.dependencies,
          hasLength(2),
          reason: '${provider.key} has two explicit dependencies',
        );
        expect(
          provider.value.annotation.element.allTransitiveDependencies,
          provider.value.annotation.element.dependencies,
          reason: '${provider.key} has two explicit dependencies',
        );
        expect(
          provider.value.annotation.dependencyList?.values?[0],
          isA<ProviderDependency>()
              .having(
                (e) => e.provider,
                'provider',
                same(empty['empty']!.providerElement),
              )
              .having((e) => e.node.toString(), 'node', 'empty'),
          reason: '${provider.key} has `empty` as first dependency',
        );
        expect(
          provider.value.annotation.dependencyList?.values?[1],
          isA<ProviderDependency>()
              .having(
                (e) => e.provider,
                'provider',
                same(empty['EmptyNotifier']!.providerElement),
              )
              .having((e) => e.node.toString(), 'node', 'EmptyNotifier'),
          reason: '${provider.key} has `EmptyNotifier` as second dependency',
        );

        expect(
          provider.value.annotation.element.dependencies,
          hasLength(2),
          reason: '${provider.key} has two explicit dependencies',
        );
        expect(
          provider.value.annotation.element.dependencies?.elementAt(0),
          same(empty['empty']!.providerElement),
          reason: '${provider.key} has `empty` as first dependency',
        );
        expect(
          provider.value.annotation.element.dependencies?.elementAt(1),
          same(empty['EmptyNotifier']!.providerElement),
          reason: '${provider.key} has `EmptyNotifier` as second dependency',
        );

        expect(
          provider.value.annotation.dependenciesNode?.toSource(),
          'dependencies: [empty, EmptyNotifier]',
          reason: '${provider.key} has two dependencies',
        );
        expect(
          provider.value.annotation.dependencyList?.node?.toSource(),
          '[empty, EmptyNotifier]',
          reason: '${provider.key} has two dependencies',
        );
      }

      for (final provider in nesteds.entries) {
        expect(
          provider.value.annotation.dependencyList?.values,
          hasLength(2),
          reason: '${provider.key} has two explicit dependencies',
        );
        expect(
          provider.value.annotation.element.dependencies,
          hasLength(2),
          reason: '${provider.key} has two explicit dependencies',
        );
        expect(
          provider.value.annotation.element.allTransitiveDependencies,
          unorderedEquals([
            direct['providerDependency']!.providerElement,
            direct['ProviderDependencyNotifier']!.providerElement,
            empty['empty']!.providerElement,
            empty['EmptyNotifier']!.providerElement,
          ]),
          reason: '${provider.key} has two explicit dependencies',
        );
        expect(
          provider.value.annotation.dependencyList?.values?[0],
          isA<ProviderDependency>()
              .having(
                (e) => e.provider,
                'provider',
                same(direct['providerDependency']!.providerElement),
              )
              .having((e) => e.node.toString(), 'node', 'providerDependency'),
          reason:
              '${provider.key} has `providerDependency` as first dependency',
        );
        expect(
          provider.value.annotation.dependencyList?.values?[1],
          isA<ProviderDependency>()
              .having(
                (e) => e.provider,
                'provider',
                same(direct['ProviderDependencyNotifier']!.providerElement),
              )
              .having(
                (e) => e.node.toString(),
                'node',
                'ProviderDependencyNotifier',
              ),
          reason:
              '${provider.key} has `ProviderDependencyNotifier` as second dependency',
        );

        expect(
          provider.value.annotation.element.dependencies,
          hasLength(2),
          reason: '${provider.key} has two explicit dependencies',
        );
        expect(
          provider.value.annotation.element.dependencies?.elementAt(0),
          same(direct['providerDependency']!.providerElement),
          reason:
              '${provider.key} has `providerDependency` as first dependency',
        );
        expect(
          provider.value.annotation.element.dependencies?.elementAt(1),
          same(direct['ProviderDependencyNotifier']!.providerElement),
          reason:
              '${provider.key} has `ProviderDependencyNotifier` as second dependency',
        );

        expect(
          provider.value.annotation.dependenciesNode?.toSource(),
          'dependencies: [providerDependency, ProviderDependencyNotifier]',
          reason: '${provider.key} has two dependencies',
        );
        expect(
          provider.value.annotation.dependencyList?.node?.toSource(),
          '[providerDependency, ProviderDependencyNotifier]',
          reason: '${provider.key} has two dependencies',
        );
      }
    },
  );
}
