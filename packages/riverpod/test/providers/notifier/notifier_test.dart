import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart' hide ErrorListener;
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('NotifierProvider', () {
    test(
        'uses notifier.build as initial state and update listeners when state changes',
        () {
      final provider = _TestNotifierProvider((ref) => 0);
      final container = createContainer();
      final listener = Listener<int>();

      container.listen(provider, listener, fireImmediately: true);

      verifyOnly(listener, listener(null, 0));

      container.read(provider.notifier).update((state) => state + 1);

      verifyOnly(listener, listener(0, 1));
    });

    test('preserves the notifier between watch updates', () async {
      final dep = StateProvider((ref) => 0);
      final provider = _TestNotifierProvider((ref) {
        return ref.watch(dep);
      });
      final container = createContainer();
      final listener = Listener<TestNotifier<int>>();

      container.listen(provider.notifier, listener, fireImmediately: true);

      final notifier = container.read(provider.notifier);

      verifyOnly(listener, listener(null, notifier));

      container.read(dep.notifier).update((state) => state + 1);
      await container.pump();

      verifyNoMoreInteractions(listener);
      expect(container.read(provider.notifier), notifier);
    });

    test('calls notifier.build on every watch update', () async {
      final dep = StateProvider((ref) => 0);
      final provider = _TestNotifierProvider((ref) {
        return ref.watch(dep);
      });
      final container = createContainer();
      final listener = Listener<int>();

      container.listen(provider, listener, fireImmediately: true);

      verifyOnly(listener, listener(null, 0));

      container.read(dep.notifier).update((state) => state + 1);

      verifyNoMoreInteractions(listener);

      await container.pump();

      verifyOnly(listener, listener(0, 1));
    });

    test('After a state initialization error, the notifier is still available',
        () {
      final provider = _TestNotifierProvider<int>((ref) {
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
      final provider = NotifierProvider<TestNotifier<int>, int>(
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

      final stateSub =
          container.listen(provider, (previous, next) {}, onError: listener);

      verifyNoMoreInteractions(listener);

      container.listen(
        provider,
        (previous, next) {},
        onError: listener,
        fireImmediately: true,
      );

      verifyOnly(listener, listener(err, stack));

      final notifierSub = container
          .listen(provider.notifier, (previous, next) {}, onError: listener);

      verifyNoMoreInteractions(listener);

      container.listen(
        provider.notifier,
        (previous, next) {},
        onError: listener,
        fireImmediately: true,
      );

      verifyOnly(listener, listener(err, stack));

      expect(stateSub.read, throwsUnimplementedError);
      expect(notifierSub.read, throwsUnimplementedError);
    });

    test('can read/set the current state within the notifier', () {
      final provider = _TestNotifierProvider<int>((ref) => 0);
      final container = createContainer();
      final listener = Listener<int>();

      container.listen(provider, listener, fireImmediately: true);
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
      final provider =
          _TestNotifierProvider<int>((ref) => throw UnimplementedError());
      final container = createContainer();

      final notifier = container.read(provider.notifier);

      expect(() => notifier.state, throwsUnimplementedError);
    });

    test(
        'Setting the state after an initialization error allow listening the state again',
        () {
      final err = UnimplementedError();
      final stack = StackTrace.current;
      final provider = _TestNotifierProvider<int>(
          (ref) => Error.throwWithStackTrace(err, stack));
      final container = createContainer();
      final listener = Listener<int>();
      final onError = ErrorListener();

      container.listen(
        provider,
        listener,
        onError: onError,
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
        listener,
        onError: onError,
        fireImmediately: true,
      );

      verifyOnly(listener, listener(null, 0));
      verifyNoMoreInteractions(onError);
    });

    test('reading notifier.state on invalidated provider rebuilds the provider',
        () {
      final dep = StateProvider((ref) => 0);
      final provider = _TestNotifierProvider<int>((ref) => ref.watch(dep));
      final container = createContainer();
      final listener = Listener<int>();

      container.listen(provider, listener);
      final notifier = container.read(provider.notifier);

      expect(notifier.state, 0);

      notifier.state = -1;

      verifyOnly(listener, listener(0, -1));

      container.read(dep.notifier).state++;

      expect(notifier.state, 1);
      verifyOnly(listener, listener(-1, 1));
    });

    test('supports ref.refresh(provider)', () {
      final provider = _TestNotifierProvider<int>((ref) => 0);
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
      final provider = _TestNotifierProvider<int>((ref) {
        ref.listenSelf(listener, onError: onError);
        Error.throwWithStackTrace(42, StackTrace.empty);
      });
      final container = createContainer();

      expect(() => container.read(provider), throwsA(42));

      verifyOnly(onError, onError(42, StackTrace.empty));
    });

    test('filters state update by identical by default', () {
      final provider = _TestNotifierProvider<Equal<int>>((ref) => Equal(42));
      final container = createContainer();
      final listener = Listener<Equal<int>>();

      container.listen(provider, listener);
      final notifier = container.read(provider.notifier);
      final firstState = notifier.state;

      notifier.state = notifier.state;

      verifyZeroInteractions(listener);

      final secondState = notifier.state = Equal(42);

      verifyOnly(listener, listener(firstState, secondState));
    });

    test(
        'Can override Notifier.updateShouldNotify to change the default filter logic',
        () {
      final provider = _TestNotifierProvider<Equal<int>>(
        (ref) => Equal(42),
        updateShouldNotify: (a, b) => a != b,
      );
      final container = createContainer();
      final listener = Listener<Equal<int>>();

      container.listen(provider, listener);
      final notifier = container.read(provider.notifier);
      notifier.state = notifier.state;

      verifyZeroInteractions(listener);

      notifier.state = Equal(42);

      verifyZeroInteractions(listener);

      notifier.state = Equal(21);

      verifyOnly(listener, listener(Equal(42), Equal(21)));
    }, skip: 'implement Notifier.updateShouldNotify');

    test('can override the Notifier with a matching custom implementation',
        () {});

    test('can override Notifier.build', () {});

    test('invalidating/refreshing .notifier throws', () {});

    test('calls notifier.initState once', () {});

    test(
        'calls to onDispose inside initState are executed when the element is destroyed',
        () {});

    test(
        'calls to listenSelf inside initState are cleared when the element is destroyed',
        () {});

    test(
        'calls to listen inside initState are cleared when the element is destroyed',
        () {});
  });

  group('autoDispose', () {
    test('keeps state alive if notifier is listened', () {});

    test('does not rebuild state if only notifier is listened', () {});
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

// ignore: non_constant_identifier_names
NotifierProvider<TestNotifier<T>, T> _TestNotifierProvider<T>(
  T Function(Ref<T> ref) init, {
  bool Function(T prev, T next)? updateShouldNotify,
}) {
  return NotifierProvider<TestNotifier<T>, T>(
    () => TestNotifier(init, updateShouldNotify: updateShouldNotify),
  );
}

class TestNotifier<T> extends Notifier<T> {
  TestNotifier(this._init, {bool Function(T prev, T next)? updateShouldNotify})
      : _updateShouldNotify = updateShouldNotify;

  final T Function(NotifierProviderRef<T> ref) _init;

  final bool Function(T prev, T next)? _updateShouldNotify;

  // overriding to remove the @protected
  @override
  T get state => super.state;

  @override
  set state(T value) {
    super.state = value;
  }

  @override
  T build() => _init(ref);

  void update(T Function(T state) cb) => state = cb(state);

  @override
  bool updateShouldNotify(T previous, T next) {
    return _updateShouldNotify?.call(previous, next) ??
        super.updateShouldNotify(previous, next);
  }

  @override
  String toString() {
    return 'TestNotifier<$T>#$hashCode';
  }
}
