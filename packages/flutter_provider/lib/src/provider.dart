import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/future_provider/future_provider.dart';

import 'framework.dart';

extension ProviderHook<T> on Provider<T> {
  T call() {
    return dependOnProviderState(this).value;
  }
}

extension FutureProviderHook<T> on FutureProvider<T> {
  AsyncValue<T> call() {
    final state = dependOnProviderState(this);
    final value = Hook.use(BaseProviderStateHook(state));

    return value.value;
  }
}
