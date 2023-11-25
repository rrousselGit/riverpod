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

// Recupera l'elenco dei package da pub.dev
@riverpod
Future<List<Package>> fetchPackages(
  FetchPackagesRef ref, {
  required int page,
  String search = '',
}) async {
  final dio = Dio();
  // Effettua una richiesta API. Qui stiamo utilizzando il package 'dio', ma potremmo usare qualsiasi altro package.
  final response = await dio.get<List<Object?>>(
    'https://pub.dartlang.org/api/search?page=$page&q=${Uri.encodeQueryComponent(search)}',
  );

  // Decodifica la risposta JSON in una classe Dart.
  return response.data?.map(Package.fromJson).toList() ?? const [];
}
