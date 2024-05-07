// ignore_for_file: omit_local_variable_types

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */
final myProvider = ChangeNotifierProvider<ValueNotifier<int>>((ref) {
  // {@template provider}
  // Will listen to and dispose of the ValueNotifier.
  // Widgets can then "ref.watch" this provider to listen to updates.
  // {@endtemplate}
  return ValueNotifier(0);
});
