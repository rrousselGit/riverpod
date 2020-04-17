import 'framework.dart';

abstract class Provider<T> extends BaseProvider<T> {
  factory Provider(T Function() create) = _ProviderCreate<T>;
  factory Provider.value(T value) = _ProviderValue<T>;
}

class _ProviderCreate<T> extends BaseProvider<T> implements Provider<T> {
  _ProviderCreate(this._create);

  final T Function() _create;

  @override
  _ProviderCreateState<T> createState() => _ProviderCreateState();
}

class _ProviderCreateState<Res>
    extends BaseProviderState<Res, _ProviderCreate<Res>> {
  @override
  Res initState() {
    return provider._create();
  }
}

class _ProviderValue<T> extends BaseProvider<T> implements Provider<T> {
  _ProviderValue(this._value);

  final T _value;

  @override
  _ProviderValueState<T> createState() => _ProviderValueState();
}

class _ProviderValueState<Res>
    extends BaseProviderState<Res, _ProviderValue<Res>> {
  @override
  Res initState() {
    return provider._value;
  }

  @override
  void didUpdateProvider(_ProviderValue<Res> oldProvider) {
    super.didUpdateProvider(oldProvider);
    state = provider._value;
  }
}
