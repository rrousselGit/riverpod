// GENERATED from packages/riverpod/lib/src/core/ref.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';
// Ref.onManualInvalidation is experimental, and its doc has an example.
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod/legacy.dart';

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

dynamic snippet() async {
  final disposable1 = Disposable(/* ... */);
  ref.onDispose(disposable1.dispose);

  final disposable2 = Disposable(/* ... */);
  ref.onDispose(disposable2.dispose);
}
