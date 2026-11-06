import 'dart:async';

import 'package:riverpod/riverpod.dart';

/* SNIPPET START */
final provider = StreamProvider<int>((ref) {
  final controller = StreamController<int>();

  // {@template onDispose}
  // При уничтожении состояния закрываем StreamController.
  // {@endtemplate}
  ref.onDispose(controller.close);

  // {@template todo}
  // TO-DO: Добавьте значения в StreamController
  // {@endtemplate}
  return controller.stream;
});
/* SNIPPET END */
