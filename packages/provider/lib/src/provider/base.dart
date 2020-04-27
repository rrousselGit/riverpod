part of 'provider.dart';

mixin _ProviderMixin<T> implements Provider<T> {
  @override
  T readOwner(ProviderStateOwner owner) {
    final state = owner.readProviderState(this);
    return state.value;
  }
}

class _ProviderCreate<T> extends BaseProvider<ProviderValue<T>, T>
    with _ProviderMixin<T> {
  _ProviderCreate(this._create);

  final Create<T, ProviderState> _create;

  @override
  _ProviderCreateState<T> createState() => _ProviderCreateState();
}

mixin _ProviderStateMixin<T, P extends BaseProvider<ProviderValue<T>, T>>
    on BaseProviderState<ProviderValue<T>, T, P> {
  @override
  T combiningValueAsListenedValue(ProviderValue<T> value) {
    return value._value;
  }
}

class _ProviderCreateState<T>
    extends BaseProviderState<ProviderValue<T>, T, _ProviderCreate<T>>
    with _ProviderStateMixin<T, _ProviderCreate<T>> {
  @override
  ProviderValue<T> initState() => ProviderValue(provider._create(this));
}
