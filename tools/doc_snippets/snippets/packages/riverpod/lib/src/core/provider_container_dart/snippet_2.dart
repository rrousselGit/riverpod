// GENERATED from packages/riverpod/lib/src/core/provider_container.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';

late Ref ref;
final myFamily = Provider.family<int, int>((ref, id) => id);

dynamic snippet() async {
  final args = ref.container.allProviders(family: myFamily);
  ref.read(myFamily(0));
}
