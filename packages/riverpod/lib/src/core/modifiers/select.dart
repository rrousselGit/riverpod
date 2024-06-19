part of '../../framework.dart';

extension on Node {
  bool get weak => this is WeakNode;
}

/// An abstraction of both [ProviderContainer] and [$ProviderElement] used by
/// [ProviderListenable].
sealed class Node {
  /// Starts listening to this transformer
  ProviderSubscription<StateT> listen<StateT>(
    ProviderListenable<StateT> listenable,
    void Function(StateT? previous, StateT next) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required bool fireImmediately,
  });

  /// Obtain the [ProviderElement] of a provider, creating it if necessary.
  @internal
  ProviderElement<StateT> readProviderElement<StateT>(
    ProviderBase<StateT> provider,
  );
}

sealed class WrappedNode implements Node {
  @override
  ProviderSubscription<StateT> listen<StateT>(
    ProviderListenable<StateT> listenable,
    void Function(StateT? previous, StateT next) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required bool fireImmediately,
    bool weak = false,
  });
}

@internal
final class WeakNode implements Node {
  WeakNode(this.inner);
  final WrappedNode inner;

  @override
  ProviderSubscription<StateT> listen<StateT>(
    ProviderListenable<StateT> listenable,
    void Function(StateT? previous, StateT next) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required bool fireImmediately,
  }) {
    return inner.listen(
      listenable,
      listener,
      onError: onError,
      weak: true,
      fireImmediately: fireImmediately,
    );
  }

  @override
  ProviderElement<StateT> readProviderElement<StateT>(
    ProviderBase<StateT> provider,
  ) {
    return inner.readProviderElement(provider);
  }
}

var _debugIsRunningSelector = false;

/// An internal class for `ProviderBase.select`.
@sealed
class _ProviderSelector<InputT, OutputT> with ProviderListenable<OutputT> {
  /// An internal class for `ProviderBase.select`.
  _ProviderSelector({
    required this.provider,
    required this.selector,
  });

  /// The provider that was selected
  final ProviderListenable<InputT> provider;

  /// The selector applied
  final OutputT Function(InputT) selector;

  Result<OutputT> _select(Result<InputT> value) {
    if (kDebugMode) _debugIsRunningSelector = true;

    try {
      return switch (value) {
        ResultData(:final state) => Result.data(selector(state)),
        ResultError(:final error, :final stackTrace) =>
          Result.error(error, stackTrace),
      };
    } catch (err, stack) {
      return Result.error(err, stack);
    } finally {
      if (kDebugMode) _debugIsRunningSelector = false;
    }
  }

  void _selectOnChange({
    required InputT newState,
    required Result<OutputT>? lastSelectedValue,
    required void Function(Object error, StackTrace stackTrace) onError,
    required void Function(OutputT? prev, OutputT next) listener,
    required void Function(Result<OutputT> newState) onChange,
  }) {
    final newSelectedValue = _select(Result.data(newState));
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
  _SelectorSubscription<InputT, OutputT> addListener(
    Node node,
    void Function(OutputT? previous, OutputT next) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
  }) {
    onError ??= Zone.current.handleUncaughtError;

    Result<OutputT>? lastSelectedValue;
    final sub = node.listen<InputT>(
      provider,
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
      onError: onError,
    );

    if (!node.weak) lastSelectedValue = _select(Result.guard(sub.read));

    if (fireImmediately) {
      _handleFireImmediately(
        lastSelectedValue!,
        listener: listener,
        onError: onError,
      );
    }

    return _SelectorSubscription(
      node,
      sub,
      () {
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

  @override
  OutputT read(Node node) {
    final input = provider.read(node);

    return _select(Result.data(input)).requireState;
  }
}

final class _SelectorSubscription<Input, Output>
    extends ProviderSubscription<Output> {
  _SelectorSubscription(
    super.source,
    this._internalSub,
    this._read, {
    this.onClose,
  });

  final ProviderSubscription<Input> _internalSub;
  final Output Function() _read;
  final void Function()? onClose;

  @override
  void close() {
    if (!closed) {
      onClose?.call();
      _internalSub.close();
    }
    super.close();
  }

  @override
  Output read() {
    if (closed) {
      throw StateError(
        'called ProviderSubscription.read on a subscription that was closed',
      );
    }
    // flushes the provider
    _internalSub.read();

    return _read();
  }

  @override
  void pause() => _internalSub.pause();

  @override
  void resume() => _internalSub.resume();
}
