import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/* SNIPPET START */
// Possiamo specificare autoDispose per abilitare la distruzione dello stato automatica.
final provider = Provider.autoDispose<int>((ref) {
  return 0;
});
