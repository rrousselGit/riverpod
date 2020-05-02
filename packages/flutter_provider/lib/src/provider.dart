import 'package:flutter_hooks/flutter_hooks.dart';

import 'framework.dart';
import 'internal.dart';

extension BaseProviderHook<T> on BaseProvider<BaseProviderValue, T> {
  T call() {
    final state = dependOnProviderState(useContext(), this);
    return Hook.use(BaseProviderStateHook(state));
  }
}
