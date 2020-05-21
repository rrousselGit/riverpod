import 'common.dart';
import 'framework/framework.dart';

class SetStateProviderReference<T> extends ProviderReference {
  SetStateProviderReference._(this._providerState) : super(_providerState);

  final _SetStateProviderState<T> _providerState;

  T get state => _providerState.state;
  set state(T newState) => _providerState.state = newState;
}

class SetStateProvider<T>
    extends AlwaysAliveProvider<ProviderBaseSubscription, T> {
  SetStateProvider(this._create);

  final Create<T, SetStateProviderReference<T>> _create;

  @override
  _SetStateProviderState<T> createState() {
    return _SetStateProviderState<T>();
  }
}

class _SetStateProviderState<T> extends ProviderBaseState<
    ProviderBaseSubscription, T, SetStateProvider<T>> {
  T _state;
  @override
  T get state => _state;
  set state(T state) {
    _state = state;
    markNeedsNotifyListeners();
  }

  @override
  void initState() {
    _state = provider._create(SetStateProviderReference._(this));
  }

  @override
  ProviderBaseSubscription createProviderSubscription() {
    return ProviderBaseSubscriptionImpl();
  }
}
