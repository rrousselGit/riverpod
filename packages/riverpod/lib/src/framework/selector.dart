part of '../framework.dart';

/// An abstraction of both [ProviderContainer] and [ProviderElement] used by
/// [ProviderListenable].
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
    ProviderBase<State> provider,
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
      return value.map(
        data: (data) => Result.data(selector(data.state)),
        // TODO test
        error: (error) => Result.error(error.error, error.stackTrace),
      );
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
    if (!lastSelectedValue.hasState ||
        !newSelectedValue.hasState ||
        lastSelectedValue.requireState != newSelectedValue.requireState) {
      // TODO test events after selector exception correctly send `previous`s

      onChange(newSelectedValue);
      // TODO test handle exception in listener
      newSelectedValue.map(
        data: (data) {
          listener(
            // TODO test from error
            lastSelectedValue.stateOrNull,
            data.state,
          );
        },
        error: (error) => onError(error.error, error.stackTrace),
      );
    }
  }

  @override
  _SelectorSubscription<Input, Output> addListener(
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
        return lastSelectedValue.map(
          data: (data) => data.state,
          error: (error) => throwErrorWithCombinedStackTrace(
            error.error,
            error.stackTrace,
          ),
        );
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
