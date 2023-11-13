// ignore_for_file: use_key_in_widget_constructors, omit_local_variable_types

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

class Package {
  static Package fromJson(dynamic json) {
    throw UnimplementedError();
  }
}

/* SNIPPET START */ // 从 pub.dev 获取包列表
@riverpod
Future<List<Package>> fetchPackages(
  FetchPackagesRef ref, {
  required int page,
  String search = '',
}) async {
  final dio = Dio();
  // 获取 API。 这里我们使用 package:dio，但我们可以使用其他任何东西。
  final response = await dio.get<List<Object?>>(
    'https://pub.dartlang.org/api/search?page=$page&q=${Uri.encodeQueryComponent(search)}',
  );

  // 将 JSON 响应解码为 Dart 类。
  return response.data?.map(Package.fromJson).toList() ?? const [];
}/* SNIPPET END */
