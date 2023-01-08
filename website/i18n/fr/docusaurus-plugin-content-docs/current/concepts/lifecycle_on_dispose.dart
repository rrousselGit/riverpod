// ignore_for_file: unused_local_variable, unnecessary_lambdas

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

/* SNIPPET START */
final example = StreamProvider.autoDispose((ref) {
  final streamController = StreamController<int>();

  ref.onDispose(() {
    // Ferme le StreamController quand son état est détruite.
    streamController.close();
  });

  return streamController.stream;
});
