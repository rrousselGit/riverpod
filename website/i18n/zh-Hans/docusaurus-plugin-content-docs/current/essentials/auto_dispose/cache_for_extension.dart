import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

/* SNIPPET START */
extension CacheForExtension on Ref<Object?> {
  /// 使提供者程序在 [duration] 内存活。
  void cacheFor(Duration duration) {
    // 立即防止状态遭到破坏。
    final link = keepAlive();
    // 持续时间结束后，我们将重新启用自动处置功能。
    final timer = Timer(duration, link.close);

    // 可选项：重新计算提供者程序时（如使用 ref.watch）
    // 我们取消待定计时器
    onDispose(timer.cancel);
  }
}
