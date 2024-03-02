import 'package:riverpod_analyzer_utils/src/riverpod_ast.dart';
import 'package:test/test.dart';

import 'analyzer_test_utils.dart';

void main() {
  testSource('Parses Raw types', source: '''
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
Raw<Future<int>> value(ValueRef ref) async => 0;

@riverpod
Future<int> value2(Value2Ref ref) async => 0;

@riverpod
Future<Raw<int>> value3(Value3Ref ref) async => 0;
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalysisResult(
      ignoreErrors: true,
    );

    final value = result.functionalProviderDeclarations.singleWhere(
      (e) => e.name.toString() == 'value',
    );
    final value2 = result.functionalProviderDeclarations.singleWhere(
      (e) => e.name.toString() == 'value2',
    );
    final value3 = result.functionalProviderDeclarations.singleWhere(
      (e) => e.name.toString() == 'value3',
    );
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

  testSource('Decode needsOverride/isScoped', source: '''
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
external int needsOverride();

@Riverpod(dependencies: [])
int scoped() => 0;

@riverpod
int plain(PlainRef ref) => 0;
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalysisResult(
      ignoreErrors: true,
    );

    final needsOverride = result.functionalProviderDeclarations.singleWhere(
      (e) => e.name.toString() == 'needsOverride',
    );
    final scoped = result.functionalProviderDeclarations.singleWhere(
      (e) => e.name.toString() == 'scoped',
    );
    final plain = result.functionalProviderDeclarations.singleWhere(
      (e) => e.name.toString() == 'plain',
    );

    expect(needsOverride.needsOverride, true);
    expect(scoped.needsOverride, false);
    expect(plain.needsOverride, false);

    expect(needsOverride.providerElement.isScoped, true);
    expect(scoped.providerElement.isScoped, true);
    expect(plain.providerElement.isScoped, false);
  });

  testSource('Decode dependencies with syntax errors', source: '''
import 'package:riverpod_annotation/riverpod_annotation.dart';

const deps = <ProviderOrFamily>[];

@Riverpod(dependencies: deps)
int first(FirstRef ref) => 0;

@Riverpod(dependencies: )
int second(SecondRef ref) => 0;

@Riverpod(dependencies: [gibberish])
int forth(ForthRef ref) => 0;

@Riverpod(dependencies: [if (true) forth])
int fifth(FifthRef ref) => 0;

@Riverpod(dependencies: [int])
int sixth(SixthRef ref) => 0;
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalysisResult(
      ignoreErrors: true,
    );

    final errors =
        result.resolvedRiverpodLibraryResults.expand((e) => e.errors).toList();

    expect(errors, hasLength(6));

    expect(
      errors[0].message,
      '@Riverpod(dependencies: <...>) only support list literals (using []).',
    );
    expect(errors[0].targetNode?.toSource(), 'deps');

    expect(
      errors[1].message,
      '@Riverpod(dependencies: <...>) only support list literals (using []).',
    );
    expect(errors[1].targetNode?.toSource(), '');

    expect(
      errors[2].message,
      '@Riverpod(dependencies: [...]) only supports elements annotated with @riverpod as values.',
    );
    expect(errors[2].targetNode?.toSource(), 'gibberish');

    expect(
      errors[3].message,
      '@Riverpod(dependencies: [...]) does not support if/for/spread operators.',
    );
    expect(errors[3].targetNode?.toSource(), 'if (true) forth');

    expect(
      errors[4].message,
      'Unsupported dependency. Only functions and classes annotated by @riverpod are supported.',
    );
    expect(errors[4].targetElement.toString(), 'int sixth(InvalidType ref)');

    expect(
      errors[5].message,
      'Failed to parse dependency Type (int)',
    );
    expect(errors[5].targetElement?.toString(), 'int sixth(InvalidType ref)');
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
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalysisResult();
    final providers = result.generatorProviderDeclarations;

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
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalysisResult();
    final autoDispose = result.generatorProviderDeclarations.takeAll([
      'autoDispose',
      'AutoDisposeNotifierTest',
    ]);
    final explicitAutoDispose = result.generatorProviderDeclarations.takeAll([
      'autoDispose2',
      'AutoDisposeNotifier2',
    ]);
    final keepAlive = result.generatorProviderDeclarations.takeAll([
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
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalysisResult();
    final roots = result.generatorProviderDeclarations.takeAll([
      'root',
      'RootNotifier',
    ]);
    final empty = result.generatorProviderDeclarations.takeAll([
      'empty',
      'EmptyNotifier',
    ]);
    final providers = result.generatorProviderDeclarations.takeAll([
      'providerDependency',
      'ProviderDependencyNotifier',
      'family',
      'FamilyClass',
    ]);
    final nesteds = result.generatorProviderDeclarations.takeAll([
      'nestedDependency',
      'NestedDependencyNotifier',
    ]);

    for (final provider in roots.entries) {
      expect(
        provider.value.annotation.dependencies,
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
        provider.value.annotation.dependencies?.dependencies,
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
        provider.value.annotation.dependencies?.node.toSource(),
        'dependencies: []',
        reason: '${provider.key} has an empty list of dependencies',
      );
    }
    for (final provider in providers.entries) {
      expect(
        provider.value.annotation.dependencies?.dependencies,
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
        provider.value.annotation.dependencies?.dependencies?[0],
        isA<RiverpodAnnotationDependency>()
            .having(
              (e) => e.provider,
              'provider',
              same(empty['empty']!.providerElement),
            )
            .having((e) => e.node.toString(), 'node', 'empty'),
        reason: '${provider.key} has `empty` as first dependency',
      );
      expect(
        provider.value.annotation.dependencies?.dependencies?[1],
        isA<RiverpodAnnotationDependency>()
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
        provider.value.annotation.dependencies?.node.toSource(),
        'dependencies: [empty, EmptyNotifier]',
        reason: '${provider.key} has two dependencies',
      );
    }

    for (final provider in nesteds.entries) {
      expect(
        provider.value.annotation.dependencies?.dependencies,
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
          providers['providerDependency']!.providerElement,
          providers['ProviderDependencyNotifier']!.providerElement,
          empty['empty']!.providerElement,
          empty['EmptyNotifier']!.providerElement,
        ]),
        reason: '${provider.key} has two explicit dependencies',
      );
      expect(
        provider.value.annotation.dependencies?.dependencies?[0],
        isA<RiverpodAnnotationDependency>()
            .having(
              (e) => e.provider,
              'provider',
              same(providers['providerDependency']!.providerElement),
            )
            .having((e) => e.node.toString(), 'node', 'providerDependency'),
        reason: '${provider.key} has `providerDependency` as first dependency',
      );
      expect(
        provider.value.annotation.dependencies?.dependencies?[1],
        isA<RiverpodAnnotationDependency>()
            .having(
              (e) => e.provider,
              'provider',
              same(providers['ProviderDependencyNotifier']!.providerElement),
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
        same(providers['providerDependency']!.providerElement),
        reason: '${provider.key} has `providerDependency` as first dependency',
      );
      expect(
        provider.value.annotation.element.dependencies?.elementAt(1),
        same(providers['ProviderDependencyNotifier']!.providerElement),
        reason:
            '${provider.key} has `ProviderDependencyNotifier` as second dependency',
      );

      expect(
        provider.value.annotation.dependencies?.node.toSource(),
        'dependencies: [providerDependency, ProviderDependencyNotifier]',
        reason: '${provider.key} has two dependencies',
      );
    }
  });
}
