part of '../../framework.dart';

/// An abstraction of both [ProviderContainer] and [$ProviderElement] used by
/// [ProviderListenable].
@internal
abstract class Node {
  /// Starts listening to this transformer
  ProviderSubscription<StateT> listen<StateT>(
    ProviderListenable<StateT> listenable,
    void Function(StateT? previous, StateT next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
    bool fireImmediately = false,
  });

  /// Reads the state of a provider, potentially creating it in the process.
  ///
  /// It may throw if the provider requested threw when it was built.
  ///
  /// Do not use this in production code. This is exposed only for testing
  /// and devtools, to be able to test if a provider has listeners or similar.
  ProviderElementBase<StateT> readProviderElement<StateT>(
    ProviderBase<StateT> provider,
  );

  /// Subscribes to a [ProviderElementBase].
  ProviderSubscription<StateT> _listenElement<StateT>(
    ProviderElementBase<StateT> element, {
    required void Function(StateT? previous, StateT next) listener,
    required void Function(Object error, StackTrace stackTrace) onError,
  });
}

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
      return value.map(
        data: (data) => Result.data(selector(data.state)),
        // TODO test
        error: (error) => Result.error(error.error, error.stackTrace),
      );
    } catch (err, stack) {
      // TODO test
      return Result.error(err, stack);
    } finally {
      if (kDebugMode) _debugIsRunningSelector = false;
    }
  }

  void _selectOnChange({
    required InputT newState,
    required Result<OutputT> lastSelectedValue,
    required void Function(Object error, StackTrace stackTrace) onError,
    required void Function(OutputT? prev, OutputT next) listener,
    required void Function(Result<OutputT> newState) onChange,
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
  _SelectorSubscription<InputT, OutputT> addListener(
    Node node,
    void Function(OutputT? previous, OutputT next) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
  }) {
    onError ??= Zone.current.handleUncaughtError;

    late Result<OutputT> lastSelectedValue;

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
      onError: onError,
    );

    lastSelectedValue = _select(Result.guard(sub.read));

    if (fireImmediately) {
      _handleFireImmediately(
        lastSelectedValue,
        listener: listener,
        onError: onError,
      );
    }

    return _SelectorSubscription(
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
  OutputT read(Node node) {
    final input = provider.read(node);

    return _select(Result.data(input)).requireState;
  }
}

class _SelectorSubscription<Input, Output>
    implements ProviderSubscription<Output> {
  _SelectorSubscription(this._internalSub, this._read);

  final ProviderSubscription<Input> _internalSub;
  final Output Function() _read;
  var _closed = false;

  @override
  void close() {
    _closed = true;
    _internalSub.close();
  }

  @override
  Output read() {
    if (_closed) {
      throw StateError(
        'called ProviderSubscription.read on a subscription that was closed',
      );
    }
    // flushes the provider
    _internalSub.read();

    return _read();
  }
}
