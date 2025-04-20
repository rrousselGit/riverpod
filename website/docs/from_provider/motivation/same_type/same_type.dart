import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../helpers/item.dart';

part 'same_type.g.dart';

/* SNIPPET START */

@riverpod
List<Item> items(Ref ref) {
  return []; // ...
}

@riverpod
List<Item> evenItems(Ref ref) {
  final items = ref.watch(itemsProvider);
  return [...items.whereIndexed((index, element) => index.isEven)];
}
