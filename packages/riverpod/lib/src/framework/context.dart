import '../common.dart';
import 'framework.dart';

class ProviderContext {
  ProviderContext(this._providerState);

  final ProviderBaseState _providerState;

  bool get mounted => _providerState.mounted;

  void onDispose(VoidCallback cb) {
    assert(
      mounted,
      '`onDispose` was called on a state that is already disposed',
    );
    _providerState.onDispose(cb);
  }

  T dependOn<T extends ProviderBaseSubscription>(
      ProviderBase<T, Object> provider) {
    assert(
      mounted,
      '`dependOn` was called on a state that is already disposed',
    );
    return _providerState.dependOn(provider);
  }

  // TODO report error?
}
