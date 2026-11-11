import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_devtool_core/riverpod_devtool_core.dart';

final class Observer extends ProviderObserver {
  const Observer();
  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    // Replacing a frame disposes its inspector providers and cancels their
    // pending VM requests. Those cancellations are expected, not failures.
    if (error is CancelledException) return;

    print(
      'Error in provider ${context.provider}:'
      '\n$error'
      '\n$stackTrace',
    );
  }
}
