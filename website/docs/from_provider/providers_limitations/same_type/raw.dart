import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../helpers/item.dart';

/* SNIPPET START */

final itemsProvider = Provider.autoDispose(
  (ref) => <Item>[], // ...
);

final evenOnlyItemsProvider = Provider.autoDispose((ref) {
  final items = ref.watch(itemsProvider);
  return [...items.whereIndexed((index, element) => index.isEven)];
});
