// GENERATED from packages/riverpod/lib/src/core/provider/provider.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';

late Ref ref;
final provider = Provider((ref) => 0);

dynamic snippet() async {
  print(ref.watch(provider.exists)); // false initially
  ref.watch(provider); // `provider` was mounted right after the exist check
}
