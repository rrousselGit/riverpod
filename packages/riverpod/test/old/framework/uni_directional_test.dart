import 'package:mockito/mockito.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  late ProviderContainer container;
  setUp(() {
    container = ProviderContainer();
  });
  tearDown(() {
    container.dispose();
  });

  test(
      'Catches circular dependency when dependencies are setup during provider initialization',
      () {
    // regression for #1766
    final container = createContainer();

    final authInterceptorProvider = Provider((ref) => ref);

    final dioProvider = Provider<int>((ref) {
      ref.watch(authInterceptorProvider);
      return 0;
    });

    final accessTokenProvider = Provider<int>((ref) {
      return ref.watch(dioProvider);
    });

    container.read(dioProvider);
    final interceptor = container.read(authInterceptorProvider);

    expect(
      () => interceptor.read(accessTokenProvider),
      throwsA(isA<CircularDependencyError>()),
    );
  });

  group('ProviderContainer.debugVsyncs', () {
    // test('are called before modifying a provider', () {
    //   final provider = StateProvider((ref) => 0);
    //   final container = ProviderContainer();
    //   final vsync = VsyncMock();
    //   final vsync2 = VsyncMock();

    //   container.debugVsyncs.addAll([vsync, vsync2]);

    //   final state = container.read(provider);

    //   verifyZeroInteractions(vsync);
    //   verifyZeroInteractions(vsync2);

    //   state.state++;

    //   verifyOnly(vsync, vsync());
    //   verifyOnly(vsync2, vsync2());
    // });

    // test('are not called when flushing a provider', () {
    //   final dep = StateProvider((ref) => 0);
    //   final provider = Provider((ref) {
    //     return ref.watch(dep);
    //   });
    //   final container = ProviderContainer();
    //   final vsync = VsyncMock();

    //   final sub = container.listen(provider, (_) {});
    //   container.read(dep.notifier).state++;

    //   container.debugVsyncs.add(vsync);

    //   sub.flush();

    //   verifyZeroInteractions(vsync);
    // });

    // test('are not called when re-creating a provider', () {
    //   final provider = Provider((ref) => 0);
    //   final container = ProviderContainer();
    //   final vsync = VsyncMock();

    //   final sub = container.listen(provider, (_) {});
    //   container.refresh(provider);

    //   container.debugVsyncs.add(vsync);

    //   sub.flush();

    //   verifyZeroInteractions(vsync);
    // });
  });

  test('rebuilding a provider can modify other providers', () async {
    final dep = StateProvider((ref) => 0);
    final provider = Provider((ref) => ref.watch(dep));
    final another = StateProvider<int>((ref) {
      ref.listen(provider, (prev, value) => ref.controller.state++);
      return 0;
    });
    final container = createContainer();

    expect(container.read(another), 0);

    container.read(dep.notifier).state = 42;

    expect(container.read(another), 1);
  });

  group('ref.watch cannot end-up in a circular dependency', () {
    test('direct dependency', () {
      final provider = Provider((ref) => ref);
      final provider2 = Provider((ref) => ref);
      final container = ProviderContainer();

      final ref = container.read(provider);
      final ref2 = container.read(provider2);

      ref.watch(provider2);
      expect(
        () => ref2.watch(provider),
        throwsA(isA<CircularDependencyError>()),
      );
    });
    test('indirect dependency', () {
      final provider = Provider((ref) => ref);
      final provider2 = Provider((ref) => ref);
      final provider3 = Provider((ref) => ref);
      final provider4 = Provider((ref) => ref);
      final container = ProviderContainer();

      final ref = container.read(provider);
      final ref2 = container.read(provider2);
      final ref3 = container.read(provider3);
      final ref4 = container.read(provider4);

      ref.watch(provider2);
      ref2.watch(provider3);
      ref3.watch(provider4);

      expect(
        () => ref4.watch(provider),
        throwsA(isA<CircularDependencyError>()),
      );
    });
  });

  group('ref.read cannot end-up in a circular dependency', () {
    test('direct dependency', () {
      final provider = Provider((ref) => ref);
      final provider2 = Provider((ref) => ref);
      final container = ProviderContainer();

      final ref = container.read(provider);
      final ref2 = container.read(provider2);

      ref.watch(provider2);
      expect(
        () => ref2.read(provider),
        throwsA(isA<CircularDependencyError>()),
      );
    });
    test('indirect dependency', () {
      final provider = Provider((ref) => ref);
      final provider2 = Provider((ref) => ref);
      final provider3 = Provider((ref) => ref);
      final provider4 = Provider((ref) => ref);
      final container = ProviderContainer();

      final ref = container.read(provider);
      final ref2 = container.read(provider2);
      final ref3 = container.read(provider3);
      final ref4 = container.read(provider4);

      ref.watch(provider2);
      ref2.watch(provider3);
      ref3.watch(provider4);

      expect(
        () => ref4.read(provider),
        throwsA(isA<CircularDependencyError>()),
      );
    });
  });

  test("initState can't dirty ancestors", () {
    final ancestor = StateProvider((_) => 0);
    final child = Provider((ref) {
      ref.watch(ancestor.notifier).state++;
      return ref.watch(ancestor);
    });

    expect(errorsOf(() => container.read(child)), isNotEmpty);
  });

  test("initState can't dirty siblings", () {
    final ancestor = StateProvider((_) => 0, name: 'ancestor');
    final counter = Counter();
    final sibling = StateNotifierProvider<Counter, int>(
      name: 'sibling',
      (ref) {
        ref.watch(ancestor);
        return counter;
      },
    );
    var didWatchAncestor = false;
    final child = Provider(
      name: 'child',
      (ref) {
        ref.watch(ancestor);
        didWatchAncestor = true;
        counter.increment();
      },
    );

    container.read(sibling);

    expect(errorsOf(() => container.read(child)), isNotEmpty);
    expect(didWatchAncestor, true);
  });

  test("initState can't mark dirty other provider", () {
    final provider = StateProvider((ref) => 0);
    final provider2 = Provider((ref) {
      ref.watch(provider.notifier).state = 42;
      return 0;
    });

    expect(container.read(provider), 0);

    expect(errorsOf(() => container.read(provider2)), isNotEmpty);
  });

  test("nested initState can't mark dirty other providers", () {
    final counter = Counter();
    final provider = StateNotifierProvider<Counter, int>((_) => counter);
    final nested = Provider((_) => 0);
    final provider2 = Provider((ref) {
      ref.watch(nested);
      counter.increment();
      return 0;
    });

    expect(container.read(provider), 0);

    expect(errorsOf(() => container.read(provider2)), isNotEmpty);
  });

  test('auto dispose can dirty providers', () async {
    final counter = Counter();
    final provider = StateNotifierProvider<Counter, int>((_) => counter);
    var didDispose = false;
    final provider2 = Provider.autoDispose((ref) {
      ref.onDispose(() {
        didDispose = true;
        counter.increment();
      });
    });

    container.read(provider);

    final sub = container.listen<void>(provider2, (_, __) {});
    sub.close();

    expect(counter.state, 0);

    await container.pump();

    expect(didDispose, true);
    expect(counter.state, 1);
  });

  test("Provider can't dirty anything on create", () {
    final counter = Counter();
    final provider = StateNotifierProvider<Counter, int>((_) => counter);
    late List<Object> errors;
    final computed = Provider((ref) {
      errors = errorsOf(counter.increment);
      return 0;
    });
    final listener = Listener<int>();

    expect(container.read(provider), 0);

    container.listen(computed, listener.call, fireImmediately: true);

    verify(listener(null, 0)).called(1);
    verifyNoMoreInteractions(listener);
    expect(errors, isNotEmpty);
  });
}

// class VsyncMock extends Mock {
//   void call();
// }
