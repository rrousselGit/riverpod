import 'dart:async';

import 'package:meta/meta.dart';

import 'builders.dart';
import 'common.dart';
import 'framework.dart';
import 'future_provider.dart' show FutureProvider;
import 'listenable.dart';
import 'notifier.dart';
import 'pragma.dart';
import 'result.dart';
import 'run_guarded.dart';
import 'stream_provider.dart';

part 'async_notifier/auto_dispose.dart';
part 'async_notifier/auto_dispose_family.dart';
part 'async_notifier/base.dart';
part 'async_notifier/family.dart';
part 'stream_notifier.dart';
part 'stream_notifier/auto_dispose.dart';
part 'stream_notifier/auto_dispose_family.dart';
part 'stream_notifier/base.dart';
part 'stream_notifier/family.dart';

/// A base class for [AsyncNotifier].
///
/// Not meant for public consumption.
@internal
abstract class AsyncNotifierBase<State> {
  AsyncNotifierProviderElementBase<AsyncNotifierBase<State>, State>
      get _element;

  void _setElement(ProviderElementBase<AsyncValue<State>> element);

  /// {@macro notifier.listen}
  void listenSelf(
    void Function(AsyncValue<State>? previous, AsyncValue<State> next)
        listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
  }) {
    _element.listenSelf(listener, onError: onError);
  }

  /// The value currently exposed by this [AsyncNotifier].
  ///
  /// Defaults to [AsyncLoading] inside the [AsyncNotifier.build] method.
  ///
  /// Invoking the setter will notify listeners if [updateShouldNotify] returns true.
  /// By default, this always notifies listeners (unless going from "loading"
  /// to "loading", in which case the change is ignored).
  ///
  /// Reading [state] if the provider is out of date (such as if one of its
  /// dependency has changed) will trigger [AsyncNotifier.build] to be re-executed.
  @visibleForTesting
  @protected
  AsyncValue<State> get state {
    _element.flush();
    // ignore: invalid_use_of_protected_member
    return _element.requireState;
  }

  @visibleForTesting
  @protected
  set state(AsyncValue<State> newState) {
    _element.state = newState;
  }

  /// The [Ref] from the provider associated with this [AsyncNotifier].
  @protected
  Ref<AsyncValue<State>> get ref;

  /// {@template riverpod.async_notifier.future}
  /// Obtains a [Future] that resolves with the first [state] value that is not
  /// [AsyncLoading].
  ///
  /// This future will not necessarily wait for [AsyncNotifier.build] to complete.
  /// If [state] is modified before [AsyncNotifier.build] completes, then [future]
  /// will resolve with that new [state] value.
  ///
  /// The future will fail if [state] is in error state. In which case the
  /// error will be the same as [AsyncValue.error] and its stacktrace.
  /// {@endtemplate}
  @visibleForTesting
  @protected
  Future<State> get future {
    _element.flush();
    return _element.futureNotifier.value;
  }

  /// A function to update [state] from its previous value, while
  /// abstracting loading/error cases for [state].
  ///
  /// This method neither causes [state] to go back to "loading" while the
  /// operation is pending. Neither does it cause [state] to go to error state
  /// if the operation fails.
  ///
  /// If [state] was in error state, the callback will not be invoked and instead
  /// the error will be returned. Alternatively, [onError] can specified to
  /// gracefully handle error states.
  ///
  /// See also:
  /// - [future], for manually awaiting the resolution of [state].
  /// - [AsyncValue.guard], and alternate way to perform asynchronous operations.
  @visibleForTesting
  @protected
  Future<State> update(
    FutureOr<State> Function(State) cb, {
    FutureOr<State> Function(Object err, StackTrace stackTrace)? onError,
  }) async {
    // TODO cancel on rebuild?

    final newState = await future.then(cb, onError: onError);
    state = AsyncData<State>(newState);
    return newState;
  }

  /// A method invoked when the state exposed by this [AsyncNotifier] changes.
  ///
  /// As opposed to with [Notifier.updateShouldNotify], this method
  /// does not filter out changes to [state] that are equal to the previous
  /// value.
  /// By default, any change to [state] will emit an update.
  /// This method can be overridden to implement custom filtering logic if that
  /// is undesired.
  ///
  /// The reasoning for this default behavior is that [AsyncNotifier.build]
  /// returns a [Future]. As such, the value of [state] typically transitions
  /// from "loading" to "data" or "error". In that scenario, the value equality
  /// does not matter. Checking `==` would only hinder performances for no reason.
  ///
  /// See also:
  /// - [ProviderBase.select] and [AsyncSelector.selectAsync], which are
  ///   alternative ways to filter out changes to [state].
  @protected
  bool updateShouldNotify(AsyncValue<State> previous, AsyncValue<State> next) {
    return FutureHandlerProviderElementMixin.handleUpdateShouldNotify(
      previous,
      next,
    );
  }
}

ProviderElementProxy<AsyncValue<T>, NotifierT>
    _asyncNotifier<NotifierT extends AsyncNotifierBase<T>, T>(
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

ProviderElementProxy<AsyncValue<T>, Future<T>> _asyncFuture<T>(
  AsyncNotifierProviderBase<AsyncNotifierBase<T>, T> that,
) {
  return ProviderElementProxy<AsyncValue<T>, Future<T>>(
    that,
    (element) {
      return (element as AsyncNotifierProviderElement<AsyncNotifierBase<T>, T>)
          .futureNotifier;
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
  const AsyncNotifierProviderBase(
    this._createNotifier, {
    required super.name,
    required super.from,
    required super.argument,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
  });

  /// Obtains the [AsyncNotifier] associated with this provider, without listening
  /// to state changes.
  ///
  /// This is typically used to invoke methods on a [AsyncNotifier]. For example:
  ///
  /// ```dart
  /// Button(
  ///   onTap: () => ref.read(stateNotifierProvider.notifier).increment(),
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

  /// Runs the `build` method of a notifier.
  ///
  /// This is an implementation detail for differentiating [AsyncNotifier.build]
  /// from [FamilyAsyncNotifier.build].
  FutureOr<T> runNotifierBuild(AsyncNotifierBase<T> notifier);
}
