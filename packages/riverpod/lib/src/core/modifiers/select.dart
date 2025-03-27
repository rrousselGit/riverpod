part of '../../framework.dart';

/// An abstraction of both [ProviderContainer] and [ProviderElement] used by
/// [ProviderListenable].
@internal
abstract class Node {
  /// Starts listening to a listenable
  ProviderSubscription<State> listen<State>(
    ProviderListenable<State> listenable,
    void Function(State? previous, State next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
    bool fireImmediately = false,
  });

  /// Reads the state of a provider, potentially creating it in the process.
  ///
  /// It may throw if the provider requested threw when it was built.
  ///
  /// Do not use this in production code. This is exposed only for testing
  /// and devtools, to be able to test if a provider has listeners or similar.
  ProviderElementBase<State> readProviderElement<State>(
    AnyProvider<State> provider,
  );
}

/// An internal class for `ProviderBase.select`.
@sealed
class _ProviderSelector<Input, Output> with ProviderListenable<Output> {
  /// An internal class for `ProviderBase.select`.
  _ProviderSelector({
    required this.provider,
    required this.selector,
  });

  /// The provider that was selected
  final ProviderListenable<Input> provider;

  /// The selector applied
  final Output Function(Input) selector;

  Result<Output> _select(Result<Input> value) {
    assert(
      () {
        _debugIsRunningSelector = true;
        return true;
      }(),
      '',
    );

    try {
      return switch (value) {
        ResultData<Input>() => Result.data(selector(value.value)),
        // TODO test
        ResultError<Input>() => Result.error(value.error, value.stackTrace),
      };
    } catch (err, stack) {
      // TODO test
      return Result.error(err, stack);
    } finally {
      assert(
        () {
          _debugIsRunningSelector = false;
          return true;
        }(),
        '',
      );
    }
  }

  void _selectOnChange({
    required Input newState,
    required Result<Output> lastSelectedValue,
    required void Function(Object error, StackTrace stackTrace) onError,
    required void Function(Output? prev, Output next) listener,
    required void Function(Result<Output> newState) onChange,
  }) {
    final newSelectedValue = _select(Result.data(newState));
    if (!lastSelectedValue.hasData ||
        !newSelectedValue.hasData ||
        lastSelectedValue.requireState != newSelectedValue.requireState) {
      // TODO test events after selector exception correctly send `previous`s

      onChange(newSelectedValue);
      // TODO test handle exception in listener
      switch (newSelectedValue) {
        case ResultData<Output>():
          listener(
            // TODO test from error
            lastSelectedValue.value,
            newSelectedValue.value,
          );
        case ResultError<Output>():
          onError(newSelectedValue.error, newSelectedValue.stackTrace);
      }
    }
  }

  @override
  _SelectorSubscription<Input, Output> _addListener(
    Node node,
    void Function(Output? previous, Output next) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
  }) {
    onError ??= Zone.current.handleUncaughtError;

    late Result<Output> lastSelectedValue;

    final sub = node.listen<Input>(
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
      onError: onError,
    );

    lastSelectedValue = _select(Result.guard(sub.read));

    if (fireImmediately) {
      handleFireImmediately(
        lastSelectedValue,
        listener: listener,
        onError: onError,
      );
    }

    return _SelectorSubscription(
      node,
      sub,
      () {
        return switch (lastSelectedValue) {
          ResultData(:final value) => value,
          ResultError(:final error, :final stackTrace) =>
            throwErrorWithCombinedStackTrace(error, stackTrace),
        };
      },
    );
  }

  @override
  Output read(Node node) {
    final input = provider.read(node);
    return selector(input);
  }
}

class _SelectorSubscription<Input, Output>
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
}

class _AlwaysAliveProviderSelector<Input, Output>
    extends _ProviderSelector<Input, Output>
    with
        // ignore: deprecated_member_use_from_same_package
        AlwaysAliveProviderListenable<Output> {
  /// An internal class for `ProviderBase.select`.
  _AlwaysAliveProviderSelector({
    required super.provider,
    required super.selector,
  });
}
