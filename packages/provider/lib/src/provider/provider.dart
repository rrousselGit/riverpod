import '../combiner.dart';
import '../common.dart';
import '../framework/framework.dart';

part 'provider1.dart';
part 'base.dart';

// This files contains the interfaces for all the variants of Provider.
// This is the public API.

/* Value */
class ProviderValue<T> extends ProviderState {
  ProviderValue._(
    this.value,
    _ProviderStateMixin<T, BaseProvider<ProviderValue<T>, T>> _state,
  ) : super(_state);

  final T value;
}

/* Providers */

abstract class Provider<T> extends BaseProvider<ProviderValue<T>, T> {
  factory Provider(Create<T, ProviderState> create) = _ProviderCreate<T>;

  T readOwner(ProviderStateOwner owner);
}

/* Builder */

mixin _Noop {}

class ProviderBuilder<Res> = Combiner<Res, Provider> with _Noop;
