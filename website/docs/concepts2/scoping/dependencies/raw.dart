// ignore_for_file: avoid_dynamic_calls, inference_failure_on_function_invocation

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
});
