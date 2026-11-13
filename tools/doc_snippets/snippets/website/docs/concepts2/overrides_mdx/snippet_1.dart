// GENERATED from website/docs/concepts2/overrides.mdx by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = Provider<int>((ref) => 0);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Placeholder();
}

void main() {
  runApp(
    ProviderScope(
      overrides: [
        // Your overrides are defined here.
        // The following shows how to override a "counter provider"
        // to use a different initial value.
        counterProvider.overrideWith((ref) => 42),
      ],
      child: MyApp(),
    ),
  );
}
