import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../helpers/item.dart';
import '../../helpers/json.dart';

/* SNIPPET START */

final itemsApiProvider = FutureProvider.autoDispose((ref) async {
  final client = Dio();
  final result = await client.get<List<dynamic>>('your-favorite-api');
  final parsed = [...result.data!.map((e) => Item.fromJson(e as Json))];
  return parsed;
});

final evenItemsProvider = Provider.autoDispose((ref) {
  final asyncValue = ref.watch(itemsApiProvider);
  if (asyncValue.isLoading) return <Item>[];
  if (asyncValue.hasError) return const [Item(id: -1)];

  final items = asyncValue.requireValue;

  return [...items.whereIndexed((index, element) => index.isEven)];
});
