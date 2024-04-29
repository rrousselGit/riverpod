import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

/* SNIPPET START */
extension CacheForExtension on AutoDisposeRef<Object?> {
  // {@template raw_cacheFor}
  /// Keeps the provider alive for [duration].
  // {@endtemplate}
  void cacheFor(Duration duration) {
    // {@template raw_keepAlive}
    // Immediately prevent the state from getting destroyed.
    // {@endtemplate}
    final link = keepAlive();
    // {@template raw_timer}
    // After duration has elapsed, we re-enable automatic disposal.
    // {@endtemplate}
    final timer = Timer(duration, link.close);

    // {@template raw_onDispose}
    // Optional: when the provider is recomputed (such as with ref.watch),
    // we cancel the pending timer.
    // {@endtemplate}
    onDispose(timer.cancel);
  }
}
