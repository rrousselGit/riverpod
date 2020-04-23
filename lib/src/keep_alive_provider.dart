part of 'framework.dart';

abstract class KeepAliveProvider<Res> extends BaseProvider<Res> {
  KeepAliveProvider(this._keptAliveProvider);

  final BaseProvider<Res> _keptAliveProvider;

  @override
  Iterable<BaseProvider<Object>> _allDependencies() {
    return _keptAliveProvider._allDependencies();
  }

  @override
  _KeepAliveState<Res> createState() {
    return _KeepAliveState<Res>();
  }
}

class _KeepAliveState<Res>
    extends BaseProviderState<Res, KeepAliveProvider<Res>> {
  List<BaseProviderState<Object, BaseProvider<Object>>> _dependenciesState;
  BaseProviderState<Res, BaseProvider<Res>> _providerState;
  VoidCallback _removeProviderListener;

  @override
  void _initDependencies(
    List<BaseProviderState<Object, BaseProvider<Object>>> dependenciesState,
  ) {
    super._initDependencies(dependenciesState);
    _dependenciesState = dependenciesState;

    _createProxyState();
  }

  @override
  Res initState() {
    return _providerState.initState();
  }

  void _createProxyState() {
    _providerState = BaseProvider._createProviderState(
      provider._keptAliveProvider,
      _dependenciesState,
    );

    _removeProviderListener = _providerState.addListener((value) {
      state = value;
    }, fireImmediately: false);
  }

  @override
  RemoveListener addListener(
    void Function(Res) listener, {
    bool fireImmediately = true,
  }) {
    if (_providerState == null) {
      _createProxyState();
      state = _providerState.initState();
    }

    final superRemoveListener = super.addListener(
      listener,
      fireImmediately: fireImmediately,
    );

    return () {
      superRemoveListener();
      if (!hasListeners) {
        _removeProviderListener();
        _removeProviderListener = null;
        _providerState.dispose();
        _providerState = null;
      }
    };
  }

  @override
  void didUpdateProvider(KeepAliveProvider<Res> oldProvider) {
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
}
