part of 'provider.dart';

mixin _ProviderMixin<T> implements Provider<T> {
  @override
  T readOwner(ProviderStateOwner owner) {
    final state = owner.readProviderState(this);
    return state.$state;
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
    implements BaseProviderState<ProviderValue<T>, T, P> {
  @override
  ProviderValue<T> createProviderState() {
    return ProviderValue._($state, this);
  }
}

class _ProviderCreateState<T>
    extends BaseProviderState<ProviderValue<T>, T, _ProviderCreate<T>>
    with _ProviderStateMixin<T, _ProviderCreate<T>> {
  @override
  T initState() {
    return provider._create(ProviderState(this));
  }
}
