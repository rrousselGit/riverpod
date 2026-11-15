// GENERATED from packages/riverpod/lib/src/core/ref.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';
// Ref.onManualInvalidation is experimental, and its doc has an example.
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod/legacy.dart';
import 'package:dio/dio.dart';

class Configs {
  String get host => '';
}

class User {
  factory User.fromJson(Object? json) => throw UnimplementedError();
}

class Item {
  factory Item.fromJson(Object? json) => throw UnimplementedError();
  String get id => '';
}

class Todo {
  String get title => '';
}

enum Sort { byName }

class Disposable {
  void dispose() {}
}

final dio = Dio();
late Ref ref;
final provider = Provider((ref) => 0);

final myProvider = FutureProvider((ref) async {
  final cancelToken = CancelToken();
  // Cancel pending network requests upon dispose
  ref.onDispose(cancelToken.cancel);

  return dio.get('my_api/data', cancelToken: cancelToken);
});
