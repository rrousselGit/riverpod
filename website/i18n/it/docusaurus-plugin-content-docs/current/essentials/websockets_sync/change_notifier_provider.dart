// ignore_for_file: omit_local_variable_types

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/legacy.dart';

/* SNIPPET START */
final myProvider = ChangeNotifierProvider<ValueNotifier<int>>((ref) {
  // Ascolterà ed eliminerà ValueNotifier
  // I widget possono quindi "ref.watch" questo provider per ascoltarne gli aggiornamenti.
  return ValueNotifier(0);
});
