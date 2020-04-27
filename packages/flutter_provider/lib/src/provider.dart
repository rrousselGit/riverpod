import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import 'framework.dart';

extension BaseProvicerHook<T> on BaseProvider<Object, T> {
  T call() {
    final state = dependOnProviderState(this);
    return Hook.use(BaseProviderStateHook(state));
  }
}
