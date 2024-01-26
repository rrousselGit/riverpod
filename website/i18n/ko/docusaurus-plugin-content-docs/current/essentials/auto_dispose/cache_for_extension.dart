import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

/* SNIPPET START */
extension CacheForExtension on AutoDisposeRef<Object?> {
  /// [duration]동안 공급자를 살아있게 유지합니다.
  void cacheFor(Duration duration) {
    // 상태가 파괴되는 것을 즉시 방지합니다.
    final link = keepAlive();
    // 기간이 경과하면 자동 폐기를 다시 활성화합니다.
    final timer = Timer(duration, link.close);

    // 선택 사항: provider가 다시 계산되면(예: ref.watch 사용) 보류 중인 타이머를 취소합니다.
    onDispose(timer.cancel);
  }
}
