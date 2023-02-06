import 'package:riverpod_analyzer_utils/src/riverpod_ast.dart';
import 'package:riverpod_analyzer_utils/src/riverpod_element.dart';
import 'package:test/test.dart';

import 'analyser_test_utils.dart';

void main() {
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
    final result = await resolver.resolveRiverpodAnalyssiResult();
    final providers = result.generatorProviderDeclarations
        .take(['first', 'second', 'Counter']);

    expect(providers, {
      'first': isA<StatelessProviderDeclaration>()
          .having((e) => e.name.toString(), 'name', 'first')
          .having((e) => e.node.name.toString(), 'node.name', 'first'),
      'second': isA<StatelessProviderDeclaration>()
          .having((e) => e.name.toString(), 'name', 'second')
          .having((e) => e.node.name.toString(), 'node.name', 'second'),
      'Counter': isA<StatefulProviderDeclaration>()
          .having((e) => e.name.toString(), 'name', 'Counter')
          .having((e) => e.node.name.toString(), 'node.name', 'Counter'),
    });
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
    final result = await resolver.resolveRiverpodAnalyssiResult();
    final autoDispose = result.generatorProviderDeclarations.take([
      'autoDispose',
      'AutoDisposeNotifierTest',
    ]);
    final explicitAutoDispose = result.generatorProviderDeclarations.take([
      'autoDispose2',
      'AutoDisposeNotifier2',
    ]);
    final keepAlive = result.generatorProviderDeclarations.take([
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
''', (resolver) async {
    final result = await resolver.resolveRiverpodAnalyssiResult();
    final roots = result.generatorProviderDeclarations.take([
      'root',
      'RootNotifier',
    ]);
    final empty = result.generatorProviderDeclarations.take([
      'empty',
      'EmptyNotifier',
    ]);
    final providers = result.generatorProviderDeclarations.take([
      'providerDependency',
      'ProviderDependencyNotifier',
    ]);
    final nesteds = result.generatorProviderDeclarations.take([
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
        provider.value.annotation.dependenciesNode,
        null,
        reason: '${provider.key} has no dependency',
      );
    }
    for (final provider in empty.entries) {
      expect(
        provider.value.annotation.dependencies,
        isEmpty,
        reason: '${provider.key} has an empty list of dependencies',
      );
      expect(
        provider.value.annotation.element.dependencies,
        isEmpty,
        reason: '${provider.key} has an empty list of dependencies',
      );
      expect(
        provider.value.annotation.dependenciesNode?.toSource(),
        'dependencies: []',
        reason: '${provider.key} has an empty list of dependencies',
      );
    }
    for (final provider in providers.entries) {
      expect(
        provider.value.annotation.dependencies,
        hasLength(2),
        reason: '${provider.key} has two explicit dependencies',
      );
      expect(
        provider.value.annotation.dependencies?[0],
        isA<RiverpodAnnotationDependency>()
            .having(
              (e) => e.provider.provider,
              'provider',
              same(empty['empty']!.providerElement),
            )
            .having((e) => e.node.toString(), 'node', 'empty'),
        reason: '${provider.key} has `empty` as first dependency',
      );
      expect(
        provider.value.annotation.dependencies?[1],
        isA<RiverpodAnnotationDependency>()
            .having(
              (e) => e.provider.provider,
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
        isA<RiverpodAnnotationDependencyElement>().having(
          (e) => e.provider,
          'provider',
          same(empty['empty']!.providerElement),
        ),
        reason: '${provider.key} has `empty` as first dependency',
      );
      expect(
        provider.value.annotation.element.dependencies?.elementAt(1),
        isA<RiverpodAnnotationDependencyElement>().having(
          (e) => e.provider,
          'provider',
          same(empty['EmptyNotifier']!.providerElement),
        ),
        reason: '${provider.key} has `EmptyNotifier` as second dependency',
      );

      expect(
        provider.value.annotation.dependenciesNode?.toSource(),
        'dependencies: [empty, EmptyNotifier]',
        reason: '${provider.key} has two dependencies',
      );
    }

    for (final provider in nesteds.entries) {
      expect(
        provider.value.annotation.dependencies,
        hasLength(2),
        reason: '${provider.key} has two explicit dependencies',
      );
      expect(
        provider.value.annotation.dependencies?[0],
        isA<RiverpodAnnotationDependency>()
            .having(
              (e) => e.provider.provider,
              'provider',
              same(providers['providerDependency']!.providerElement),
            )
            .having((e) => e.node.toString(), 'node', 'providerDependency'),
        reason: '${provider.key} has `providerDependency` as first dependency',
      );
      expect(
        provider.value.annotation.dependencies?[1],
        isA<RiverpodAnnotationDependency>()
            .having(
              (e) => e.provider.provider,
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
        isA<RiverpodAnnotationDependencyElement>().having(
          (e) => e.provider,
          'provider',
          same(providers['providerDependency']!.providerElement),
        ),
        reason: '${provider.key} has `providerDependency` as first dependency',
      );
      expect(
        provider.value.annotation.element.dependencies?.elementAt(1),
        isA<RiverpodAnnotationDependencyElement>().having(
          (e) => e.provider,
          'provider',
          same(providers['ProviderDependencyNotifier']!.providerElement),
        ),
        reason:
            '${provider.key} has `ProviderDependencyNotifier` as second dependency',
      );

      expect(
        provider.value.annotation.dependenciesNode?.toSource(),
        'dependencies: [providerDependency, ProviderDependencyNotifier]',
        reason: '${provider.key} has two dependencies',
      );
    }
  });
}
