import 'package:provider/provider.dart';

import 'framework.dart';

extension ProviderHook<T> on Provider<T> {
  T call() {
    return dependOnProviderState(this).value;
  }
}
