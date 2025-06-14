part of '../framework.dart';

final class ProviderTransformerContext<InT, OutT> {
  ProviderTransformerContext._({
    required $Result<InT> sourceState,
  }) : _sourceState = sourceState;

  $Result<InT> _sourceState;
  $Result<InT> get sourceState => _sourceState;
}

class ProviderTransformer<InT, OutT> {
  ProviderTransformer({
    required this.listener,
    required $Result<OutT> initialState,
  }) : state = initialState;

  void Function($Result<OutT>? prev, $Result<OutT> next)? _notify;

  $Result<OutT> state;

  final void Function(
    ProviderTransformer<InT, OutT> self,
    $Result<InT>? prev,
    $Result<InT> next,
  ) listener;
}

base mixin ProviderTransformerMixin<InT, OutT>
    implements ProviderListenable<OutT> {
  /// The source of this transformer.
  ///
  /// This is the provider that this transformer listens to.
  ProviderListenable<InT> get source;

  @override
  ProviderSubscriptionImpl<OutT> _addListener(
    Node source,
    void Function(OutT? previous, OutT next) listener, {
    required void Function(Object error, StackTrace stackTrace) onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool weak,
  }) {
    ExternalProviderSubscription<InT, OutT>? resultSub;
    $Result<ProviderTransformer<InT, OutT>>? transformer;
    late final ProviderTransformerContext<InT, OutT> context;

    void setSourceState($Result<InT> state) {
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
          (previous, next) => setSourceState($ResultData(next)),
          onError: (err, stackTrace) => setSourceState(
            $ResultError(err, stackTrace),
          ),
          onDependencyMayHaveChanged: onDependencyMayHaveChanged,
          weak: weak,
        );

    context = ProviderTransformerContext<InT, OutT>._(
      sourceState: $Result.guard(sub.read),
    );

    final t = transformer = $Result.guard(() {
      final transformer = transform(context);

      transformer._notify = (prev, next) {
        final sub = resultSub;
        // Emitted during init, we can ignore it
        if (sub == null) return;

        switch (next) {
          case $ResultData():
            sub._notifyData(prev?.value, next.value);
          case $ResultError():
            sub._notifyError(next.error, next.stackTrace);
        }
      };

      return transformer;
    });

    return resultSub = ExternalProviderSubscription.fromSub(
      innerSubscription: sub,
      listener: listener,
      onError: onError,
      read: () => t.requireState.state.requireState,
    );
  }

  ProviderTransformer<InT, OutT> transform(
    ProviderTransformerContext<InT, OutT> context,
  );
}
