// GENERATED from packages/riverpod/lib/src/providers/legacy/state_controller.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';
import 'package:riverpod/legacy.dart';

late Ref ref;
final provider = StateProvider<int>((ref) => 0);

dynamic snippet() async {
  ref.read(provider.notifier).update((state) => state + 1);
}
