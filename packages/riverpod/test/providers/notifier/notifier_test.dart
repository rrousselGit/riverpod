// ignore_for_file: avoid_types_on_closure_parameters

import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart' hide ErrorListener;
import 'package:test/test.dart';

import '../../utils.dart';
import 'factory.dart';

void main() {
  for (final factory in matrix()) {
    group(factory.label, () {
      test(
          'throws if the same Notifier instance is reused in different providers',
          () {
        // Regression test for https://github.com/rrousselGit/riverpod/issues/2617
        final container = createContainer();

        final notifier = factory.notifier((ref) => 0);

        final provider = factory.provider<TestNotifierBase<int>, int>(
          () => notifier,
        );
        final provider2 = factory.provider<TestNotifierBase<int>, int>(
          () => notifier,
        );

        container.read(provider);

        expect(
          () => container.read(provider2),
          throwsA(isA<Error>()),
        );
      });

      group('Notifier.stateOrNull', () {
        test('returns null during first build until state= is set', () {
          final stateInBuild = <int?>[];

          final provider = NotifierProvider<TestNotifier<int>, int>(() {
            late TestNotifier<int> notifier;
            return notifier = TestNotifier((ref) {
              stateInBuild.add(notifier.stateOrNull);
              return 0;
            });
          });
          final container = createContainer();

          final sub = container.listen(
            provider.notifier,
            (_, __) {},
          );

          expect(stateInBuild, [null]);

          expect(sub.read().stateOrNull, 0);
        });

        test('returns null if Notifier.build threw', () {
          final provider = factory.simpleTestProvider<int>(
            (ref) => throw Exception('42'),
          );
          final container = createContainer();

          final sub = container.listen(
            provider.notifier,
            (_, __) {},
          );

          expect(sub.read().stateOrNull, null);
        });

        test(
            'returns the previous state if using inside Notifier.build '
            'after the state was already initialized', () {
          final stateInBuild = <int?>[];

          final provider = NotifierProvider<TestNotifier<int>, int>(() {
            late TestNotifier<int> notifier;
            return notifier = TestNotifier((ref) {
              stateInBuild.add(notifier.stateOrNull);
              return 0;
            });
          });
          final container = createContainer();

          final sub = container.listen(
            provider.notifier,
            (_, __) {},
          );

          sub.read().state = 42;
          container.refresh(provider);

          expect(stateInBuild, [null, 42]);
        });

        test('Post build, returns the current state', () {
          final provider = factory.simpleTestProvider<int>(
            (ref) => 0,
          );
          final container = createContainer();

          final sub = container.listen(
            provider.notifier,
            (_, __) {},
          );

          expect(sub.read().stateOrNull, 0);

          sub.read().state = 42;

          expect(sub.read().stateOrNull, 42);
        });

        test(
            'On invalidated providers, rebuilds the notifier and return the new state',
            () {
          final provider = factory.simpleTestProvider<int>(
            (ref) => 0,
          );
          final container = createContainer();

          final sub = container.listen(
            provider.notifier,
            (_, __) {},
          );

          sub.read().state = 42;

          expect(sub.read().stateOrNull, 42);

          container.invalidate(provider);

          expect(sub.read().stateOrNull, 0);
        });
      });

      test(
          'uses notifier.build as initial state and update listeners when state changes',
          () {
        final provider = factory.simpleTestProvider((ref) => 0);
        final container = createContainer();
        final listener = Listener<int>();

        container.listen(provider, listener.call, fireImmediately: true);

        verifyOnly(listener, listener(null, 0));

        container.read(provider.notifier).state++;

        verifyOnly(listener, listener(0, 1));
      });

      test('preserves the notifier between watch updates', () async {
        final dep = StateProvider((ref) => 0);
        final provider = factory.simpleTestProvider((ref) {
          return ref.watch(dep);
        });
        final container = createContainer();
        final listener = Listener<TestNotifierBase<int>>();

        container.listen(
          provider.notifier,
          listener.call,
          fireImmediately: true,
        );

        final notifier = container.read(provider.notifier);

        verifyOnly(listener, listener(null, notifier));

        container.read(dep.notifier).update((state) => state + 1);
        await container.pump();

        verifyNoMoreInteractions(listener);
        expect(container.read(provider.notifier), notifier);
      });

      test('calls notifier.build on every watch update', () async {
        final dep = StateProvider((ref) => 0);
        final provider = factory.simpleTestProvider((ref) {
          return ref.watch(dep);
        });
        final container = createContainer();
        final listener = Listener<int>();

        container.listen(provider, listener.call, fireImmediately: true);

        verifyOnly(listener, listener(null, 0));

        container.read(dep.notifier).update((state) => state + 1);

        verifyNoMoreInteractions(listener);

        await container.pump();

        verifyOnly(listener, listener(0, 1));
      });

      test(
          'After a state initialization error, the notifier is still available',
          () {
        final provider = factory.simpleTestProvider<int>((ref) {
          throw StateError('Hey');
        });
        final container = createContainer();

        expect(
          () => container.read(provider),
          throwsStateError,
        );

        container.read(provider.notifier);
      });

      test('handles fail to initialize the notifier', () {
        final err = UnimplementedError();
        final stack = StackTrace.current;
        final provider = factory.provider<TestNotifierBase<int>, int>(
          () => Error.throwWithStackTrace(err, stack),
        );
        final container = createContainer();
        final listener = ErrorListener();

        expect(
          () => container.read(provider.notifier),
          throwsUnimplementedError,
        );
        expect(
          () => container.read(provider),
          throwsUnimplementedError,
        );

        final stateSub = container.listen(
          provider,
          (previous, next) {},
          onError: listener.call,
        );

        verifyNoMoreInteractions(listener);

        container.listen(
          provider,
          (previous, next) {},
          onError: listener.call,
          fireImmediately: true,
        );

        verifyOnly(listener, listener(err, stack));

        final notifierSub = container.listen(
          provider.notifier,
          (previous, next) {},
          onError: listener.call,
        );

        verifyNoMoreInteractions(listener);

        container.listen(
          provider.notifier,
          (previous, next) {},
          onError: listener.call,
          fireImmediately: true,
        );

        verifyOnly(listener, listener(err, stack));

        expect(stateSub.read, throwsUnimplementedError);
        expect(notifierSub.read, throwsUnimplementedError);
      });

      test('can read/set the current state within the notifier', () {
        final provider = factory.simpleTestProvider<int>((ref) => 0);
        final container = createContainer();
        final listener = Listener<int>();

        container.listen(provider, listener.call, fireImmediately: true);
        final notifier = container.read(provider.notifier);

        expect(notifier.state, 0);
        verifyOnly(listener, listener(null, 0));

        notifier.state++;

        expect(notifier.state, 1);
        verifyOnly(listener, listener(0, 1));

        notifier.state++;

        expect(notifier.state, 2);
        verifyOnly(listener, listener(1, 2));
      });

      test(
          'Reading the state inside the notifier rethrows initilization error, if any',
          () {
        final provider = factory
            .simpleTestProvider<int>((ref) => throw UnimplementedError());
        final container = createContainer();

        final notifier = container.read(provider.notifier);

        expect(() => notifier.state, throwsUnimplementedError);
      });

      test(
          'Setting the state after an initialization error allow listening the state again',
          () {
        final err = UnimplementedError();
        final stack = StackTrace.current;
        final provider = factory.simpleTestProvider<int>(
          (ref) => Error.throwWithStackTrace(err, stack),
        );
        final container = createContainer();
        final listener = Listener<int>();
        final onError = ErrorListener();

        container.listen(
          provider,
          listener.call,
          onError: onError.call,
          fireImmediately: true,
        );
        final notifier = container.read(provider.notifier);

        verifyOnly(onError, onError(err, stack));
        verifyZeroInteractions(listener);

        expect(() => notifier.state, throwsUnimplementedError);

        notifier.state = 0;

        verifyOnly(listener, listener(null, 0));
        verifyNoMoreInteractions(onError);
        expect(notifier.state, 0);
        expect(container.read(provider), 0);

        container.listen(
          provider,
          listener.call,
          onError: onError.call,
          fireImmediately: true,
        );

        verifyOnly(listener, listener(null, 0));
        verifyNoMoreInteractions(onError);
      });

      test(
          'reading notifier.state on invalidated provider rebuilds the provider',
          () {
        final dep = StateProvider((ref) => 0);
        final provider =
            factory.simpleTestProvider<int>((ref) => ref.watch(dep));
        final container = createContainer();
        final listener = Listener<int>();

        container.listen(provider, listener.call);
        final notifier = container.read(provider.notifier);

        expect(notifier.state, 0);

        notifier.state = -1;

        verifyOnly(listener, listener(0, -1));

        container.read(dep.notifier).state++;

        expect(notifier.state, 1);
        verifyOnly(listener, listener(-1, 1));
      });

      test('supports ref.refresh(provider)', () {
        final provider = factory.simpleTestProvider<int>((ref) => 0);
        final container = createContainer();

        final notifier = container.read(provider.notifier);

        expect(container.read(provider), 0);

        notifier.state = 42;

        expect(container.read(provider), 42);

        expect(container.refresh(provider), 0);
        expect(container.read(provider), 0);
        expect(notifier.state, 0);
        expect(container.read(provider.notifier), notifier);
      });

      test('supports listenSelf((State? prev, State next) {})', () {
        final listener = Listener<int>();
        final onError = ErrorListener();
        final provider = factory.simpleTestProvider<int>((ref) {
          ref.listenSelf(listener.call, onError: onError.call);
          Error.throwWithStackTrace(42, StackTrace.empty);
        });
        final container = createContainer();

        expect(() => container.read(provider), throwsA(42));

        verifyOnly(onError, onError(42, StackTrace.empty));
      });

      test('filters state update by identical by default', () {
        final provider =
            factory.simpleTestProvider<Equal<int>>((ref) => Equal(42));
        final container = createContainer();
        final listener = Listener<Equal<int>>();

        container.listen(provider, listener.call);
        final notifier = container.read(provider.notifier);
        final firstState = notifier.state;

        // voluntarily assigning the same value
        final self = notifier.state;
        notifier.state = self;

        verifyZeroInteractions(listener);

        final secondState = notifier.state = Equal(42);

        verifyOnly(listener, listener(firstState, secondState));
      });

      test(
          'Can override Notifier.updateShouldNotify to change the default filter logic',
          () {
        final provider = factory.simpleTestProvider<Equal<int>>(
          (ref) => Equal(42),
          updateShouldNotify: (a, b) => a != b,
        );
        final container = createContainer();
        final listener = Listener<Equal<int>>();

        container.listen(provider, listener.call);
        final notifier = container.read(provider.notifier);

        // voluntarily assigning the same value
        final self = notifier.state;
        notifier.state = self;

        verifyZeroInteractions(listener);

        notifier.state = Equal(42);

        verifyZeroInteractions(listener);

        notifier.state = Equal(21);

        verifyOnly(listener, listener(Equal(42), Equal(21)));
      });

      test(
        'can override the Notifier with a matching custom implementation',
        () {},
        skip: 'TODO',
      );

      test('can override Notifier.build', () {});
    });

    if (factory.isAutoDispose) {
      group('autoDispose', () {
        test('keeps state alive if notifier is listened', () async {
          final container = createContainer();
          final onDispose = OnDisposeMock();
          final provider = factory.simpleTestProvider<int>((ref) {
            ref.onDispose(onDispose.call);
            return 0;
          });

          final sub = container.listen(provider, (prev, next) {});
          verifyZeroInteractions(onDispose);
          expect(container.getAllProviderElements().single.origin, provider);

          await container.pump();

          verifyZeroInteractions(onDispose);
          expect(container.getAllProviderElements().single.origin, provider);

          sub.close();
          await container.pump();

          verifyOnly(onDispose, onDispose());
          expect(container.getAllProviderElements(), isEmpty);
        });
      });
    }
  }

  test('supports overrideWith', () {
    final provider = NotifierProvider<TestNotifier<int>, int>(
      () => TestNotifier((ref) => 0),
    );
    final autoDispose =
        NotifierProvider.autoDispose<AutoDisposeTestNotifier<int>, int>(
      () => AutoDisposeTestNotifier((ref) => 0),
    );
    final container = createContainer(
      overrides: [
        provider.overrideWith(() => TestNotifier((ref) => 42)),
        autoDispose.overrideWith(
          () => AutoDisposeTestNotifier((ref) => 84),
        ),
      ],
    );

    expect(container.read(provider), 42);
    expect(container.read(autoDispose), 84);
  });

  test('supports family overrideWith', () {
    final family = NotifierProvider.family<TestNotifierFamily<int>, int, int>(
      () => TestNotifierFamily<int>((ref) => 0),
    );
    final autoDisposeFamily = NotifierProvider.autoDispose
        .family<AutoDisposeTestNotifierFamily<int>, int, int>(
      () => AutoDisposeTestNotifierFamily<int>((ref) => 0),
    );
    final container = createContainer(
      overrides: [
        family.overrideWith(
          () => TestNotifierFamily<int>((ref) => 42),
        ),
        autoDisposeFamily.overrideWith(
          () => AutoDisposeTestNotifierFamily<int>((ref) => 84),
        ),
      ],
    );

    expect(container.read(family(10)), 42);
    expect(container.read(autoDisposeFamily(10)), 84);
  });

  group('modifiers', () {
    void canBeAssignedToAlwaysAliveRefreshable<T>(
      AlwaysAliveRefreshable<T> provider,
    ) {}

    void canBeAssignedToRefreshable<T>(
      Refreshable<T> provider,
    ) {}

    void canBeAssignedToAlwaysAliveListenable<T>(
      AlwaysAliveProviderListenable<T> provider,
    ) {}

    void canBeAssignedToProviderListenable<T>(
      ProviderListenable<T> provider,
    ) {}

    // TODO use package:expect_error to test that commented lined are not compiling

    test('provider', () {
      final provider = NotifierProvider<TestNotifier<int>, int>(
        () => TestNotifier((ref) => 0),
      );

      provider.select((int value) => 0);

      canBeAssignedToProviderListenable<int>(provider);
      canBeAssignedToAlwaysAliveListenable<int>(provider);
      canBeAssignedToRefreshable<int>(provider);
      canBeAssignedToAlwaysAliveRefreshable<int>(provider);

      canBeAssignedToProviderListenable<Notifier<int>>(provider.notifier);
      canBeAssignedToAlwaysAliveListenable<Notifier<int>>(
        provider.notifier,
      );
      canBeAssignedToRefreshable<Notifier<int>>(provider.notifier);
      canBeAssignedToAlwaysAliveRefreshable<Notifier<int>>(
        provider.notifier,
      );
    });

    test('autoDispose', () {
      final autoDispose =
          NotifierProvider.autoDispose<AutoDisposeTestNotifier<int>, int>(
        () => AutoDisposeTestNotifier((ref) => 0),
      );

      autoDispose.select((int value) => 0);

      canBeAssignedToProviderListenable<int>(autoDispose);
      // canBeAssignedToAlwaysAliveListenable<int>(autoDispose);
      canBeAssignedToRefreshable<int>(autoDispose);
      // canBeAssignedToAlwaysAliveRefreshable<int>(autoDispose);

      canBeAssignedToProviderListenable<AutoDisposeNotifier<int>>(
        autoDispose.notifier,
      );
      // canBeAssignedToAlwaysAliveListenable<AutoDisposeNotifier<int>>(
      //   autoDispose.notifier,
      // );
      canBeAssignedToRefreshable<AutoDisposeNotifier<int>>(
        autoDispose.notifier,
      );
      // canBeAssignedToAlwaysAliveRefreshable<AutoDisposeNotifier<int>>(
      //   autoDispose.notifier,
      // );
    });

    test('family', () {
      final family =
          NotifierProvider.family<TestNotifierFamily<String>, String, int>(
        () => TestNotifierFamily((ref) => '0'),
      );

      family(0).select((String value) => 0);

      canBeAssignedToProviderListenable<String>(family(0));
      canBeAssignedToAlwaysAliveListenable<String>(family(0));
      canBeAssignedToRefreshable<String>(family(0));
      canBeAssignedToAlwaysAliveRefreshable<String>(family(0));

      canBeAssignedToProviderListenable<FamilyNotifier<String, int>>(
        family(0).notifier,
      );
      canBeAssignedToAlwaysAliveListenable<FamilyNotifier<String, int>>(
        family(0).notifier,
      );
      canBeAssignedToRefreshable<FamilyNotifier<String, int>>(
        family(0).notifier,
      );
      canBeAssignedToAlwaysAliveRefreshable<FamilyNotifier<String, int>>(
        family(0).notifier,
      );
    });

    test('autoDisposeFamily', () {
      expect(
        NotifierProvider.autoDispose.family,
        same(NotifierProvider.family.autoDispose),
      );

      final autoDisposeFamily = NotifierProvider.autoDispose
          .family<AutoDisposeTestNotifierFamily<String>, String, int>(
        () => AutoDisposeTestNotifierFamily((ref) => '0'),
      );

      autoDisposeFamily(0).select((String value) => 0);

      canBeAssignedToProviderListenable<String>(
        autoDisposeFamily(0),
      );
      // canBeAssignedToAlwaysAliveListenable<String>(
      //   autoDisposeFamily(0),
      // );
      canBeAssignedToRefreshable<String>(
        autoDisposeFamily(0),
      );
      // canBeAssignedToAlwaysAliveRefreshable<String>(
      //   autoDisposeFamily(0),
      // );

      canBeAssignedToProviderListenable<AutoDisposeFamilyNotifier<String, int>>(
        autoDisposeFamily(0).notifier,
      );
      // canBeAssignedToAlwaysAliveListenable<
      //     AutoDisposeFamilyNotifier<String, int>>(
      //   autoDisposeFamily(0).notifier,
      // );
      canBeAssignedToRefreshable<AutoDisposeFamilyNotifier<String, int>>(
        autoDisposeFamily(0).notifier,
      );
      // canBeAssignedToAlwaysAliveRefreshable<
      //     AutoDisposeFamilyNotifier<String, int>>(
      //   autoDisposeFamily(0).notifier,
      // );
    });
  });
}

@immutable
class Equal<T> {
  // ignore: prefer_const_constructors_in_immutables
  Equal(this.value);

  final T value;

  @override
  bool operator ==(Object other) => other is Equal<T> && other.value == value;

  @override
  int get hashCode => Object.hash(runtimeType, value);
}
