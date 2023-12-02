import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

/* SNIPPET START */
extension CacheForExtension on AutoDisposeRef<Object?> {
  /// Mantiene il provider in vita per [duration].
  void cacheFor(Duration duration) {
    // Previene subito lo stato dal essere distrutto.
    final link = keepAlive();
    // Dopo che la durata è terminata, riabilitiamo la rimozione automatica
    final timer = Timer(duration, link.close);

    // Opzionale: quando il provider viene ricomputato (come con ref.watch),
    // cancelliamo il timer rimasto attivo.
    onDispose(timer.cancel);
  }
}
