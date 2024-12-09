// ignore_for_file: avoid_types_on_closure_parameters, invalid_use_of_protected_member, prefer_const_constructors

import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework.dart' show UnmountedRefException;
import 'package:riverpod/src/providers/notifier.dart' show $Notifier;
import 'package:test/test.dart';

import '../matrix.dart';
import '../utils.dart';

void main() {
  test('Throws if using notifier properties in its constructor', () {
    final errors = captureErrors([
      () => CtorNotifier().state,
      () => CtorNotifier().state = 42,
      () => CtorNotifier().ref,
      () => FamilyCtorNotifier().state,
      () => FamilyCtorNotifier().state = 42,
      () => FamilyCtorNotifier().ref,
    ]);
  });

  notifierProviderFactory.createGroup((factory) {
    test('Cannot share a Notifier instance between providers ', () {
      final container = ProviderContainer.test();
      final notifier = factory.deferredNotifier((ref, _) => 0);

      final provider = factory.provider<int>(() => notifier);
      final provider2 = factory.provider<int>(() => notifier);

      container.read(provider);

      expect(
        () => container.read(provider2),
        throwsA(isA<StateError>()),
      );
    });

    test('Cannot read properties inside onDispose', () {
      final container = ProviderContainer.test();
      late TestNotifier<int> notifier;
      late List<Object?> errors;
      final provider = factory.simpleTestProvider((ref, _) {
        ref.onDispose(() {
          errors = captureErrors([
            () => notifier.state,
            () => notifier.state = 42,
          ]);
        });
        return 0;
      });

      container.listen(provider.notifier, (prev, next) {});
      notifier = container.read(provider.notifier);

      container.dispose();

      expect(
        errors,
        everyElement(isA<UnmountedRefException>()),
      );
    });

    test('Using the notifier after dispose throws', () {
      final container = ProviderContainer.test();
      final provider = factory.simpleTestProvider((ref, _) => 0);

      container.listen(provider.notifier, (prev, next) {});
      final notifier = container.read(provider.notifier);

      container.dispose();

      expect(notifier.ref.mounted, false);
      expect(
        () => notifier.state,
        throwsA(isA<UnmountedRefException>()),
      );
      expect(
        () => notifier.state = 42,
        throwsA(isA<UnmountedRefException>()),
      );
    });

    test(
        'throws if the same Notifier instance is reused in different providers',
        () {
      // Regression test for https://github.com/rrousselGit/riverpod/issues/2617
      final container = ProviderContainer.test();

      final notifier = factory.deferredNotifier((ref, _) => 0);

      final provider = factory.provider<int>(() => notifier);
      final provider2 = factory.provider<int>(() => notifier);

      container.read(provider);

      expect(
        () => container.read(provider2),
        throwsA(isA<Error>()),
      );
    });

    group('Notifier.stateOrNull', () {
      test('returns null during first build until state= is set', () {
        final stateInBuild = <int?>[];

        final provider = factory.provider(() {
          late TestNotifier<int> notifier;
          return notifier = factory.deferredNotifier((ref, _) {
            stateInBuild.add(notifier.stateOrNull);
            return 0;
          });
        });
        final container = ProviderContainer.test();

        final sub = container.listen(
          provider.notifier,
          (_, __) {},
        );

        expect(stateInBuild, [null]);

        expect(sub.read().stateOrNull, 0);
      });

      test('returns null if Notifier.build threw', () {
        final provider = factory.simpleTestProvider<int>(
          (ref, _) => throw Exception('42'),
        );
        final container = ProviderContainer.test();

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

        final provider = factory.provider(() {
          late TestNotifier<int> notifier;
          return notifier = factory.deferredNotifier((ref, _) {
            stateInBuild.add(notifier.stateOrNull);
            return 0;
          });
        });
        final container = ProviderContainer.test();

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
          (ref, _) => 0,
        );
        final container = ProviderContainer.test();

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
          (ref, _) => 0,
        );
        final container = ProviderContainer.test();

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
      final provider = factory.simpleTestProvider((ref, _) => 0);
      final container = ProviderContainer.test();
      final listener = Listener<int>();

      container.listen(provider, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, 0));

      container.read(provider.notifier).state++;

      verifyOnly(listener, listener(0, 1));
    });

    group('.notifier', () {
      test(
          'Notifies listeners whenever `build` is re-executed, due to recreating a new notifier.',
          () async {
        final notifierListener = Listener<$Notifier<int>>();
        final dep = StateProvider((ref) => 0);
        final provider = factory.provider<int>(() {
          return factory.deferredNotifier((ref, _) => ref.watch(dep));
        });
        final container = ProviderContainer.test();

        final sub = container.listen(provider.notifier, notifierListener.call);
        final initialNotifier = sub.read();

        expect(initialNotifier.ref.mounted, true);

        container.refresh(provider);
        final newNotifier = sub.read();

        expect(newNotifier, isNot(same(initialNotifier)));
        verifyOnly(
          notifierListener,
          notifierListener(initialNotifier, newNotifier),
        ).called(1);
        expect(initialNotifier.ref.mounted, false);
        expect(newNotifier.ref.mounted, true);
      });
    });

    test('calls notifier.build on every watch update', () async {
      final dep = StateProvider((ref) => 0);
      final provider = factory.simpleTestProvider((ref, _) {
        return ref.watch(dep);
      });
      final container = ProviderContainer.test();
      final listener = Listener<int>();

      container.listen(provider, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, 0));

      container.read(dep.notifier).update((state) => state + 1);

      verifyNoMoreInteractions(listener);

      await container.pump();

      verifyOnly(listener, listener(0, 1));
    });

    test('After a state initialization error, the notifier is still available',
        () {
      final provider = factory.simpleTestProvider<int>((ref, _) {
        throw StateError('Hey');
      });
      final container = ProviderContainer.test();

      expect(
        () => container.read(provider),
        throwsStateError,
      );

      container.read(provider.notifier);
    });

    test('handles fail to initialize the notifier', () {
      final err = UnimplementedError();
      final stack = StackTrace.current;
      final provider = factory.provider<int>(
        () => Error.throwWithStackTrace(err, stack),
      );
      final container = ProviderContainer.test();
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
      final provider = factory.simpleTestProvider<int>((ref, _) => 0);
      final container = ProviderContainer.test();
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
        'Reading the state inside the notifier rethrows initialization error, if any',
        () {
      final provider = factory
          .simpleTestProvider<int>((ref, _) => throw UnimplementedError());
      final container = ProviderContainer.test();

      final notifier = container.read(provider.notifier);

      expect(() => notifier.state, throwsUnimplementedError);
    });

    test(
        'Setting the state after an initialization error allow listening the state again',
        () {
      final err = UnimplementedError();
      final stack = StackTrace.current;
      final provider = factory.simpleTestProvider<int>(
        (ref, _) => Error.throwWithStackTrace(err, stack),
      );
      final container = ProviderContainer.test();
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

    test('supports ref.refresh(provider)', () {
      final provider = factory.simpleTestProvider<int>((ref, _) => 0);
      final container = ProviderContainer.test();

      expect(container.read(provider), 0);

      container.read(provider.notifier).state = 42;

      expect(container.read(provider), 42);

      expect(container.refresh(provider), 0);
      expect(container.read(provider), 0);
      expect(container.read(provider.notifier).state, 0);
    });

    group('listenSelf', () {
      test('can remove the data listener', () async {
        final container = ProviderContainer.test();
        final listener = Listener<int>();
        late final RemoveListener remove;
        final provider = factory.simpleTestProvider<int>((ref, self) {
          remove = self.listenSelf(listener.call);
          return 0;
        });

        container.listen(provider.notifier, (previous, next) {});
        clearInteractions(listener);

        remove();

        container.read(provider.notifier).state = 42;

        verifyZeroInteractions(listener);
      });

      test('can remove the error listener', () async {
        final container = ProviderContainer.test();
        final listener = ErrorListener();
        final provider = factory.simpleTestProvider<int>((ref, self) {
          final remove = self.listenSelf((a, b) {}, onError: listener.call);
          remove();

          throw StateError('');
        });

        container.listen(provider.notifier, (previous, next) {});

        verifyZeroInteractions(listener);
      });

      test('supports listenSelf((State? prev, State next) {})', () {
        final listener = Listener<int>();
        final onError = ErrorListener();
        final provider = factory.simpleTestProvider<int>((ref, self) {
          self.listenSelf(listener.call, onError: onError.call);
          Error.throwWithStackTrace(42, StackTrace.empty);
        });
        final container = ProviderContainer.test();

        expect(() => container.read(provider), throwsA(42));

        verifyOnly(onError, onError(42, StackTrace.empty));
      });
    });

    test('filters state update by identical by default', () {
      final provider =
          factory.simpleTestProvider<Equal<int>>((ref, _) => Equal(42));
      final container = ProviderContainer.test();
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
        (ref, _) => Equal(42),
        updateShouldNotify: (a, b) => a != b,
      );
      final container = ProviderContainer.test();
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

    test('can override Notifier.build', () {});

    if (factory.isAutoDispose) {
      group('autoDispose', () {
        test('keeps state alive if notifier is listened', () async {
          final container = ProviderContainer.test();
          final onDispose = OnDisposeMock();
          final provider = factory.simpleTestProvider<int>((ref, _) {
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
  });

  test('supports overrideWith', () {
    final provider = NotifierProvider<DeferredNotifier<int>, int>(
      () => DeferredNotifier((ref, _) => 0),
    );
    final autoDispose =
        NotifierProvider.autoDispose<DeferredNotifier<int>, int>(
      () => DeferredNotifier((ref, _) => 0),
    );
    final container = ProviderContainer.test(
      overrides: [
        provider.overrideWith(() => DeferredNotifier((ref, _) => 42)),
        autoDispose.overrideWith(
          () => DeferredNotifier((ref, _) => 84),
        ),
      ],
    );

    expect(container.read(provider), 42);
    expect(container.read(autoDispose), 84);
  });

  test('supports family overrideWith', () {
    final family =
        NotifierProvider.family<DeferredFamilyNotifier<int>, int, int>(
      () => DeferredFamilyNotifier<int>((ref, _) => 0),
    );
    final autoDisposeFamily = NotifierProvider.autoDispose
        .family<DeferredFamilyNotifier<int>, int, int>(
      () => DeferredFamilyNotifier<int>((ref, _) => 0),
    );
    final container = ProviderContainer.test(
      overrides: [
        family.overrideWith(
          () => DeferredFamilyNotifier<int>((ref, _) => 42),
        ),
        autoDisposeFamily.overrideWith(
          () => DeferredFamilyNotifier<int>((ref, _) => 84),
        ),
      ],
    );

    expect(container.read(family(10)), 42);
    expect(container.read(autoDisposeFamily(10)), 84);
  });

  group('modifiers', () {
    void canBeAssignedToRefreshable<T>(
      Refreshable<T> provider,
    ) {}

    void canBeAssignedToProviderListenable<T>(
      ProviderListenable<T> provider,
    ) {}

    test('provider', () {
      final provider = NotifierProvider<DeferredNotifier<int>, int>(
        () => DeferredNotifier((ref, _) => 0),
      );

      provider.select((int value) => 0);

      canBeAssignedToProviderListenable<int>(provider);
      canBeAssignedToRefreshable<int>(provider);

      canBeAssignedToProviderListenable<Notifier<int>>(provider.notifier);
      canBeAssignedToRefreshable<Notifier<int>>(provider.notifier);
    });

    test('autoDispose', () {
      final autoDispose =
          NotifierProvider.autoDispose<DeferredNotifier<int>, int>(
        () => DeferredNotifier((ref, _) => 0),
      );

      autoDispose.select((int value) => 0);

      canBeAssignedToProviderListenable<int>(autoDispose);
      canBeAssignedToRefreshable<int>(autoDispose);

      canBeAssignedToProviderListenable<DeferredNotifier<int>>(
        autoDispose.notifier,
      );
      canBeAssignedToRefreshable<DeferredNotifier<int>>(
        autoDispose.notifier,
      );
    });

    test('family', () {
      final family =
          NotifierProvider.family<DeferredFamilyNotifier<String>, String, int>(
        () => DeferredFamilyNotifier((ref, _) => '0'),
      );

      family(0).select((String value) => 0);

      canBeAssignedToProviderListenable<String>(family(0));
      canBeAssignedToRefreshable<String>(family(0));

      canBeAssignedToProviderListenable<FamilyNotifier<String, int>>(
        family(0).notifier,
      );
      canBeAssignedToRefreshable<FamilyNotifier<String, int>>(
        family(0).notifier,
      );
    });

    test('autoDisposeFamily', () {
      expect(
        NotifierProvider.autoDispose.family,
        same(NotifierProvider.family.autoDispose),
      );

      final autoDisposeFamily = NotifierProvider.autoDispose
          .family<DeferredFamilyNotifier<String>, String, int>(
        () => DeferredFamilyNotifier((ref, _) => '0'),
      );

      autoDisposeFamily(0).select((String value) => 0);

      canBeAssignedToProviderListenable<String>(
        autoDisposeFamily(0),
      );
      canBeAssignedToRefreshable<String>(
        autoDisposeFamily(0),
      );

      canBeAssignedToProviderListenable<FamilyNotifier<String, int>>(
        autoDisposeFamily(0).notifier,
      );
      canBeAssignedToRefreshable<FamilyNotifier<String, int>>(
        autoDisposeFamily(0).notifier,
      );
    });
  });
}

@immutable
class Equal<T> {
  const Equal(this.value);

  final T value;

  @override
  bool operator ==(Object other) => other is Equal<T> && other.value == value;

  @override
  int get hashCode => Object.hash(runtimeType, value);
}

class CtorNotifier extends Notifier<int> {
  @override
  int build() => 0;
}

class FamilyCtorNotifier extends FamilyNotifier<int, int> {
  @override
  int build(int arg) => 0;
}
