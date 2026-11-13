// GENERATED from website/docs/concepts2/retry.mdx by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Placeholder();
}

final myProvider = FutureProvider<int>((ref) async => 0);
late Ref ref;

dynamic snippet() async {
  runApp(
    ProviderScope(
      // highlight-next-line
      retry: (retryCount, error) => null,
      child: MyApp(),
    ),
  );
}
