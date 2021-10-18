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
  }) {
    var lastSelectedValue = _select(container.read(provider));

    if (fireImmediately) {
      _runBinaryGuarded(listener, null, lastSelectedValue);
    }

    final sub = container.listen<Input>(provider, (previous, value) {
      final newSelectedValue = _select(value);
      if (newSelectedValue != lastSelectedValue) {
        final previous = lastSelectedValue;
        lastSelectedValue = newSelectedValue;
        // TODO test events after selector exception correctly send `previous`s
        listener(previous, newSelectedValue);
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
    void Function(Output? prev, Output next) listener, {
    required bool fireImmediately,
  }) {
    var lastSelectedValue = _select(element._container.read(provider));
    if (fireImmediately) listener(null, lastSelectedValue);

    return element.listen<Input>(provider, (prev, input) {
      final newSelectedValue = _select(input);
      if (lastSelectedValue != newSelectedValue) {
        final previous = lastSelectedValue;
        // TODO test events after selector exception correctly send `previous`s

        lastSelectedValue = newSelectedValue;
        listener(previous, newSelectedValue);
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
