// GENERATED from packages/flutter_riverpod/lib/src/core/widget_ref.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';

late WidgetRef ref;
final provider = Provider((ref) => 0);

final counterProvider = NotifierProvider<Counter, int>(Counter.new);

class Counter extends Notifier<int> {
  @override
  int build() => 0;
  void increment() => state++;
}

class Model {
  int get valueThatNeverChanges => 0;
}

final modelProvider = Provider((ref) => Model());

class Item {
  factory Item.fromJson(Object? json) => throw UnimplementedError();
  String get id => '';
}

class Product {}

class Products {
  factory Products.fromJson(Object? json) => throw UnimplementedError();
  List<Product> get items => [];
}

class ProductItem extends SizedBox {
  ProductItem({required Product product});
}

final httpClient = Dio();

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
