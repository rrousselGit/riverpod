// ignore_for_file: unnecessary_async

import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';

import '../cache_for_extension.dart';

/* SNIPPET START */
final provider = FutureProvider.autoDispose<Object>((ref) async {
  // {@template cacheFor}
  /// Сохраняет состояние активным в течение 5 минут
  // {@endtemplate}
  ref.cacheFor(const Duration(minutes: 5));

  return http.get(Uri.https('example.com'));
});
/* SNIPPET END */
