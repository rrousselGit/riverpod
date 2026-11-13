// GENERATED from packages/riverpod/lib/src/core/foundation.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';

class Foo {}

// By not specifying "dependencies", we are saying that this provider is never scoped
final rootProvider = Provider((ref) => Foo());
// By specifying "dependencies" (even if the list is empty),
// we are saying that this provider is potentially scoped
final scopedProvider = Provider((ref) => Foo(), dependencies: []);
