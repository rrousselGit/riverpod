import 'package:collection/collection.dart';
import 'package:riverpod/riverpod.dart';

import '../../helpers/item.dart';

/* SNIPPET START */

final itemsProvider = Provider.autoDispose(
  (ref) => <Item>[], // ...
);

final evenItemsProvider = Provider.autoDispose((ref) {
  final items = ref.watch(itemsProvider);
  return [...items.whereIndexed((index, element) => index.isEven)];
});
