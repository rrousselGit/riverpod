import 'package:analyzer/dart/ast/ast.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_analyzer_utils/riverpod_analyzer_utils.dart';
import 'package:test/test.dart';

import '../../analyzer_test_utils.dart';

void main() {
  testSource('Parses element.isFamily', source: r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
T generic<T>(GenericRef ref) => throw UnimplementedError();

@riverpod
class GenericClass<T> extends _$GenericClass<T> {
  @override
  T build() => throw UnimplementedError();
}

@riverpod
int value(ValueRef ref) => throw UnimplementedError();

@riverpod
class ValueClass extends _$ValueClass {
  @override
  int build() => throw UnimplementedError();
}

@riverpod
int parametrized(ParametrizedRef ref, int id) => throw UnimplementedError();

@riverpod
class ParametrizedClass extends _$ParametrizedClass {
  @override
  int build(int id) => throw UnimplementedError();
}
''', (resolver, unit, units) async {
    final generic = unit.declarations.findByName('generic').provider!;
    final genericClass = unit.declarations.findByName('GenericClass').provider!;
    final value = unit.declarations.findByName('value').provider!;
    final valueClass = unit.declarations.findByName('ValueClass').provider!;
    final parametrized = unit.declarations.findByName('parametrized').provider!;
    final parametrizedClass =
        unit.declarations.findByName('ParametrizedClass').provider!;

    expect(generic.providerElement.isFamily, true);
    expect(genericClass.providerElement.isFamily, true);

    expect(value.providerElement.isFamily, false);
    expect(valueClass.providerElement.isFamily, false);

    expect(parametrized.providerElement.isFamily, true);
    expect(parametrizedClass.providerElement.isFamily, true);
  });

  testSource('Parses Raw types', source: '''
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
Raw<Future<int>> value(ValueRef ref) async => 0;

@riverpod
Future<int> value2(Value2Ref ref) async => 0;

@riverpod
Future<Raw<int>> value3(Value3Ref ref) async => 0;
''', (resolver, unit, units) async {
    final value =
        unit.declarations.findByName<FunctionDeclaration>('value').provider!;
    final value2 =
        unit.declarations.findByName<FunctionDeclaration>('value2').provider!;
    final value3 =
        unit.declarations.findByName<FunctionDeclaration>('value3').provider!;
    expect(value.createdTypeNode.toString(), 'Raw<Future<int>>');
    expect(value.createdTypeDisplayString, 'Raw<Future<int>>');
    expect(value.exposedTypeNode.source, 'Raw<Future<int>>');
    expect(value.exposedTypeNode.dartType.toString(), 'Future<int>');
    expect(value.exposedTypeDisplayString, 'Raw<Future<int>>');
    expect(value.valueTypeNode.toString(), 'Raw<Future<int>>');
    expect(value.valueTypeDisplayString, 'Raw<Future<int>>');
    expect(value.createdTypeNode!.type!.isRaw, true);
    expect(value.valueTypeNode!.type!.isRaw, true);

    expect(value2.createdTypeNode.toString(), 'Future<int>');
    expect(value2.exposedTypeNode.source, 'AsyncValue<int>');
    expect(value2.exposedTypeNode.dartType.toString(), 'AsyncValue<int>');
    expect(value2.valueTypeNode.toString(), 'int');
    expect(value2.createdTypeNode!.type!.isRaw, false);
    expect(value2.createdTypeDisplayString, 'FutureOr<int>');
    expect(value2.exposedTypeDisplayString, 'AsyncValue<int>');
    expect(value2.valueTypeDisplayString, 'int');
    expect(value2.createdTypeNode!.type!.isRaw, false);
    expect(value2.valueTypeNode!.type!.isRaw, false);

    expect(value3.createdTypeNode.toString(), 'Future<Raw<int>>');
    expect(value3.exposedTypeNode.source, 'AsyncValue<Raw<int>>');
    expect(value3.exposedTypeNode.dartType.toString(), 'AsyncValue<int>');
    expect(value3.valueTypeNode.toString(), 'Raw<int>');
    expect(value3.createdTypeDisplayString, 'FutureOr<Raw<int>>');
    expect(value3.exposedTypeDisplayString, 'AsyncValue<Raw<int>>');
    expect(value3.valueTypeDisplayString, 'Raw<int>');
    expect(value3.createdTypeNode!.type!.isRaw, false);
    expect(value3.valueTypeNode!.type!.isRaw, true);
  });

  testSource('Decode isScoped', source: '''
import 'package:riverpod_annotation/riverpod_annotation.dart';

@Riverpod(dependencies: [])
int scoped() => 0;

@riverpod
int plain(PlainRef ref) => 0;
''', (resolver, unit, units) async {
    final scoped =
        unit.declarations.findByName<FunctionDeclaration>('scoped').provider!;
    final plain =
        unit.declarations.findByName<FunctionDeclaration>('plain').provider!;

    expect(scoped.providerElement.isScoped, true);
    expect(plain.providerElement.isScoped, false);
  });

  testSource('Decode name', runGenerator: true, source: r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'foo.g.dart';

@riverpod
int first(FirstRef ref) => 0;

@Riverpod()
int second(SecondRef ref) => 0;

@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
}
''', (resolver, unit, units) async {
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
  });

  testSource('Decode isAutoDispose', runGenerator: true, source: r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'foo.g.dart';

@riverpod
int autoDispose(AutoDisposeRef ref) => 0;

@Riverpod(keepAlive: false)
int autoDispose2(AutoDisposeRef ref) => 0;

@Riverpod(keepAlive: true)
int keepAlive(KeepAliveRef ref) => 0;

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
''', (resolver, unit, units) async {
    final providers =
        unit.declarations.map((e) => e.provider).whereNotNull().toList();

    final autoDispose = providers.takeAll([
      'autoDispose',
      'AutoDisposeNotifierTest',
    ]);
    final explicitAutoDispose = providers.takeAll([
      'autoDispose2',
      'AutoDisposeNotifier2',
    ]);
    final keepAlive = providers.takeAll([
      'keepAlive',
      'KeepAliveNotifier',
    ]);

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
  });

  testSource('Decode dependencies', runGenerator: true, source: r'''
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'foo.g.dart';

@riverpod
int root(RootRef ref) => 0;

@riverpod
class RootNotifier extends _$RootNotifier {
  @override
  int build() => 0;
}

@Riverpod(dependencies: [])
int empty(EmptyRef ref) => 0;

@Riverpod(dependencies: [])
class EmptyNotifier extends _$EmptyNotifier {
  @override
  int build() => 0;
}

@Riverpod(dependencies: [empty, EmptyNotifier])
int providerDependency(ProviderDependencyRef ref) => 0;

@Riverpod(dependencies: [empty, EmptyNotifier])
class ProviderDependencyNotifier extends _$ProviderDependencyNotifier {
  @override
  int build() => 0;
}

@Riverpod(dependencies: [providerDependency, ProviderDependencyNotifier])
int nestedDependency(NestedDependencyRef ref) => 0;

@Riverpod(dependencies: [providerDependency, ProviderDependencyNotifier])
class NestedDependencyNotifier extends _$NestedDependencyNotifier {
  @override
  int build() => 0;
}

@Riverpod(dependencies: [empty, EmptyNotifier])
int family(NestedDependencyRef ref) => 0;

@Riverpod(dependencies: [empty, EmptyNotifier])
class FamilyClass extends _$FamilyClass {
  @override
  int build() => 0;
}
''', (resolver, unit, units) async {
    final providers =
        unit.declarations.map((e) => e.provider).whereNotNull().toList();

    final roots = providers.takeAll([
      'root',
      'RootNotifier',
    ]);
    final empty = providers.takeAll([
      'empty',
      'EmptyNotifier',
    ]);
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
        reason: '${provider.key} has `providerDependency` as first dependency',
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
        reason: '${provider.key} has `providerDependency` as first dependency',
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
  });
}
