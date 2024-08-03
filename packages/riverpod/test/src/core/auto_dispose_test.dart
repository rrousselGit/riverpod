import 'package:mockito/mockito.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

import '../utils.dart';
import 'provider_container_test.dart';

void main() {
  group('AutoDispose', () {
    test('Supports clearing the state of elements with only weak listeners',
        () async {
      final container = ProviderContainer.test();
      final onDispose = OnDisposeMock();
      var buildCount = 0;
      final provider = Provider.autoDispose((ref) {
        buildCount++;
        ref.onDispose(onDispose.call);
        return 0;
      });

      final element = container.readProviderElement(provider);

      final sub = container.listen(
        provider,
        weak: true,
        (previous, value) {},
      );

      expect(sub.read(), 0);
      expect(buildCount, 1);
      verifyZeroInteractions(onDispose);

      await container.pump();

      verifyOnly(onDispose, onDispose());

      expect(buildCount, 1);
      expect(container.readProviderElement(provider), same(element));
      expect(element.stateResult, null);

      expect(sub.read(), 0);
      expect(element.stateResult, ResultData(0));
      expect(buildCount, 2);
    });

    test(
        'onDispose is triggered only once if within autoDispose unmount, a dependency changed',
        () async {
      // regression test for https://github.com/rrousselGit/riverpod/issues/1064
      final container = ProviderContainer.test();
      final onDispose = OnDisposeMock();
      final dep = StateProvider((ref) => 0);
      final provider = Provider.autoDispose((ref) {
        ref.watch(dep);
        ref.onDispose(onDispose.call);
      });

      when(onDispose()).thenAnswer((realInvocation) {
        container.read(dep.notifier).state++;
      });

      container.read(provider);
      verifyZeroInteractions(onDispose);

      // cause provider to be disposed
      await container.pump();

      verify(onDispose()).called(1);
      verifyNoMoreInteractions(onDispose);
    });

    test('supports disposing of overridden families', () async {
      // Regression test for https://github.com/rrousselGit/riverpod/issues/2480
      final provider = Provider.autoDispose.family<int, int>(
        (ref, _) => -1,
        dependencies: const [],
      );

      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [provider.overrideWith((ref, arg) => 0)],
      );

      container.read(provider(0));

      expect(container.pointerManager.readPointer(provider(0)), isNotNull);
      expect(container.pointerManager.familyPointers[provider], isNotNull);

      await container.pump();

      // The family pointer should still be there, as it comes from an override
      expect(container.pointerManager.familyPointers[provider], isNotNull);
      // The provider should've been disposed.
      expect(container.pointerManager.readPointer(provider(0)), isNull);
    });

    // TODO test recursive dispose does not remove pointers in unrelated containers

    test(
        'When a non-overridden autoDispose provider is disposed '
        'and the associated ProviderContainer has a child ProviderContainer which overrides said provider, '
        'the child container keeps its override', () async {
// Regression test for https://github.com/rrousselGit/riverpod/issues/1519

      final provider = Provider.autoDispose(
        (ref) => 0,
        dependencies: const [],
      );
      final root = ProviderContainer.test();
      final child = ProviderContainer.test(
        parent: root,
        overrides: [
          provider.overrideWith((ref) {
            ref.keepAlive();
            return 42;
          }),
        ],
      );

      root.read(provider);
      child.read(provider);

      await root.pump();

      expect(
        root.pointerManager.readPointer(provider),
        isNull,
      );

      expect(
        child.pointerManager.readPointer(provider),
        isPointer(override: isNotNull, element: isNotNull),
      );
    });

    group('on unused providers', () {
      test(
          'cleans up the pointers of a provider in the entire ProviderContainer tree',
          () async {
        final unrelated = Provider((_) => 42, dependencies: const []);
        // Regression test for https://github.com/rrousselGit/riverpod/issues/1943
        final a = ProviderContainer.test();
        // b/c voluntarily do not use the Provider, but a/d do. This is to test
        // that the disposal logic correctly cleans up the StateReaders
        // in all ProviderContainers associated with the provider, even if
        // some links between two ProviderContainers are not using the provider.
        final b = ProviderContainer.test(parent: a, overrides: [unrelated]);
        final c = ProviderContainer.test(parent: b, overrides: [unrelated]);
        final d = ProviderContainer.test(parent: c, overrides: [unrelated]);

        final provider = Provider.autoDispose((ref) => 3);

        final subscription = d.listen(
          provider,
          (previous, next) {},
          fireImmediately: true,
        );

        expect(a.pointerManager.readPointer(provider), isNotNull);
        expect(b.pointerManager.readPointer(provider), isNull);
        expect(c.pointerManager.readPointer(provider), isNull);
        expect(d.pointerManager.readPointer(provider), isNotNull);

        subscription.close();

        expect(a.pointerManager.readPointer(provider), isNotNull);
        expect(b.pointerManager.readPointer(provider), isNull);
        expect(c.pointerManager.readPointer(provider), isNull);
        expect(d.pointerManager.readPointer(provider), isNotNull);

        await a.pump();

        expect(a.pointerManager.readPointer(provider), isNull);
        expect(b.pointerManager.readPointer(provider), isNull);
        expect(c.pointerManager.readPointer(provider), isNull);
        expect(d.pointerManager.readPointer(provider), isNull);

        d.listen(
          provider,
          (previous, next) {},
          fireImmediately: true,
        );

        expect(a.pointerManager.readPointer(provider), isNotNull);
        expect(b.pointerManager.readPointer(provider), isNull);
        expect(c.pointerManager.readPointer(provider), isNull);
        expect(d.pointerManager.readPointer(provider), isNotNull);
      });

      test(
          'if a dependency changed, the element is still disposed, '
          'but without calling ref.onDispose again', () async {
        final container = ProviderContainer.test();
        final onDispose = OnDisposeMock();
        final dep = StateProvider((ref) => 0);
        final provider = Provider.autoDispose((ref) {
          ref.onDispose(onDispose.call);
          return ref.watch(dep);
        });

        container.read(provider);
        verifyZeroInteractions(onDispose);
        container.read(dep.notifier).state++;

        expect(
          container.pointerManager.readPointer(provider),
          isNotNull,
        );

        await container.pump();

        verify(onDispose()).called(1);

        expect(container.pointerManager.readPointer(provider), isNull);
      });
    });
  });
}
