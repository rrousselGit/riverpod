import 'package:devtools_app_shared/service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
