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
    void Function(Output) listener, {
    required bool fireImmediately,
  }) {
    var lastSelectedValue = _select(container.read(provider));

    if (fireImmediately) {
      _runUnaryGuarded(listener, lastSelectedValue);
    }

    final sub = container.listen<Input>(provider, (value) {
      final newSelectedValue = _select(value);
      if (newSelectedValue != lastSelectedValue) {
        lastSelectedValue = newSelectedValue;
        listener(lastSelectedValue);
      }
    });

    return _SelectorSubscription(sub, () => lastSelectedValue);
  }

  Output _select(Input value) {
    assert(() {
      _debugIsRunningSelector = true;
      return true;
    }(), '');

    try {
      return selector(value);
    } finally {
      assert(() {
        _debugIsRunningSelector = false;
        return true;
      }(), '');
    }
  }

  void Function() _elementListen(
    ProviderElementBase element,
    void Function(Output) listener, {
    required bool fireImmediately,
  }) {
    var lastValue = _select(element._container.read(provider));
    if (fireImmediately) listener(lastValue);

    return element.listen<Input>(provider, (input) {
      final newValue = _select(input);
      if (lastValue != newValue) {
        lastValue = newValue;
        listener(newValue);
      }
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
