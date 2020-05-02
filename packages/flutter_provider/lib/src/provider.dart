import 'framework.dart';
import 'internal.dart';

extension BaseProviderHook<T> on BaseProvider<BaseProviderValue, T> {
  T call() => useProvider(this);
}
