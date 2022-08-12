import 'dart:async';

import 'package:meta/meta.dart';

import 'common.dart';
import 'framework.dart';
import 'listenable.dart';
import 'result.dart';
import 'synchronous_future.dart';

part 'async_notifier/base.dart';

abstract class AsyncNotifierBase<State> {
  void _setElement(ProviderElementBase<AsyncValue<State>> element);

  @protected
  AsyncValue<State> get state;

  @protected
  set state(AsyncValue<State> value);

  Ref<AsyncValue<State>> get ref;

  @visibleForOverriding
  FutureOr<State> build();

  Future<State> future();

  FutureOr<State> update(
    FutureOr<State> Function(State) cb, {
    FutureOr<State> Function(State)? onError,
  }) {
    // TODO cancel on rebuild?
    return future().then(cb, onError: onError);
  }

  bool updateShouldNotify(State previous, State next) {
    return !identical(previous, next);
  }
}

ProviderElementProxy<AsyncValue<T>, NotifierT>
    _notifier<NotifierT extends AsyncNotifierBase<T>, T>(
  _AsyncNotifierProviderBase<NotifierT, T> that,
) {
  return ProviderElementProxy<AsyncValue<T>, NotifierT>(
    that,
    (element) {
      return (element as AsyncNotifierProviderElement<NotifierT, T>)
          ._notifierNotifier;
    },
  );
}

ProviderElementProxy<AsyncValue<T>, Future<T>> _future<T>(
  _AsyncNotifierProviderBase<AsyncNotifierBase<T>, T> that,
) {
  return ProviderElementProxy<AsyncValue<T>, Future<T>>(
    that,
    (element) {
      return (element as AsyncNotifierProviderElement<AsyncNotifierBase<T>, T>)
          ._futureNotifier;
    },
  );
}

abstract class _AsyncNotifierProviderBase<
    NotifierT extends AsyncNotifierBase<T>,
    T> extends ProviderBase<AsyncValue<T>> {
  _AsyncNotifierProviderBase(
    this._createNotifier, {
    required super.name,
    required super.from,
    required super.argument,
    required this.dependencies,
    required super.cacheTime,
    required super.disposeDelay,
  });

  @override
  final List<ProviderOrFamily>? dependencies;

  /// Obtains the [AsyncNotifier] associated with this provider, without listening
  /// to state changes.
  ///
  /// This is typically used to invoke methods on a [AsyncNotifier]. For example:
  ///
  /// ```dart
  /// Button(
  ///   onTap: () => ref.read(stateNotifierProvider.notifer).increment(),
  /// )
  /// ```
  ///
  /// This listenable will notify its notifiers if the [AsyncNotifier] instance
  /// changes.
  /// This may happen if the provider is refreshed or one of its dependencies
  /// has changes.
  ProviderListenable<NotifierT> get notifier;

// TODO doc
  ProviderListenable<Future<T>> get future;

  final NotifierT Function() _createNotifier;

  @override
  bool updateShouldNotify(AsyncValue<T> previousState, AsyncValue<T> newState) {
    return true;
  }
}
