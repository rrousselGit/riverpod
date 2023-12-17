// ignore_for_file: unused_local_variable

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../cache_for_extension.dart';

part 'codegen.g.dart';

/* SNIPPET START */
@riverpod
Future<Object> example(ExampleRef ref) async {
  /// 保持状态 5 分钟
  ref.cacheFor(const Duration(minutes: 5));

  return http.get(Uri.https('example.com'));
}
