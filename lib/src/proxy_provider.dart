import 'package:flutter/foundation.dart';

import 'framework.dart';
import 'provider.dart';

// Fine, no warning
final otherProvider = Provider((_) => 42);

// Triggers top_level_function_literal_block
// but both are correctly inferred (ProviderState<int> and ProviderState<String>)
final provider1 = Provider1(otherProvider, (state, otherState) {
  return 'Hello world';
});

final useOther = Provider((_) => 42);

final useProvider = Provider1(useOther, (state, otherState) {
  return 0;
});

abstract class Provider1<First, Res> extends BaseProvider1<First, Res> {
  factory Provider1(
    BaseProvider<First> firstProvider,
    Res Function(ProviderState<Res>, ProviderListenerState<First>) create,
  ) = _Provider1<First, Res>;
}

class _Provider1<First, Res> extends BaseProvider1<First, Res>
    implements Provider1<First, Res> {
  _Provider1(
    BaseProvider<First> firstProvider,
    this.create,
  ) : super(firstProvider);

  final Res Function(ProviderState<Res>, ProviderListenerState<First>) create;

  @override
  _Provider1State<First, Res> createState() {
    return _Provider1State<First, Res>();
  }
}

class _Provider1State<First, Res>
    extends BaseProvider1State<First, Res, _Provider1<First, Res>>
    implements ProviderState<Res> {
  @override
  Res initState() {
    return provider.create(this, firstDependencyState);
  }

  // @override
  // Res get value => state;

  // @override
  // set value(Res newValue) => state = newValue;

  @override
  void onDispose(VoidCallback cb) {
    // TODO: implement onDispose
  }
}
