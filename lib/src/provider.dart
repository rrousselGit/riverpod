import 'framework.dart';

abstract class Provider<T> extends InheritedProvider<T> {
  factory Provider.value(T value) = _ProviderValue<T>;
}

class _ProviderValue<T> extends InheritedProvider<T> implements Provider<T> {
  _ProviderValue(this._value);

  final T _value;

  @override
  _ProviderValueState<T> createState() => _ProviderValueState(_value);
}

class _ProviderValueState<Res>
    extends InheritedProviderState<Res, _ProviderValue<Res>> {
  _ProviderValueState(Res state) : super(state);

  @override
  void initState() {
    super.initState();
    state = provider._value;
  }

  @override
  void didUpdateProvider(_ProviderValue<Res> oldProvider) {
    super.didUpdateProvider(oldProvider);
    state = provider._value;
  }
}
