// GENERATED from packages/riverpod/lib/src/core/proxy_provider_listenable.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';

late Ref ref;
final futureProvider = FutureProvider<int>((ref) async => 0);

dynamic snippet() async {
  ref.watch(futureProvider.future);
}
