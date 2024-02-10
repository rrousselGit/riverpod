// ignore_for_file: unused_local_variable

import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';

import '../cache_for_extension.dart';

/* SNIPPET START */
final provider = FutureProvider.autoDispose<Object>((ref) async {
  // Mantiene lo stato attivo per 5 minuti
  ref.cacheFor(const Duration(minutes: 5));

  return http.get(Uri.https('example.com'));
});
/* SNIPPET END */
