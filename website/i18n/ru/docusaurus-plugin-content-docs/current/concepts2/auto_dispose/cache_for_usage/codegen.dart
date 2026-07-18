// ignore_for_file: unnecessary_async

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../cache_for_extension.dart';

part 'codegen.g.dart';

/* SNIPPET START */
@riverpod
Future<Object> example(Ref ref) async {
  // {@template cacheFor}
  /// Сохраняет состояние активным в течение 5 минут
  // {@endtemplate}
  ref.cacheFor(const Duration(minutes: 5));

  return http.get(Uri.https('example.com'));
}
