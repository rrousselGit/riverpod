part of 'framework.dart';

abstract class KeepAliveProvider<
    CombiningValue extends ProviderBaseSubscription,
    ListeningValue> extends ProviderBase<CombiningValue, ListeningValue> {
  KeepAliveProvider(this._keptAliveProvider);

  final ProviderBase<CombiningValue, ListeningValue> _keptAliveProvider;

  @override
  _KeepAliveState<CombiningValue, ListeningValue> createState() {
    return _KeepAliveState<CombiningValue, ListeningValue>();
  }
}

class _KeepAliveState<CombiningValue extends ProviderBaseSubscription,
        ListeningValue>
    extends ProviderBaseState<CombiningValue, ListeningValue,
        KeepAliveProvider<CombiningValue, ListeningValue>> {
  ProviderBaseState<CombiningValue, ListeningValue,
      ProviderBase<CombiningValue, ListeningValue>> _providerState;
  VoidCallback _removeProviderListener;

  @override
  ListeningValue initState() {
    _createProxyState();
    return _providerState.initState();
  }

  void _createProxyState() {
    _providerState = _owner._createProviderState(provider._keptAliveProvider);

    _removeProviderListener = _providerState.$addStateListener((value) {
      $state = value;
    }, fireImmediately: false);
  }

  @override
  VoidCallback $addStateListener(
    void Function(ListeningValue) listener, {
    bool fireImmediately = true,
  }) {
    if (_providerState == null) {
      _createProxyState();
      $state = _providerState.initState();
    }

    final superRemoveListener = super.$addStateListener(
      listener,
      fireImmediately: fireImmediately,
    );

    return () {
      superRemoveListener();
      if (!$hasListeners) {
        _removeProviderListener();
        _removeProviderListener = null;
        _providerState.dispose();
        _providerState = null;
      }
    };
  }

  @override
  void didUpdateProvider(
      KeepAliveProvider<CombiningValue, ListeningValue> oldProvider) {
    super.didUpdateProvider(oldProvider);
    if (oldProvider._keptAliveProvider != provider._keptAliveProvider) {
      throw UnsupportedError(
        'Cannot rebuild a provider that uses "kept alive".',
      );
    }
  }

  @override
  void dispose() {
    _removeProviderListener?.call();
    _providerState?.dispose();
    super.dispose();
  }

  @override
  CombiningValue createProviderSubscription() {
    return _providerState.createProviderSubscription();
  }
}
