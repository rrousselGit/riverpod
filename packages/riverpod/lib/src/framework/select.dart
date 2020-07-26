import 'package:meta/meta.dart';

import '../framework.dart';

/// A [ProviderSubscription] for `ProviderBase.select`, that calls `onChange`
/// only when the value computed changes.
class SelectorSubscription<Input, Output>
    implements ProviderSubscription<Output> {
  SelectorSubscription({
    @required ProviderContainer container,
    @required Output Function(Input) selector,
    @required ProviderBase<Object, Input> provider,
    void Function(SelectorSubscription<Input, Output> sub) mayHaveChanged,
    void Function(SelectorSubscription<Input, Output> sub) didChange,
  })  : _selector = selector,
        _didChange = didChange {
    _sub = container.listen(
      provider,
      mayHaveChanged: (_) => mayHaveChanged(this),
    );
  }

  final void Function(SelectorSubscription<Input, Output> sub) _didChange;
  bool _isFirstBuild = true;
  ProviderSubscription<Input> _sub;
  Output _lastOutput;
  Output Function(Input) _selector;

  void updateSelector(ProviderListenable<Output> providerListenable) {
    _selector =
        (providerListenable as ProviderSelector<Input, Output>).selector;
    _lastOutput = _selector(_sub.read());
  }

  @override
  bool flush() {
    if (_sub.flush()) {
      final newOutput = _selector(_sub.read());
      if (_isFirstBuild || _lastOutput != newOutput) {
        _lastOutput = newOutput;
        if (!_isFirstBuild) {
          _didChange?.call(this);
        }
        _isFirstBuild = false;
        return true;
      }
    }
    return false;
  }

  @override
  void close() => _sub.close();

  @override
  Output read() {
    flush();
    return _lastOutput;
  }
}
