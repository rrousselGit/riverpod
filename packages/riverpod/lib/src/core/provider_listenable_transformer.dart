part of '../framework.dart';

final class ProviderTransformerContext<InT, OutT> {
  ProviderTransformerContext._({
    required AsyncResult<InT> sourceState,
  }) : _sourceState = sourceState;

  AsyncResult<InT> _sourceState;
  AsyncResult<InT> get sourceState => _sourceState;
}

class ProviderTransformer<InT, ValueT> {
  ProviderTransformer({
    required this.listener,
    required ValueT Function() initialState,
  }) : _state = AsyncResult.guard(initialState);

  void Function(AsyncResult<ValueT> next)? _notify;

  AsyncResult<ValueT> _state;
  AsyncResult<ValueT> get state => _state;
  set state(AsyncResult<ValueT> value) {
    _state = value;
    _notify?.call(value);
  }

  final void Function(
    ProviderTransformer<InT, ValueT> self,
    AsyncResult<InT>? prev,
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
    AsyncResult<ProviderTransformer<InT, ValueT>>? transformer;
    late final ProviderTransformerContext<InT, ValueT> context;

    void setSourceState(AsyncResult<InT> state) {
      final prev = context._sourceState;
      context._sourceState = state;

      if (transformer?.value case final transformer?) {
        runZonedGuarded(
          () => transformer.listener(transformer, prev, state),
          source.container.defaultOnError,
        );
      }
    }

    final sub = this.source._addListener(
          source,
          (previous, next) => setSourceState(AsyncData(next)),
          onError: (err, stackTrace) => setSourceState(
            AsyncError(err, stackTrace),
          ),
          onDependencyMayHaveChanged: onDependencyMayHaveChanged,
          weak: weak,
        );

    context = ProviderTransformerContext._(
      // ignore: unused_result, false positive
      sourceState: switch (sub.readSafe()) {
        $ResultData(:final value) => AsyncData(value),
        $ResultError(:final error, :final stackTrace) =>
          AsyncError(error, stackTrace),
      },
    );

    final t = transformer = AsyncResult.guard(() {
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

    return resultSub = ExternalProviderSubscription.fromSub(
      innerSubscription: sub,
      listener: listener,
      onError: onError,
      read: () => read(
        switch (t) {
          AsyncData() => t.value.state,
          // Maps transformer errors as state errors
          AsyncError(:final error, :final stackTrace) =>
            AsyncError(error, stackTrace),
        },
      ),
    );
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
