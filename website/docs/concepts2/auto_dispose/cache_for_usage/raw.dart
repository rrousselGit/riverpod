// ignore_for_file: unnecessary_async

import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';

import '../cache_for_extension.dart';

/* SNIPPET START */
final provider = FutureProvider.autoDispose<Object>((ref) async {
  // {@template cacheFor}
  /// Keeps the state alive for 5 minutes
  // {@endtemplate}
  ref.cacheFor(const Duration(minutes: 5));

  return http.get(Uri.https('example.com'));
});
/* SNIPPET END */
