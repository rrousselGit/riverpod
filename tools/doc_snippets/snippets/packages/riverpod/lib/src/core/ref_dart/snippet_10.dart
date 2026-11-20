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

final fetchItemList = FutureProvider<List<Item>>((ref) async => [/* ... */]);

final fetchItem = FutureProvider.autoDispose.family<Item, String>((
  ref,
  id,
) async {
  if (ref.read(fetchItemList.exists)) {
    // If `fetchItemList` is initialized, we look into its state
    // and return the already obtained item.
    final itemFromItemList = await ref.watch(
      fetchItemList.selectAsync(
        (items) => items.firstWhereOrNull((item) => item.id == id),
      ),
    );
    if (itemFromItemList != null) return itemFromItemList;
  }

  // If `fetchItemList` is not initialized, perform a network request for
  // "id" separately

  final response = await http.get(Uri.parse('api/items/$id'));
  return Item.fromJson(jsonDecode(response.body));
});
