import '../combiner.dart';
import '../common.dart';
import '../framework/framework.dart';

part 'provider1.dart';
part 'base.dart';

// This files contains the interfaces for all the variants of Provider.
// This is the public API.

/* Value */
class ProviderValue<T> {
  const ProviderValue(this._value);
  final T _value;
}

extension ProviderX<T> on ProviderListenerState<ProviderValue<T>> {
  T get value => $state._value;
}

/* Providers */

abstract class Provider<T> extends BaseProvider<ProviderValue<T>, T> {
  factory Provider(Create<T, ProviderState> create) = _ProviderCreate<T>;

  T readOwner(ProviderStateOwner owner);
}

/* Builder */

mixin _Noop {}

class ProviderBuilder<Res> = Combiner<Res, Provider> with _Noop;
