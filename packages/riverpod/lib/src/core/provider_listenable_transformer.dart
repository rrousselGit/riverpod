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

base mixin ProviderTransformerMixin<InT, StateT, ValueT>
    implements ProviderListenable<StateT> {
  /// The source of this transformer.
  ///
  /// This is the provider that this transformer listens to.
  ProviderListenable<InT> get source;

  @override
  ProviderSubscriptionImpl<StateT> _addListener(
    Node source,
    void Function(StateT? previous, StateT next) listener, {
    required void Function(Object error, StackTrace stackTrace) onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool weak,
  }) {
    ExternalProviderSubscription<InT, StateT>? resultSub;
    AsyncResult<ProviderTransformer<InT, ValueT>>? transformer;
    late final ProviderTransformerContext<InT, ValueT> context;

    void setSourceState(AsyncResult<InT> state) {
      final prev = context._sourceState;
      context._sourceState = state;

      try {
        if (transformer?.value case final transformer?) {
          transformer.listener(transformer, prev, state);
        }
      } catch (e, stack) {
        onError(e, stack);
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
      sourceState: AsyncResult.guard(sub.read),
    );

    final t = transformer = AsyncResult.guard(() {
      final transformer = transform(context);

      var currentResult = $Result.guard(() => read(transformer.state));

      transformer._notify = (next) {
        final prevResult = currentResult;
        currentResult = $Result.guard(() => read(next));

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
      read: () => read(t.requireValue.state),
    );
  }

  StateT read(AsyncResult<ValueT> asyncResult);

  ProviderTransformer<InT, ValueT> transform(
    ProviderTransformerContext<InT, ValueT> context,
  );
}
