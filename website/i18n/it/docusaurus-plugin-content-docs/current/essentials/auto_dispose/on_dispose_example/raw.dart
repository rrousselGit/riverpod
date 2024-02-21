// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:riverpod/riverpod.dart';

/* SNIPPET START */
final provider = StreamProvider<int>((ref) {
  final controller = StreamController<int>();

  // Quando lo stato viene distrutto chiudiamo lo StreamController.
  ref.onDispose(controller.close);

  // TO-DO: Aggiungere dei valori nello StreamController
  return controller.stream;
});
/* SNIPPET END */
