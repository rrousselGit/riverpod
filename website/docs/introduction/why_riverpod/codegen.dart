// ignore_for_file: use_key_in_widget_constructors, omit_local_variable_types

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

class Package {
  static Package fromJson(dynamic json) {
    throw UnimplementedError();
  }
}

/* SNIPPET START */

// {@template fetchPackages}
// Fetches the list of packages from pub.dev
// {@endtemplate}
@riverpod
Future<List<Package>> fetchPackages(
  FetchPackagesRef ref, {
  required int page,
  String search = '',
}) async {
  final dio = Dio();
  // {@template fetchApi}
  // Fetch an API. Here we're using package:dio, but we could use anything else.
  // {@endtemplate}
  final response = await dio.get<List<Object?>>(
    'https://pub.dartlang.org/api/search?page=$page&q=${Uri.encodeQueryComponent(search)}',
  );

  // {@template decodeJson}
  // Decode the JSON response into a Dart class.
  // {@endtemplate}
  return response.data?.map(Package.fromJson).toList() ?? const [];
}
