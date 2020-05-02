import 'common.dart';
import 'framework/framework.dart';

class ProviderValue<T> extends BaseProviderValue {
  ProviderValue._(this.value);

  final T value;
}

class Provider<T> extends AlwaysAliveProvider<ProviderValue<T>, T> {
  Provider(this._create);

  final Create<T, ProviderState> _create;

  @override
  _ProviderCreateState<T> createState() => _ProviderCreateState();
}

class _ProviderCreateState<T>
    extends BaseProviderState<ProviderValue<T>, T, Provider<T>> {
  @override
  T initState() {
    return provider._create(ProviderState(this));
  }

  @override
  ProviderValue<T> createProviderState() {
    return ProviderValue._($state);
  }
}
