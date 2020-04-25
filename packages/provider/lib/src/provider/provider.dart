import '../combiner.dart';
import '../common.dart';
import '../framework/framework.dart';

part 'provider1.dart';

mixin _Noop {}

class ProviderBuilder<Res> = Combiner<Res, Provider> with _Noop;

class ProviderValue<T> {
  const ProviderValue(this._value);
  final T _value;
}

extension ProviderX<T> on ProviderListenerState<ProviderValue<T>> {
  T get value => $state._value;
}

abstract class Provider<T> extends BaseProvider<ProviderValue<T>> {
  factory Provider(Create<T, ProviderState> create) = _ProviderCreate<T>;
}

extension ProviderConsume<T> on Provider<T> {
  T readOwner(ProviderStateOwner owner) {
    final state = owner.readProviderState(this);
    return state.value;
  }
}

class _ProviderCreate<T> extends BaseProvider<ProviderValue<T>>
    implements Provider<T> {
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
