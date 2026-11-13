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

dynamic snippet() async {
  Consumer(
    builder: (context, ref, _) {
      return ElevatedButton(
        onPressed: () {
          // Reset the tick provider
          // This will restart the tick from 0
          ref.invalidate(tickProvider);
        },
        child: Text('Reset Tick'),
      );
    },
  );
}
