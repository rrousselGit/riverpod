import 'dart:async';

import 'package:meta/meta.dart';

import '../core/async_value.dart';
import '../framework.dart';
import 'builders.dart';
import 'future_provider.dart' show FutureProvider;
import 'notifier.dart';

part 'async_notifier/orphan.dart';
part 'async_notifier/family.dart';

abstract class _AsyncNotifierBase<StateT> extends ClassBase< //
    AsyncValue<StateT>,
    FutureOr<StateT>> {
  // TODO docs
  @protected
  Ref<AsyncValue<StateT>> get ref;

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
  @override
  AsyncValue<StateT> get state;

  @visibleForTesting
  @protected
  @override
  set state(AsyncValue<StateT> newState);

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
  Future<StateT> get future {
    // TODO remove downcast/upcast once "future" is merged with all providers
    final Object? element = this.element;
    if (element == null) throw StateError(uninitializedElementError);

    element as FutureModifierElement<StateT>;

    element.flush();
    return element.futureNotifier.value;
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
  Future<StateT> update(
    FutureOr<StateT> Function(StateT previousState) cb, {
    FutureOr<StateT> Function(Object err, StackTrace stackTrace)? onError,
  }) async {
    // TODO cancel on rebuild?

    final newState = await future.then(cb, onError: onError);
    state = AsyncData<StateT>(newState);
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
  bool updateShouldNotify(
    AsyncValue<StateT> previous,
    AsyncValue<StateT> next,
  ) {
    return FutureModifierElement.handleUpdateShouldNotify(
      previous,
      next,
    );
  }
}

abstract base class _AsyncNotifierProviderBase< //
        NotifierT extends _AsyncNotifierBase<StateT>,
        StateT> //
    extends ClassProvider< //
        NotifierT,
        AsyncValue<StateT>,
        FutureOr<StateT>,
        Ref<AsyncValue<StateT>>> //
    with
        FutureModifier<StateT> {
  const _AsyncNotifierProviderBase(
    this._createNotifier, {
    required super.name,
    required super.from,
    required super.argument,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.isAutoDispose,
    required super.runNotifierBuildOverride,
  });

  final NotifierT Function() _createNotifier;

  @override
  NotifierT create() => _createNotifier();
}
