// ignore_for_file: unused_local_variable

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../cache_for_extension.dart';

part 'codegen.g.dart';

/* SNIPPET START */
@riverpod
Future<Object> example(ExampleRef ref) async {
  /// 5분 동안 상태를 유지합니다.
  ref.cacheFor(const Duration(minutes: 5));

  return http.get(Uri.https('example.com'));
}
