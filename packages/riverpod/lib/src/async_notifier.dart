import 'dart:async';

import 'package:meta/meta.dart';

import 'common.dart';
import 'framework.dart';
import 'listenable.dart';
import 'result.dart';
import 'synchronous_future.dart';

part 'async_notifier/base.dart';
part 'async_notifier/auto_dispose.dart';

@visibleForTesting
abstract class AsyncNotifierBase<State> {
  AsyncNotifierProviderElement<AsyncNotifierBase<State>, State> get _element;

  void _setElement(ProviderElementBase<AsyncValue<State>> element);

  @protected
  @override
  AsyncValue<State> get state {
    _element.flush();
    // ignore: invalid_use_of_protected_member
    return _element.requireState;
  }

  @protected
  @override
  set state(AsyncValue<State> value) {
    // ignore: invalid_use_of_protected_member
    _element.setState(value);
  }

  Ref<AsyncValue<State>> get ref;

  @visibleForOverriding
  FutureOr<State> build();

  @override
  Future<State> future() {
    _element.flush();
    return _element._futureNotifier.value;
  }

  @protected
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
  AsyncNotifierProviderBase<NotifierT, T> that,
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
  AsyncNotifierProviderBase<AsyncNotifierBase<T>, T> that,
) {
  return ProviderElementProxy<AsyncValue<T>, Future<T>>(
    that,
    (element) {
      return (element as AsyncNotifierProviderElement<AsyncNotifierBase<T>, T>)
          ._futureNotifier;
    },
  );
}

@visibleForTesting
abstract class AsyncNotifierProviderBase<NotifierT extends AsyncNotifierBase<T>,
    T> extends ProviderBase<AsyncValue<T>> {
  AsyncNotifierProviderBase(
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
