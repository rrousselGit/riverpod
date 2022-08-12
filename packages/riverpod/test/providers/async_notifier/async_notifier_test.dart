import 'dart:async';

import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart' hide ErrorListener;
import 'package:test/test.dart';

import '../../matchers.dart';
import '../../utils.dart';

void main() {
  group('AsyncNotifierProvider', () {
    // TODO handle isRefreshing
    test(
        'converts AsyncNotifier.build into an AsyncData if the future completes',
        () async {
      final provider = _TestNotifierProvider((ref) => Future.value(0));
      final container = createContainer();
      final listener = Listener<AsyncValue<int>>();

      container.listen(provider, listener, fireImmediately: true);

      verifyOnly(listener, listener(null, const AsyncLoading()));
      expect(
        container.read(provider.notifier).state,
        const AsyncLoading<int>(),
      );

      expect(await container.read(provider.future), 0);

      verifyOnly(listener, listener(const AsyncLoading(), const AsyncData(0)));
      expect(container.read(provider.notifier).state, const AsyncData<int>(0));
    });

    test('converts AsyncNotifier.build into an AsyncError if the future fails',
        () async {
      final provider = _TestNotifierProvider<int>(
        (ref) => Future.error(0, StackTrace.empty),
      );
      final container = createContainer();
      final listener = Listener<AsyncValue<int>>();

      container.listen(provider, listener, fireImmediately: true);

      verifyOnly(listener, listener(null, const AsyncLoading()));
      expect(
        container.read(provider.notifier).state,
        const AsyncLoading<int>(),
      );

      await expectLater(container.read(provider.future), throwsA(0));

      verifyOnly(
        listener,
        listener(const AsyncLoading(), const AsyncError(0, StackTrace.empty)),
      );
      expect(
        container.read(provider.notifier).state,
        const AsyncError<int>(0, StackTrace.empty),
      );
    });

    test('supports cases where the AsyncNotifier constructor throws', () async {
      final provider = AsyncNotifierProvider<TestNotifier<int>, int>(
        () => Error.throwWithStackTrace(0, StackTrace.empty),
      );
      final container = createContainer();
      final listener = Listener<AsyncValue<int>>();

      container.listen(provider, listener, fireImmediately: true);

      verifyOnly(
        listener,
        listener(null, const AsyncError(0, StackTrace.empty)),
      );
      expect(
        () => container.read(provider.notifier),
        throwsA(0),
      );

      await expectLater(container.read(provider.future), throwsA(0));
    });

    test(
        'synchronously emits AsyncData if AsyncNotifier.build emits synchronously',
        () async {
      final provider = _TestNotifierProvider<int>((ref) => 0);
      final container = createContainer();
      final listener = Listener<AsyncValue<int>>();

      container.listen(provider, listener, fireImmediately: true);

      verifyOnly(listener, listener(null, const AsyncData(0)));
      expect(container.read(provider.notifier).state, const AsyncData(0));
      expect(container.read(provider.future), isSynchronousFuture<int>(0));
    });

    test(
        'synchronously emits AsyncError if AsyncNotifier.build throws synchronously',
        () async {
      final provider = _TestNotifierProvider<int>(
        (ref) => Error.throwWithStackTrace(42, StackTrace.empty),
      );
      final container = createContainer();
      final listener = Listener<AsyncValue<int>>();

      container.listen(provider, listener, fireImmediately: true);

      verifyOnly(
        listener,
        listener(null, const AsyncError(42, StackTrace.empty)),
      );
      expect(
        container.read(provider.notifier).state,
        const AsyncError<int>(42, StackTrace.empty),
      );
      await expectLater(container.read(provider.future), throwsA(42));
    });

    group('update', () {});
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
AsyncNotifierProvider<TestNotifier<T>, T> _TestNotifierProvider<T>(
  FutureOr<T> Function(AsyncNotifierProviderRef<T> ref) init, {
  bool Function(T prev, T next)? updateShouldNotify,
}) {
  return AsyncNotifierProvider<TestNotifier<T>, T>(
    () => TestNotifier(init, updateShouldNotify: updateShouldNotify),
  );
}

class TestNotifier<T> extends AsyncNotifier<T> {
  TestNotifier(this._init, {bool Function(T prev, T next)? updateShouldNotify})
      : _updateShouldNotify = updateShouldNotify;

  final FutureOr<T> Function(AsyncNotifierProviderRef<T> ref) _init;

  final bool Function(T prev, T next)? _updateShouldNotify;

  // overriding to remove the @protected
  @override
  AsyncValue<T> get state => super.state;

  @override
  set state(AsyncValue<T> value) {
    super.state = value;
  }

  @override
  FutureOr<T> build() => _init(ref);

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
