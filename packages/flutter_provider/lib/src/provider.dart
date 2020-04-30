import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import 'framework.dart';

extension BaseProviderHook<T> on BaseProvider<BaseProviderValue, T> {
  T call() {
    final state = dependOnProviderState(this);
    return Hook.use(BaseProviderStateHook(state));
  }
}
