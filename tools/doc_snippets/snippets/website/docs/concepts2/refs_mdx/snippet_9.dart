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
          // Read the current tick value
          final tick = ref.read(tickProvider);
          print('Current tick: $tick');
        },
        child: Text('Print Tick'),
      );
    },
  );
}
