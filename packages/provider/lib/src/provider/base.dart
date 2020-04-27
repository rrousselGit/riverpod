part of 'provider.dart';

mixin _ProviderMixin<T> implements Provider<T> {
  @override
  T readOwner(ProviderStateOwner owner) {
    final state = owner.readProviderState(this);
    return state.value;
  }
}

class _ProviderCreate<T> extends BaseProvider<ProviderValue<T>>
    with _ProviderMixin<T> {
  _ProviderCreate(this._create);

  final Create<T, ProviderState> _create;

  @override
  _ProviderCreateState<T> createState() => _ProviderCreateState();
}

class _ProviderCreateState<Res>
    extends BaseProviderState<ProviderValue<Res>, _ProviderCreate<Res>> {
  @override
  ProviderValue<Res> initState() => ProviderValue(provider._create(this));
}
