part of '../framework.dart';

/// An internal class for `ProviderBase.select`.
@sealed
class _ProviderSelector<Input, Output> implements ProviderListenable<Output> {
  /// An internal class for `ProviderBase.select`.
  _ProviderSelector({
    required this.provider,
    required this.selector,
  });

  /// The provider that was selected
  final ProviderBase<Input> provider;

  /// The selector applied
  final Output Function(Input) selector;

  Result<Output> _select(Result<Input> value) {
    assert(() {
      _debugIsRunningSelector = true;
      return true;
    }(), '');

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
      assert(() {
        _debugIsRunningSelector = false;
        return true;
      }(), '');
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
            // TOOD test from error
            lastSelectedValue.stateOrNull,
            data.state,
          );
        },
        error: (error) => onError(error.error, error.stackTrace),
      );
    }
  }

  _SelectorSubscription<Input, Output> listen(
    ProviderContainer container,
    void Function(Output? previous, Output next) listener, {
    required bool fireImmediately,
    required void Function(Object error, StackTrace stackTrace)? onError,
  }) {
    onError ??= _fallbackOnErrorForProvider(provider);

    final selectedElement = container.readProviderElement(provider);
    var lastSelectedValue = _select(selectedElement.getState()!);

    if (fireImmediately) {
      handleFireImmediately(
        lastSelectedValue,
        listener: listener,
        onError: onError,
      );
    }

    final sub = container.listen<Input>(
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

    return _SelectorSubscription(
      sub,
      () {
        return lastSelectedValue.map(
          data: (data) => data.state,
          error: (error) => throw ProviderException._(
            error.error,
            error.stackTrace,
            provider,
          ),
        );
      },
    );
  }

  void Function() _elementListen(
    ProviderElementBase element,
    void Function(Output? prev, Output next) listener, {
    required bool fireImmediately,
    required void Function(Object error, StackTrace stackTrace)? onError,
  }) {
    onError ??= _fallbackOnErrorForProvider(provider);

    final selectedElement = element._container.readProviderElement(provider);
    var lastSelectedValue = _select(selectedElement.getState()!);

    if (fireImmediately) {
      handleFireImmediately(
        lastSelectedValue,
        listener: listener,
        onError: onError,
      );
    }

    return element.listen<Input>(
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
