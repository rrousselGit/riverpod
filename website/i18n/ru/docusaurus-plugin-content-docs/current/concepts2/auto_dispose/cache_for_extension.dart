import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

/* SNIPPET START */
extension CacheForExtension on Ref {
  // {@template cacheFor}
  /// Сохраняет provider активным в течение [duration].
  // {@endtemplate}
  void cacheFor(Duration duration) {
    // {@template keepAlive}
    // Сразу предотвращаем уничтожение состояния.
    // {@endtemplate}
    final link = keepAlive();
    // {@template timer}
    // После истечения времени снова включаем автоматическое освобождение ресурсов.
    // {@endtemplate}
    final timer = Timer(duration, link.close);

    // {@template onDispose}
    // Опционально: при пересоздании provider (например, через ref.watch)
    // отменяем запланированный таймер.
    // {@endtemplate}
    onDispose(timer.cancel);
  }
}
