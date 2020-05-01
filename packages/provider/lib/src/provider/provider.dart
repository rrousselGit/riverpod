import '../common.dart';
import '../framework/framework.dart';

part 'base.dart';

// This files contains the interfaces for all the variants of Provider.
// This is the public API.

/* Value */
class ProviderValue<T> extends BaseProviderValue {
  ProviderValue._(this.value);

  final T value;
}

/* Providers */

abstract class Provider<T> extends BaseProvider<ProviderValue<T>, T> {
  factory Provider(Create<T, ProviderState> create) = _ProviderCreate<T>;

  T readOwner(ProviderStateOwner owner);
}
