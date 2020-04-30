part of 'framework.dart';

abstract class KeepAliveProvider<CombiningValue extends BaseProviderValue,
    ListeningValue> extends BaseProvider<CombiningValue, ListeningValue> {
  KeepAliveProvider(this._keptAliveProvider);

  final BaseProvider<CombiningValue, ListeningValue> _keptAliveProvider;

  @override
  Iterable<BaseProvider<BaseProviderValue, Object>> _allDependencies() {
    return _keptAliveProvider._allDependencies();
  }

  @override
  _KeepAliveState<CombiningValue, ListeningValue> createState() {
    return _KeepAliveState<CombiningValue, ListeningValue>();
  }
}

class _KeepAliveState<CombiningValue extends BaseProviderValue, ListeningValue>
    extends BaseProviderState<CombiningValue, ListeningValue,
        KeepAliveProvider<CombiningValue, ListeningValue>> {
  List<
      BaseProviderState<BaseProviderValue, Object,
          BaseProvider<BaseProviderValue, Object>>> _dependenciesState;
  BaseProviderState<CombiningValue, ListeningValue,
      BaseProvider<CombiningValue, ListeningValue>> _providerState;
  VoidCallback _removeProviderListener;

  @override
  void _initDependencies(
    List<
            BaseProviderState<BaseProviderValue, Object,
                BaseProvider<BaseProviderValue, Object>>>
        dependenciesState,
  ) {
    super._initDependencies(dependenciesState);
    _dependenciesState = dependenciesState;

    _createProxyState();
  }

  @override
  ListeningValue initState() {
    return _providerState.initState();
  }

  void _createProxyState() {
    _providerState = _owner._createProviderState(
      provider._keptAliveProvider,
      _dependenciesState,
    );

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
  CombiningValue createProviderState() {
    return _providerState.createProviderState();
  }
}
