import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  late ProviderContainer container;
  final didChange = Listener<int>();

  setUp(() {
    container = createContainer();
  });

  tearDown(() {
    reset(didChange);
    container.dispose();
  });

  test('ProviderContainer.children', () {
    final root = createContainer();

    expect(root.debugChildren, isEmpty);

    final mid = createContainer(parent: root);

    expect(root.debugChildren, containsAll(<ProviderContainer>[mid]));
    expect(mid.debugChildren, isEmpty);

    final mid2 = createContainer(parent: root);

    expect(root.debugChildren, containsAll(<ProviderContainer>[mid, mid2]));
    expect(mid.debugChildren, isEmpty);
    expect(mid2.debugChildren, isEmpty);

    final leaf = createContainer(parent: mid);

    expect(root.debugChildren, containsAll(<ProviderContainer>[mid, mid2]));
    expect(mid.debugChildren, containsAll(<ProviderContainer>[leaf]));
    expect(mid2.debugChildren, isEmpty);
    expect(leaf.debugChildren, isEmpty);

    leaf.dispose();

    expect(root.debugChildren, containsAll(<ProviderContainer>[mid, mid2]));
    expect(mid.debugChildren, isEmpty);
    expect(mid2.debugChildren, isEmpty);

    mid.dispose();

    expect(root.debugChildren, containsAll(<ProviderContainer>[mid2]));
    expect(mid2.debugChildren, isEmpty);

    mid2.dispose();

    expect(root.debugChildren, isEmpty);

    root.dispose();
  });

  test('Ref.container exposes the root container', () {
    final root = createContainer();
    final container = createContainer(parent: root);
    final provider = Provider((ref) => ref);

    expect(container.read(provider).container, root);
  });

  group('Provider.name', () {
    test('is directed by the family, if any', () {
      final family = Provider.family<int, int>((ref, _) => 0);

      expect(family(0).name, null);

      final family2 = Provider.family<int, int>((ref, _) => 0, name: 'name');

      expect(family2(0).name, 'name');
      expect(
        family2(0).toString(),
        equalsIgnoringHashCodes('name:Provider<int>#00000(0)'),
      );

      expect(family2(1).name, 'name');
      expect(
        family2(1).toString(),
        equalsIgnoringHashCodes('name:Provider<int>#00000(1)'),
      );
    });
  });

  group('combining providers', () {
    late StreamController<int> controller;
    final streamProvider = StreamProvider((ref) => controller.stream);

    setUp(() {
      controller = StreamController<int>(sync: true);
    });
    tearDown(() {
      controller.close();
    });

    test("ref.read doesn't cause recomputing", () {
      var callCount = 0;
      final provider = Provider((ref) {
        callCount++;
        return ref
            .read(streamProvider)
            .maybeWhen(data: (d) => d, orElse: () => null);
      });

      expect(callCount, 0);
      expect(container.read(provider), null);
      expect(callCount, 1);

      controller.add(42);

      expect(callCount, 1);
      expect(container.read(provider), null);
      expect(callCount, 1);
    });

    test('watch cause recomputing when dependency changes', () {
      var callCount = 0;
      final provider = Provider((ref) {
        callCount++;
        return ref
            .watch(streamProvider)
            .maybeWhen(data: (d) => d, orElse: () => null);
      });

      expect(callCount, 0);
      expect(container.read(provider), null);
      expect(callCount, 1);

      controller.add(42);

      expect(callCount, 1);
      expect(container.read(provider), 42);
      expect(callCount, 2);
    });

    test("watch is no-op if dependency didn't change", () {
      var callCount = 0;
      final provider = Provider((ref) {
        callCount++;
        return ref
            .watch(streamProvider)
            .maybeWhen(data: (d) => d, orElse: () => null);
      });

      expect(callCount, 0);
      expect(container.read(provider), null);
      expect(callCount, 1);

      expect(callCount, 1);
      expect(container.read(provider), null);
      expect(callCount, 1);
    });

    test(
        'recomputing a provider calls onDispose and clear the dispose listeners',
        () {
      final onDispose = OnDisposeMock();
      var buildCount = 0;
      final provider = Provider((ref) {
        buildCount++;
        ref.onDispose(onDispose.call);
      });
      final container = createContainer();

      container.read(provider);

      expect(buildCount, 1);
      verifyZeroInteractions(onDispose);

      container.refresh(provider);

      expect(buildCount, 2);
      verifyOnly(onDispose, onDispose());

      container.refresh(provider);

      expect(buildCount, 3);
      verifyOnly(onDispose, onDispose());
    });
  });

  test('disposing child container does not dispose the providers', () {
    final container = createContainer();
    final child = createContainer(parent: container);
    var disposed = false;
    final provider = Provider((ref) {
      ref.onDispose(() => disposed = true);
      return 0;
    });

    expect(child.read(provider), 0);

    child.dispose();

    expect(disposed, false);

    container.dispose();

    expect(disposed, true);
  });

  test('child container uses root overrides', () {
    final provider = Provider((ref) => 0);
    final container = createContainer(
      overrides: [provider.overrideWithValue(42)],
    );
    final child = createContainer(parent: container);

    expect(child.read(provider), 42);
  });

  test('Providers still rethrow error if dependency rebuilt but did not change',
      () {
    var callCount = 0;
    final atom = StateProvider((ref) => 0);
    final dependency = Provider((ref) => ref.watch(atom));
    final provider = Provider((ref) {
      callCount++;
      ref.watch(dependency);
      if (callCount == 1) {
        throw StateError('err');
      }
    });

    expect(() => container.read(provider), throwsStateError);
    expect(callCount, 1);

    container.read(atom.notifier).state = 0;

    expect(() => container.read(provider), throwsStateError);
    expect(callCount, 1);
  });

  test('re-evaluating a provider can stop listening to a dependency', () {
    final first = StateProvider((ref) => 0);
    final second = StateProvider((ref) => 0);
    final computed = Provider<String>((ref) {
      if (ref.watch(first) == 0) {
        return ref.watch(second).toString();
      }
      return 'fallback';
    });
    final firstElement = container.readProviderElement(first);
    final secondElement = container.readProviderElement(second);
    final computedElement = container.readProviderElement(computed);
    final sub = container.listen(computed, (_, __) {});

    expect(sub.read(), '0');
    var firstDependents = <ProviderElementBase<Object?>>[];
    firstElement.visitChildren(
      elementVisitor: firstDependents.add,
      notifierVisitor: (_) {},
    );
    var secondDependents = <ProviderElementBase<Object?>>[];
    secondElement.visitChildren(
      elementVisitor: secondDependents.add,
      notifierVisitor: (_) {},
    );

    expect(firstDependents, [computedElement]);
    expect(firstElement.hasListeners, true);
    expect(secondDependents, [computedElement]);
    expect(secondElement.hasListeners, true);

    container.read(first.notifier).state++;
    expect(sub.read(), 'fallback');

    firstDependents = <ProviderElementBase<Object?>>[];
    firstElement.visitChildren(
      elementVisitor: firstDependents.add,
      notifierVisitor: (_) {},
    );
    secondDependents = <ProviderElementBase<Object?>>[];
    secondElement.visitChildren(
      elementVisitor: secondDependents.add,
      notifierVisitor: (_) {},
    );
    expect(firstDependents, [computedElement]);
    expect(firstElement.hasListeners, true);
    expect(secondDependents, <ProviderElement<Object?>>[]);
    expect(secondElement.hasListeners, false);
  });

  // group('overrideWithValue', () {
  //   test('synchronously overrides the value', () {
  //     var callCount = 0;
  //     final provider = FutureProvider((ref) async {
  //       callCount++;
  //       return 0;
  //     });
  //     final container = createContainer(overrides: [
  //       provider.overrideWithValue(const AsyncValue.data(42)),
  //     ]);

  //     addTearDown(container.dispose);

  //     final sub = container.listen(provider, (_, __) {});

  //     expect(callCount, 0);
  //     expect(sub.read(), const AsyncValue.data(42));
  //   });
  // });

  test('remove dependencies on dispose', () async {
    final first = StateProvider((ref) => 0);
    final computed = Provider.autoDispose((ref) {
      return ref.watch(first);
    });
    final firstElement = container.readProviderElement(first);
    final computedElement = container.readProviderElement(computed);
    final sub = container.listen(computed, (_, __) {});

    expect(sub.read(), 0);
    var firstDependents = <ProviderElementBase<Object?>>[];
    firstElement.visitChildren(
      elementVisitor: firstDependents.add,
      notifierVisitor: (_) {},
    );
    expect(firstDependents, {computedElement});
    expect(firstElement.hasListeners, true);

    sub.close();
    await container.pump();

    firstDependents = <ProviderElementBase<Object?>>[];
    firstElement.visitChildren(
      elementVisitor: firstDependents.add,
      notifierVisitor: (_) {},
    );
    expect(firstDependents, <ProviderElement<Object?>>{});
    expect(firstElement.hasListeners, false);
  });

  test(
      'ProviderContainer.read(MyProvider.autoDispose) disposes the provider if not listened to',
      () async {
    final provider = StateProvider.autoDispose((ref) => 0);

    final state = container.read(provider.notifier);

    expect(state.mounted, true);

    await container.pump();

    expect(state.mounted, false);
  });

  group('Element.listen', () {
    group('didChange', () {
      test('is called synchronously on direct provider change', () {
        final counter = Counter();
        final provider = StateNotifierProvider<Counter, int>((ref) => counter);

        container.listen(provider, didChange.call);

        verifyZeroInteractions(didChange);

        counter.increment();

        verifyOnly(didChange, didChange(0, 1));
      });

      test('is called at most once per read for computed providers', () {
        final counter = Counter();
        final provider = StateNotifierProvider<Counter, int>((ref) => counter);
        final computed = Provider((ref) => ref.watch(provider));

        container.listen(computed, didChange.call);

        verifyZeroInteractions(didChange);

        counter.increment();
        counter.increment();
        counter.increment();

        container.read(computed);

        verifyOnly(didChange, didChange(0, 3));
      });

      test('are all executed after one read call', () {
        final counter = Counter();
        final provider = StateNotifierProvider<Counter, int>((ref) => counter);
        final didChange2 = Listener<int>();

        container.listen(provider, didChange.call);
        container.listen(provider, didChange2.call);

        counter.increment();

        verifyOnly(didChange, didChange(0, 1));
        verifyOnly(didChange2, didChange2(0, 1));
      });

      test('is guarded', () {
        final counter = Counter();
        final provider = StateNotifierProvider<Counter, int>((ref) => counter);
        final didChange2 = Listener<int>();
        when(didChange(any, any)).thenThrow(42);
        when(didChange2(any, any)).thenThrow(21);

        container.listen(provider, didChange.call);
        container.listen(provider, didChange2.call);

        final errors = errorsOf(counter.increment);

        expect(errors, unorderedEquals(<Object>[42, 21]));
        verifyOnly(didChange, didChange(0, 1));
        verifyOnly(didChange2, didChange2(0, 1));
      });
    });
  });

  group('ProviderSubscription', () {
    test('no longer call listeners anymore after close', () {
      final counter = Counter();
      final first = StateNotifierProvider<Counter, int>((ref) => counter);
      final provider = Provider((ref) => ref.watch(first));
      final element = container.readProviderElement(provider);

      expect(element.hasListeners, false);

      final sub = container.listen(provider, didChange.call);

      expect(element.hasListeners, true);

      sub.close();
      counter.increment();

      expect(element.hasListeners, false);
      verifyZeroInteractions(didChange);
    });

    group('.read', () {
      test('rethrows the exception thrown when building a provider', () {
        final error = Error();
        final provider = Provider<int>((ref) => throw error, name: 'hello');

        final sub = container.listen(provider, (_, __) {});

        expect(sub.read, throwsA(error));
      });

      test('rethrows the exception thrown when building a selected provider',
          () {
        final error = Error();
        final provider = Provider<int>((ref) => throw error, name: 'hello');

        final sub = container.listen(
          provider.select((value) => value),
          (_, __) {},
        );

        expect(sub.read, throwsA(error));
      });

      test('flushes the provider', () {
        final counter = Counter();
        final first = StateNotifierProvider<Counter, int>((ref) => counter);
        final provider = Provider((ref) => ref.watch(first));

        final sub = container.listen(provider, (_, __) {});

        expect(sub.read(), 0);

        counter.increment();

        expect(sub.read(), 1);
      });

      test('flushes the selected provider', () {
        final counter = Counter();
        final first = StateNotifierProvider<Counter, int>((ref) => counter);
        final provider = Provider((ref) => ref.watch(first));

        final sub = container.listen(
          provider.select((value) => value),
          (_, __) {},
        );

        expect(sub.read(), 0);

        counter.increment();

        expect(sub.read(), 1);
      });
    });
  });

  group('container.refresh', () {
    test('still refresh providers on non-root containers', () {
      final root = createContainer();
      final container = createContainer(parent: root);
      var callCount = 0;
      late Ref providerReference;
      var result = 0;
      final provider = Provider((ref) {
        callCount++;
        providerReference = ref;
        return result;
      });

      expect(root.read(provider), 0);
      expect(callCount, 1);
      expect(providerReference.container, root);

      result = 1;

      expect(container.refresh(provider), 1);
      expect(container.read(provider), 1);
      expect(callCount, 2);
      expect(providerReference.container, root);
    });

    test('immediately creates a new value, even if no changes are pending',
        () async {
      var future = Future.value(42);
      var callCount = 0;
      final provider = FutureProvider((ref) {
        callCount++;
        return future;
      });
      final container = createContainer();

      await expectLater(container.read(provider.future), completion(42));

      expect(callCount, 1);
      await expectLater(
        container.read(provider),
        const AsyncValue<int>.data(42),
      );

      future = Future.value(21);

      expect(
        container.refresh(provider),
        const AsyncLoading<int>()
            .copyWithPrevious(const AsyncValue<int>.data(42)),
      );
      expect(
        container.read(provider),
        const AsyncLoading<int>()
            .copyWithPrevious(const AsyncValue<int>.data(42)),
      );
      expect(callCount, 2);

      await expectLater(container.read(provider.future), completion(21));
      expect(callCount, 2);
    });

    test('retrying an unmounted provider just mounts it', () async {
      var callCount = 0;
      final provider = FutureProvider((ref) {
        callCount++;
        return Future.value(42);
      });
      final container = createContainer();

      expect(callCount, 0);
      expect(
        container.refresh(provider),
        const AsyncValue<int>.loading(),
      );
      expect(
        container.read(provider),
        const AsyncValue<int>.loading(),
      );
      expect(callCount, 1);
      await expectLater(container.read(provider.future), completion(42));
      expect(callCount, 1);
    });

    test(
        'refreshing a provider already marked as needing to update do not create the value twice',
        () async {
      var future = Future.value(42);
      var callCount = 0;
      final dep = StateProvider((_) => 0);
      final provider = FutureProvider((ref) {
        callCount++;
        ref.watch(dep);
        return future;
      });
      final container = createContainer();

      container.refresh(provider);

      expect(callCount, 1);

      container.read(dep.notifier).state++;
      future = Future.value(21);

      expect(callCount, 1);
      container.refresh(provider);

      expect(callCount, 2);
      await expectLater(container.read(provider.future), completion(21));
      expect(callCount, 2);
    });
  });
}
