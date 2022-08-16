import 'dart:async';

import 'package:meta/meta.dart';

import 'builders.dart';
import 'common.dart';
import 'framework.dart';
import 'listenable.dart';
import 'notifier.dart';
import 'result.dart';
import 'synchronous_future.dart';

part 'async_notifier/base.dart';
part 'async_notifier/auto_dispose.dart';
part 'async_notifier/family.dart';
part 'async_notifier/auto_dispose_family.dart';

/// A base class for [AsyncNotifier].
///
/// Not meant for public consumption.
@visibleForTesting
@internal
abstract class AsyncNotifierBase<State> {
  AsyncNotifierProviderElement<AsyncNotifierBase<State>, State> get _element;

  void _setElement(ProviderElementBase<AsyncValue<State>> element);

  /// The value currently exposed by this [Notifier].
  ///
  /// Invoking the setter will notify listeners if [updateShouldNotify] returns true.
  /// By default, this will compare the previous and new value using [identical].
  ///
  /// Reading [state] if the provider is out of date (such as if one of its
  /// dependency has changed) will trigger [Notifier.build] to be re-executed.
  @protected
  AsyncValue<State> get state {
    _element.flush();
    // ignore: invalid_use_of_protected_member
    return _element.requireState;
  }

  @protected
  set state(AsyncValue<State> value) {
    // ignore: invalid_use_of_protected_member
    _element.setState(value);
  }

  /// The [Ref] associated with []
  Ref<AsyncValue<State>> get ref;

  /// {@template riverpod.async_notifier.future}
  /// Obtains a [Future] that resolves with the first [state] value that is not
  /// [AsyncLoading].
  ///
  /// This future will not necesserily wait for [AsyncNotifier.build] to complete.
  /// If [state] is modified before [AsyncNotifier.build] completes, then [future]
  /// will resolve with that new [state] value.
  ///
  /// The future will fail if [AsyncNotifier.build] throws or returns a future
  /// that fails.
  /// {@endtemplate}
  Future<State> get future {
    _element.flush();
    return _element._futureNotifier.value;
  }

  @protected
  FutureOr<State> update(
    FutureOr<State> Function(State) cb, {
    FutureOr<State> Function(State)? onError,
  }) {
    // TODO cancel on rebuild?
    return future.then(cb, onError: onError);
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

/// A base class for [AsyncNotifierProvider]
///
/// Not meant for public consumption
@visibleForTesting
@internal
abstract class AsyncNotifierProviderBase<NotifierT extends AsyncNotifierBase<T>,
    T> extends ProviderBase<AsyncValue<T>> {
  /// A base class for [AsyncNotifierProvider]
  ///
  /// Not meant for public consumption
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
  Refreshable<NotifierT> get notifier;

  /// {@macro riverpod.async_notifier.future}
  ///
  /// Listening to this using [Ref.watch] will rebuild the widget/provider
  /// when the [AsyncNotifier] emits a new value.
  /// This will then return a new [Future] that resoles with the latest "state".
  Refreshable<Future<T>> get future;

  final NotifierT Function() _createNotifier;

  FutureOr<T> _runNotifierBuild(AsyncNotifierBase<T> notifier);

  @override
  bool updateShouldNotify(AsyncValue<T> previousState, AsyncValue<T> newState) {
    return true;
  }
}
