// ignore_for_file: unnecessary_async

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../usage/raw.dart';

class Item {}

Item fetchItem({required String id}) {
  // Simulate fetching an item from a database or API
  return Item();
}

/* SNIPPET START */
final currentItemProvider = FutureProvider<Item?>(
  // highlight-next-line
  dependencies: [currentItemIdProvider],
  (ref) async {
    final currentItemId = ref.watch(currentItemIdProvider);
    if (currentItemId == null) return null;

    // Fetch the item from a database or API
    return fetchItem(id: currentItemId);
  },
);
