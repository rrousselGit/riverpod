part of '../../framework.dart';

/// An internal class for `ProviderBase.select`.
final class _ProviderSelector<InputT, OutputT, OriginStateT, OriginValueT>
    with
        ProviderListenable<OutputT>,
        ProviderListenableWithOrigin<OutputT, OriginStateT, OriginValueT> {
  /// An internal class for `ProviderBase.select`.
  _ProviderSelector({
    required this.provider,
    required this.selector,
  });

  /// The provider that was selected
  final ProviderListenableWithOrigin<InputT, OriginStateT, OriginValueT>
      provider;

  /// The selector applied
  final OutputT Function(InputT) selector;

  $Result<OutputT> _select($Result<InputT> value) {
    if (kDebugMode) _debugCallbackStack++;

    try {
      return switch (value) {
        $ResultData(:final value) => $Result.data(selector(value)),
        $ResultError(:final error, :final stackTrace) =>
          $Result.error(error, stackTrace),
      };
    } catch (err, stack) {
      return $Result.error(err, stack);
    } finally {
      if (kDebugMode) _debugCallbackStack--;
    }
  }

  void _selectOnChange({
    required InputT newState,
    required $Result<OutputT>? lastSelectedValue,
    required void Function(Object error, StackTrace stackTrace) onError,
    required void Function(OutputT? prev, OutputT next) listener,
    required void Function($Result<OutputT> newState) onChange,
  }) {
    final newSelectedValue = _select($Result.data(newState));
    if (lastSelectedValue == null ||
        !lastSelectedValue.hasData ||
        !newSelectedValue.hasData ||
        lastSelectedValue.requireState != newSelectedValue.requireState) {
      onChange(newSelectedValue);
      switch (newSelectedValue) {
        case $ResultData(:final value):
          listener(lastSelectedValue?.value, value);
        case $ResultError(:final error, :final stackTrace):
          onError(error, stackTrace);
      }
    }
  }

  @override
  ProviderSubscriptionWithOrigin<OutputT, OriginStateT, OriginValueT>
      _addListener(
    Node node,
    void Function(OutputT? previous, OutputT next) listener, {
    required void Function(Object error, StackTrace stackTrace) onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
    required bool weak,
  }) {
    late final ProviderSubscriptionView<OutputT, OriginStateT, OriginValueT>
        providerSub;
    $Result<OutputT>? lastSelectedValue;
    final sub = provider._addListener(
      node,
      (prev, input) {
        _selectOnChange(
          newState: input,
          lastSelectedValue: lastSelectedValue,
          listener: providerSub._notifyData,
          onError: providerSub._notifyError,
          onChange: (newState) => lastSelectedValue = newState,
        );
      },
      fireImmediately: false,
      weak: weak,
      onDependencyMayHaveChanged: onDependencyMayHaveChanged,
      onError: onError,
    );

    if (!weak) {
      lastSelectedValue = _select(
        $Result.guard(() {
          try {
            return sub.read();
          } catch (e, s) {
            e as ProviderException;
            e.unwrap(s);
          }
        }),
      );
    }

    providerSub = ProviderSubscriptionView<OutputT, OriginStateT, OriginValueT>(
      innerSubscription: sub,
      listener: listener,
      onError: onError,
      read: () {
        // flushes the provider
        sub.read();

        // Using ! because since `sub.read` flushes the inner subscription,
        // it is guaranteed that `lastSelectedValue` is not null.
        return lastSelectedValue!.requireState;
      },
    );

    if (fireImmediately) {
      _handleFireImmediately(
        node.container,
        lastSelectedValue!,
        listener: providerSub._notifyData,
        onError: providerSub._notifyError,
      );
    }

    return providerSub;
  }
}
