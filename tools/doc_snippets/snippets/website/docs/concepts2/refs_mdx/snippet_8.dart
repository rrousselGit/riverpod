// GENERATED from website/docs/concepts2/refs.mdx by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

final myProvider = Provider<int>((ref) => 0);
final tickProvider = Provider<int>((ref) => 0);
final isDivisibleBy4Provider = Provider<bool>((ref) {
  return ref.watch(tickProvider) % 4 == 0;
});
late Ref ref;

final newTick = ref.refresh(tickProvider);
