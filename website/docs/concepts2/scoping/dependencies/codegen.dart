
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../usage/codegen.dart';

part 'codegen.g.dart';

class Item {}

Item fetchItem({required String id}) {
  // Simulate fetching an item from a database or API
  return Item();
}

/* SNIPPET START */
// highlight-next-line
@Riverpod(dependencies: [currentItemId])
Future<Item?> currentItem(Ref ref) async {
  final currentItemId = ref.watch(currentItemIdProvider);
  if (currentItemId == null) return null;

  // Fetch the item from a database or API
  return fetchItem(id: currentItemId);
}
