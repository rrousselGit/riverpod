// GENERATED from packages/riverpod/lib/src/core/element.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';
import 'package:riverpod/misc.dart';

late Ref ref;
final provider = FutureProvider<int>((ref) async => 0);
final myProvider = FutureProvider<int>((ref) async => 0);

dynamic snippet() async {
  ref.watch(provider.select((value) => value));
}
