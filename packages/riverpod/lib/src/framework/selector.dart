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

  _SelectorSubscription<Input, Output> listen(
    ProviderContainer container,
    void Function(Output? previous, Output next) listener, {
    required bool fireImmediately,
    required void Function(Object error, StackTrace stackTrace)? onError,
  }) {
    final selectedElement = container.readProviderElement(provider);

    var lastSelectedValue = _select(selectedElement.getState()!);

    if (fireImmediately) {
      lastSelectedValue.map(
        data: (data) => _runBinaryGuarded(listener, null, data.state),
        error: (error) {
          if (onError != null) {
            _runBinaryGuarded(onError, error.error, error.stackTrace);
          }
        },
      );
    }

    final sub = container.listen<Input>(provider, (prev, input) {
      final newSelectedValue = _select(Result.data(input));
      if (!lastSelectedValue.hasState ||
          !newSelectedValue.hasState ||
          lastSelectedValue.requireState != newSelectedValue.requireState) {
        final previous = lastSelectedValue;
        // TODO test events after selector exception correctly send `previous`s

        lastSelectedValue = newSelectedValue;
        // TODO test handle exception in listener
        lastSelectedValue.map(
          data: (data) {
            listener(
              // TOOD test from error
              previous.stateOrNull,
              data.state,
            );
          },
          error: (error) => onError?.call(error.error, error.stackTrace),
        );
      }
    }, onError: (err, stack) {
      // TODO
    });

    return _SelectorSubscription(
      sub,
      // TODO test rethrow error
      () => lastSelectedValue.requireState,
    );
  }

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

  void Function() _elementListen(
    ProviderElementBase element,
    void Function(Output? prev, Output next) listener, {
    required bool fireImmediately,
    required void Function(Object error, StackTrace stackTrace)? onError,
  }) {
    final selectedElement = element._container.readProviderElement(provider);

    var lastSelectedValue = _select(selectedElement.getState()!);

    if (fireImmediately) {
      lastSelectedValue.map(
        data: (data) => listener(null, data.state),
        error: (error) {
          if (onError != null) {
            _runBinaryGuarded(onError, error.error, error.stackTrace);
          }
        },
      );
    }

    return element.listen<Input>(provider, (prev, input) {
      final newSelectedValue = _select(Result.data(input));
      if (!lastSelectedValue.hasState ||
          !newSelectedValue.hasState ||
          lastSelectedValue.requireState != newSelectedValue.requireState) {
        final previous = lastSelectedValue;
        // TODO test events after selector exception correctly send `previous`s

        lastSelectedValue = newSelectedValue;
        // TODO test handle exception in listener
        lastSelectedValue.map(
          data: (data) {
            listener(
              // TOOD test from error
              previous.stateOrNull,
              data.state,
            );
          },
          error: (error) => onError?.call(error.error, error.stackTrace),
        );
      }
    }, onError: (err, stack) {
      // TODO
    });
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
    return _read();
  }
}
