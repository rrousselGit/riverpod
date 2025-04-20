part of '../../framework.dart';

/// An abstraction of both [ProviderContainer] and [$ProviderElement] used by
/// [ProviderListenable].
sealed class Node {
  /// Obtain the [ProviderElement] of a provider, creating it if necessary.
  @internal
  ProviderElement<StateT> readProviderElement<StateT>(
    ProviderBase<StateT> provider,
  );
}

var _debugIsRunningSelector = false;

/// An internal class for `ProviderBase.select`.
@sealed
class _ProviderSelector<InputT, OutputT, OriginT>
    with
        ProviderListenable<OutputT>,
        ProviderListenableWithOrigin<OutputT, OriginT> {
  /// An internal class for `ProviderBase.select`.
  _ProviderSelector({
    required this.provider,
    required this.selector,
  });

  /// The provider that was selected
  final ProviderListenableWithOrigin<InputT, OriginT> provider;

  /// The selector applied
  final OutputT Function(InputT) selector;

  $Result<OutputT> _select($Result<InputT> value) {
    if (kDebugMode) _debugIsRunningSelector = true;

    try {
      return switch (value) {
        $ResultData(:final value) => $Result.data(selector(value)),
        $ResultError(:final error, :final stackTrace) =>
          $Result.error(error, stackTrace),
      };
    } catch (err, stack) {
      return $Result.error(err, stack);
    } finally {
      if (kDebugMode) _debugIsRunningSelector = false;
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
  ProviderSubscriptionWithOrigin<OutputT, OriginT> addListener(
    Node node,
    void Function(OutputT? previous, OutputT next) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
    required bool weak,
  }) {
    onError ??= Zone.current.handleUncaughtError;

    late final ProviderSubscriptionView<OutputT, OriginT> providerSub;
    $Result<OutputT>? lastSelectedValue;
    final sub = provider.addListener(
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

    if (!weak) lastSelectedValue = _select($Result.guard(sub.read));

    providerSub = ProviderSubscriptionView<OutputT, OriginT>(
      innerSubscription: sub,
      listener: listener,
      onError: onError,
      read: () {
        // flushes the provider
        sub.read();

        // Using ! because since `sub.read` flushes the inner subscription,
        // it is guaranteed that `lastSelectedValue` is not null.
        return switch (lastSelectedValue!) {
          $ResultData(:final value) => value,
          $ResultError(:final error, :final stackTrace) =>
            throwErrorWithCombinedStackTrace(
              error,
              stackTrace,
            ),
        };
      },
    );

    if (fireImmediately) {
      _handleFireImmediately(
        lastSelectedValue!,
        listener: providerSub._notifyData,
        onError: providerSub._notifyError,
      );
    }

    return providerSub;
  }
}
