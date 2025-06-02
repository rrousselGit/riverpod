import 'package:mockito/mockito.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

import '../../src/matrix.dart';
import '../../src/utils.dart' show throwsProviderException;
import '../utils.dart';

void main() {
  group('ProviderContainer', () {
    group('debugReassemble', () {
      test(
          'reload providers if the debugGetCreateSourceHash of a provider returns a different value',
          skip: 'Needs overloading the method', () {
        final noDebugGetCreateSourceHashBuild = OnBuildMock();
        final noDebugGetCreateSourceHash = Provider((ref) {
          noDebugGetCreateSourceHashBuild();
          return 0;
        });
        final constantHashBuild = OnBuildMock();
        final constantHash = Provider.internal(
          isAutoDispose: false,
          from: null,
          argument: null,
          name: null,
          dependencies: null,
          $allTransitiveDependencies: null,
          retry: null,
          (ref) {
            constantHashBuild();
            return 0;
          },
        );
        var hashResult = '42';
        final changingHashBuild = OnBuildMock();
        final changingHash = Provider.internal(
          isAutoDispose: false,
          from: null,
          argument: null,
          name: null,
          dependencies: null,
          retry: null,
          $allTransitiveDependencies: null,
          (ref) {
            changingHashBuild();
            return 0;
          },
        );
        final container = ProviderContainer();

        container.read(noDebugGetCreateSourceHash);
        container.read(constantHash);
        container.read(changingHash);

        clearInteractions(noDebugGetCreateSourceHashBuild);
        clearInteractions(constantHashBuild);
        clearInteractions(changingHashBuild);

        hashResult = 'new hash';
        container.debugReassemble();
        container.read(noDebugGetCreateSourceHash);
        container.read(constantHash);
        container.read(changingHash);

        verifyOnly(changingHashBuild, changingHashBuild());
        verifyNoMoreInteractions(constantHashBuild);
        verifyNoMoreInteractions(noDebugGetCreateSourceHashBuild);

        container.debugReassemble();
        container.read(noDebugGetCreateSourceHash);
        container.read(constantHash);
        container.read(changingHash);

        verifyNoMoreInteractions(changingHashBuild);
        verifyNoMoreInteractions(constantHashBuild);
        verifyNoMoreInteractions(noDebugGetCreateSourceHashBuild);
      });
    });

    test('invalidate triggers a rebuild on next frame', () async {
      final container = ProviderContainer.test();
      final listener = Listener<int>();
      var result = 0;
      final provider = Provider((r) => result);

      container.listen(provider, listener.call);
      verifyZeroInteractions(listener);

      container.invalidate(provider);
      container.invalidate(provider);
      result = 1;

      verifyZeroInteractions(listener);

      await container.pump();

      verifyOnly(listener, listener(0, 1));
    });

    group('validate that properties respect `dependencies`', () {
      test('on reading an element, asserts that dependencies are respected',
          () {
        final dep = Provider(
          (ref) => 0,
          dependencies: const [],
        );
        final provider = Provider((ref) => ref.watch(dep));

        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [dep.overrideWithValue(42)],
        );

        expect(
          () => container.read(provider),
          throwsProviderException(isStateError),
        );
      });

      test(
          'on reading an element, asserts that transitive dependencies are also respected',
          () {
        final transitiveDep = Provider(
          (ref) => 0,
          dependencies: const [],
        );
        final dep = Provider((ref) => ref.watch(transitiveDep));
        final provider = Provider((ref) => ref.watch(dep));

        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [transitiveDep.overrideWithValue(42)],
        );

        expect(
          () => container.read(provider),
          throwsA(anything),
        );
      });
    });

    test(
        'flushes listened-to providers even if they have no external listeners',
        () async {
      final dep = StateProvider((ref) => 0);
      final provider = Provider((ref) => ref.watch(dep));
      final another = NotifierProvider<Notifier<int>, int>(
        () => DeferredNotifier((ref, self) {
          ref.listen(provider, (prev, value) => self.state++);
          return 0;
        }),
      );
      final container = ProviderContainer.test();

      expect(container.read(another), 0);

      container.read(dep.notifier).state = 42;

      expect(container.read(another), 1);
    });

    test(
        'flushes listened-to providers even if they have no external listeners (with ProviderListenable)',
        () async {
      final dep = StateProvider((ref) => 0);
      final provider = Provider((ref) => ref.watch(dep));
      final another = NotifierProvider<Notifier<int>, int>(
        () => DeferredNotifier((ref, self) {
          ref.listen(provider, (prev, value) => self.state++);
          return 0;
        }),
      );
      final container = ProviderContainer.test();

      expect(container.read(another), 0);

      container.read(dep.notifier).state = 42;

      expect(container.read(another), 1);
    });

    group('getAllProviderElements', () {
      test('list scoped providers that depends on nothing', () {
        final scopedProvider = Provider<int>(
          (ref) => 0,
          dependencies: const [],
        );
        final parent = ProviderContainer.test();
        final child = ProviderContainer.test(
          parent: parent,
          overrides: [scopedProvider],
        );

        child.read(scopedProvider);

        expect(
          child.getAllProviderElements().single,
          isA<$ProviderElement<Object?>>()
              .having((e) => e.origin, 'origin', scopedProvider),
        );
      });

      test(
          'list scoped providers that depends on providers from another container',
          () {
        final dependency = Provider((ref) => 0);
        final scopedProvider = Provider<int>(
          (ref) => ref.watch(dependency),
          dependencies: const [],
        );
        final parent = ProviderContainer.test();
        final child = ProviderContainer.test(
          parent: parent,
          overrides: [scopedProvider],
        );

        child.read(scopedProvider);

        expect(
          child.getAllProviderElements().single,
          isA<$ProviderElement<Object?>>()
              .having((e) => e.origin, 'origin', scopedProvider),
        );
      });

      test(
          'list only elements associated with the container (ignoring inherited and descendant elements)',
          () {
        final provider = Provider((ref) => 0);
        final provider2 = Provider(
          (ref) => 0,
          dependencies: const [],
        );
        final provider3 = Provider(
          (ref) => 0,
          dependencies: const [],
        );
        final root = ProviderContainer.test();
        final mid = ProviderContainer.test(
          parent: root,
          overrides: [provider2],
        );
        final leaf = ProviderContainer.test(
          parent: mid,
          overrides: [provider3],
        );

        leaf.read(provider);
        leaf.read(provider2);
        leaf.read(provider3);

        expect(
          root.getAllProviderElements().single,
          isA<$ProviderElement<Object?>>()
              .having((e) => e.provider, 'provider', provider),
        );
        expect(
          mid.getAllProviderElements().single,
          isA<$ProviderElement<Object?>>()
              .having((e) => e.provider, 'provider', provider2),
        );
        expect(
          leaf.getAllProviderElements().single,
          isA<$ProviderElement<Object?>>()
              .having((e) => e.provider, 'provider', provider3),
        );
      });

      test('list the currently mounted providers', () async {
        final container = ProviderContainer();
        final unrelated = Provider((_) => 42);
        final provider = Provider.autoDispose((ref) => 0);

        expect(container.read(unrelated), 42);
        var sub = container.listen(provider, (_, __) {});

        expect(
          container.getAllProviderElements().map((e) => e.origin),
          unorderedEquals([provider, unrelated]),
        );

        sub.close();
        await container.pump();

        expect(
          container.getAllProviderElements(),
          [isA<ProviderElement>()],
        );

        sub = container.listen(provider, (_, __) {});

        expect(
          container.getAllProviderElements().map((e) => e.origin),
          unorderedEquals([provider, unrelated]),
        );
      });
    });

    group('getAllProviderElementsInOrder', () {
      test('list scoped providers that depends on nothing', () {
        final scopedProvider = Provider<int>(
          (ref) => 0,
          dependencies: const [],
        );
        final parent = ProviderContainer.test();
        final child = ProviderContainer.test(
          parent: parent,
          overrides: [scopedProvider],
        );

        child.read(scopedProvider);

        expect(
          child.getAllProviderElementsInOrder().single,
          isA<$ProviderElement<Object?>>()
              .having((e) => e.origin, 'origin', scopedProvider),
        );
      });

      test(
          'list scoped providers that depends on providers from another container',
          () {
        final dependency = Provider((ref) => 0);
        final scopedProvider = Provider<int>(
          (ref) => ref.watch(dependency),
          dependencies: const [],
        );
        final parent = ProviderContainer.test();
        final child = ProviderContainer.test(
          parent: parent,
          overrides: [scopedProvider],
        );

        child.read(scopedProvider);

        expect(
          child.getAllProviderElementsInOrder().single,
          isA<$ProviderElement<Object?>>()
              .having((e) => e.origin, 'origin', scopedProvider),
        );
      });
    });

    test(
        'does not re-initialize a provider if read by a child container after the provider was initialized',
        () {
      final root = ProviderContainer.test();
      // the child must be created before the provider is initialized
      final child = ProviderContainer.test(parent: root);

      var buildCount = 0;
      final provider = Provider((ref) {
        buildCount++;
        return 0;
      });

      expect(root.read(provider), 0);

      expect(buildCount, 1);

      expect(child.read(provider), 0);

      expect(buildCount, 1);
    });

    test('builds providers at most once per container', () {
      var result = 42;
      final container = ProviderContainer.test();
      var callCount = 0;
      final provider = Provider((_) {
        callCount++;
        return result;
      });

      expect(callCount, 0);
      expect(container.read(provider), 42);
      expect(callCount, 1);
      expect(container.read(provider), 42);
      expect(callCount, 1);

      final container2 = ProviderContainer.test();

      result = 21;
      expect(container2.read(provider), 21);
      expect(callCount, 2);
      expect(container2.read(provider), 21);
      expect(callCount, 2);
      expect(container.read(provider), 42);
      expect(callCount, 2);
    });
    test(
      'does not refresh providers if their dependencies changes but they have no active listeners',
      () async {
        final container = ProviderContainer.test();

        var buildCount = 0;
        final dep = StateProvider((ref) => 0);
        final provider = Provider((ref) {
          buildCount++;
          return ref.watch(dep);
        });

        container.read(provider);

        expect(buildCount, 1);

        container.read(dep.notifier).state++;
        await container.pump();

        expect(buildCount, 1);
      },
    );
  });
}
