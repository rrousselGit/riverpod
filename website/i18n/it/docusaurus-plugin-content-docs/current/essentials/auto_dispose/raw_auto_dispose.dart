import 'package:riverpod/riverpod.dart';

/* SNIPPET START */
// Possiamo specificare autoDispose per abilitare la distruzione dello stato automatica.
final provider = Provider.autoDispose<int>((ref) {
  return 0;
});
