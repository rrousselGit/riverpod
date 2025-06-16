part of '../framework.dart';

/// An object containing metadata about the listened object of a
/// [ProviderTransformer].
final class ProviderTransformerContext<InT, OutT> {
  ProviderTransformerContext._({
    required AsyncResult<InT> sourceState,
  }) : _sourceState = sourceState;

  AsyncResult<InT> _sourceState;

  /// The current state of [SyncProviderTransformerMixin.source].
  AsyncResult<InT> get sourceState => _sourceState;
}

/// {@template provider_transformer}
/// The logic responsible for transforming a [ProviderListenable] into another
/// [ProviderListenable].
///
/// It is both:
/// - the object that hols the current state of the transformation
/// - a description of how to react to various life-cycles
///   related to the listened object.
/// {@endtemplate}
class ProviderTransformer<InT, ValueT> {
  /// {@macro provider_transformer}
  ProviderTransformer({
    required this.listener,
    required ValueT Function(ProviderTransformer<InT, ValueT> self) initState,
    this.onClose,
  }) {
    _state = AsyncResult.guard(() => initState(this));
  }

  void Function(AsyncResult<ValueT> next)? _notify;

  /// A life-cycle method for when [ProviderSubscription] is closed.
  ///
  /// This callback will only be called once regardless of how many times
  /// [ProviderSubscription.close] is called.
  final void Function()? onClose;

  late AsyncResult<ValueT> _state;

  /// The currently exposed state of this transformer.
  ///
  /// Based on if using [SyncProviderTransformerMixin] or
  /// [AsyncProviderTransformerMixin], how the UI will react to [AsyncError]
  /// will differ:
  /// - [SyncProviderTransformerMixin] will rethrow the error
  /// - [AsyncProviderTransformerMixin] will return an [AsyncError] directly
  AsyncResult<ValueT> get state => _state;
  set state(AsyncResult<ValueT> value) {
    _state = value;
    _notify?.call(value);
  }

  /// A callback invoked when the source changes after the initial event.
  ///
  /// It will _not_ be called with the initial value.
  ///
  /// - `self` represents the `this` object of the [ProviderTransformer].
  ///   It offers a convenient way to call [ProviderTransformer.state].
  final void Function(
    ProviderTransformer<InT, ValueT> self,
    AsyncResult<InT> prev,
    AsyncResult<InT> next,
  ) listener;
}

extension<InT, StateT, ValueT>
    on _ProviderTransformerMixin<InT, StateT, ValueT> {
  ProviderSubscriptionImpl<StateT> _handle(
    Node source,
    void Function(StateT? previous, StateT next) listener, {
    required void Function(Object error, StackTrace stackTrace) onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool weak,
    required $Result<StateT> Function(AsyncResult<ValueT> asyncResult) read,
  }) {
    ExternalProviderSubscription<InT, StateT>? resultSub;

    late final ProviderSubscription<InT> sub;
    late final context = ProviderTransformerContext<InT, ValueT>._(
      // ignore: unused_result, false positive
      sourceState: switch (sub.readSafe()) {
        $ResultData(:final value) => AsyncData(value),
        $ResultError(:final error, :final stackTrace) =>
          AsyncError(error, stackTrace),
      },
    );

    AsyncResult<ProviderTransformer<InT, ValueT>>? transformer;
    AsyncResult<ProviderTransformer<InT, ValueT>> upsertTransformer() {
      if (transformer == null) {
        transformer = AsyncResult.guard(() {
          final transformer = transform(context);

          var currentResult = read(transformer.state);

          transformer._notify = (next) {
            final prevResult = currentResult;
            currentResult = read(next);

            final sub = resultSub;
            // Emitted during init, we can ignore it
            if (sub == null) return;

            switch (currentResult) {
              case $ResultData(:final value):
                sub._notifyData(prevResult.value, value);
              case $ResultError(
                  error: ProviderException(exception: final error),
                  :final stackTrace
                ):
              case $ResultError(:final error, :final stackTrace):
                sub._notifyError(error, stackTrace);
            }
          };

          return transformer;
        });

        if (transformer case AsyncError(:final error, :final stackTrace)) {
          resultSub!._notifyError(error, stackTrace);
        }
      }

      return transformer!;
    }

    void setSourceState(AsyncResult<InT> state) {
      final prev = context._sourceState;
      context._sourceState = state;

      // Don't call `upsert` here to avoid calling `listener` on lazy-loaded init.
      if (transformer?.value case final transformer?) {
        source.container.runTernaryGuarded(
          transformer.listener,
          transformer,
          prev,
          state,
        );
      }

      upsertTransformer();
    }

    sub = this.source._addListener(
          source,
          (previous, next) => setSourceState(AsyncData(next)),
          onError: (err, stackTrace) => setSourceState(
            AsyncError(err, stackTrace),
          ),
          onDependencyMayHaveChanged: onDependencyMayHaveChanged,
          weak: weak,
        );

    resultSub = ExternalProviderSubscription.fromSub(
      innerSubscription: sub,
      listener: listener,
      onError: onError,
      onClose: () {
        final onClose = transformer?.value?.onClose;
        if (onClose != null) {
          source.container.runGuarded(onClose);
        }
      },
      read: () => read(
        switch (upsertTransformer()) {
          AsyncData() && final transformer => transformer.value.state,
          // Maps transformer errors as state errors
          AsyncError(:final error, :final stackTrace) =>
            AsyncError(error, stackTrace),
        },
      ),
    );

    // 'weak' is lazy loaded, but weak:false isn't.
    // We rely on 'late final' for that.
    if (!weak) {
      upsertTransformer();
    }

    return resultSub;
  }
}

abstract class _ProviderTransformerMixin<InT, StateT, ValueT>
    implements ProviderListenable<StateT> {
  /// The source of this transformer.
  ///
  /// This is the provider that this transformer listens to.
  ProviderListenable<InT> get source;

  ProviderTransformer<InT, ValueT> transform(
    ProviderTransformerContext<InT, ValueT> context,
  );
}

/// A mixin for custom [ProviderListenable]s that do not emit [AsyncValue].
///
/// If in error state, an exception will happen when trying to read the state
/// of this listenable.
///
/// See also:
/// - [AsyncProviderTransformerMixin], for listenables that emit an [AsyncValue]
/// - [ProviderTransformer], the object responsible for the transformation logic.
base mixin SyncProviderTransformerMixin<InT, ValueT>
    implements _ProviderTransformerMixin<InT, ValueT, ValueT> {
  @override
  ProviderSubscriptionImpl<ValueT> _addListener(
    Node source,
    void Function(ValueT? previous, ValueT next) listener, {
    required void Function(Object error, StackTrace stackTrace) onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool weak,
  }) {
    return _handle(
      source,
      listener,
      onError: onError,
      onDependencyMayHaveChanged: onDependencyMayHaveChanged,
      weak: weak,
      read: (asyncResult) {
        switch (asyncResult) {
          case AsyncData(:final value):
            return $ResultData(value);
          case AsyncError():
            return $ResultError(asyncResult.error, asyncResult.stackTrace);
        }
      },
    );
  }
}

/// A mixin for custom [ProviderListenable]s that emit an [AsyncValue].
///
/// If in error state, an [AsyncError] will be emitted instead of an exception.
///
/// See also:
/// - [SyncProviderTransformerMixin], for listenables that do not emit an
///   [AsyncValue]
/// - [ProviderTransformer], the object responsible for the transformation logic.
base mixin AsyncProviderTransformerMixin<InT, ValueT>
    implements _ProviderTransformerMixin<InT, AsyncValue<ValueT>, ValueT> {
  @override
  ProviderSubscriptionImpl<AsyncValue<ValueT>> _addListener(
    Node source,
    void Function(AsyncValue<ValueT>? previous, AsyncValue<ValueT> next)
        listener, {
    required void Function(Object error, StackTrace stackTrace) onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool weak,
  }) {
    return _handle(
      source,
      listener,
      onError: onError,
      onDependencyMayHaveChanged: onDependencyMayHaveChanged,
      weak: weak,
      read: $Result.data,
    );
  }
}
