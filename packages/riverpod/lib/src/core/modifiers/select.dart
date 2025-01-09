part of '../../framework.dart';

/// An abstraction of both [ProviderContainer] and [$ProviderElement] used by
/// [ProviderListenable].
sealed class Node {
  // /// Starts listening to this transformer
  // ProviderSubscription<StateT> listen<StateT>(
  //   ProviderListenable<StateT> listenable,
  //   void Function(StateT? previous, StateT next) listener, {
  //   required void Function(Object error, StackTrace stackTrace)? onError,
  //   required bool fireImmediately,
  //   required bool weak,
  // });

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
        ResultData(:final state) => $Result.data(selector(state)),
        ResultError(:final error, :final stackTrace) =>
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
        !lastSelectedValue.hasState ||
        !newSelectedValue.hasState ||
        lastSelectedValue.requireState != newSelectedValue.requireState) {
      onChange(newSelectedValue);
      switch (newSelectedValue) {
        case ResultData(:final state):
          listener(
            lastSelectedValue?.stateOrNull,
            state,
          );
        case ResultError(:final error, :final stackTrace):
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

    $Result<OutputT>? lastSelectedValue;
    final sub = provider.addListener(
      node,
      (prev, input) {
        _selectOnChange(
          newState: input,
          lastSelectedValue: lastSelectedValue,
          listener: listener,
          onError: onError!,
          onChange: (newState) => lastSelectedValue = newState,
        );
      },
      fireImmediately: false,
      weak: weak,
      onDependencyMayHaveChanged: onDependencyMayHaveChanged,
      onError: onError,
    );

    if (!weak) lastSelectedValue = _select($Result.guard(sub.read));

    if (fireImmediately) {
      _handleFireImmediately(
        lastSelectedValue!,
        listener: listener,
        onError: onError,
      );
    }

    return ProviderSubscriptionView<OutputT, OriginT>(
      innerSubscription: sub,
      read: () {
        // flushes the provider
        sub.read();

        // Using ! because since `sub.read` flushes the inner subscription,
        // it is guaranteed that `lastSelectedValue` is not null.
        return switch (lastSelectedValue!) {
          ResultData(:final state) => state,
          ResultError(:final error, :final stackTrace) =>
            throwErrorWithCombinedStackTrace(
              error,
              stackTrace,
            ),
        };
      },
    );
  }
}
