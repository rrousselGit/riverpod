// GENERATED from packages/riverpod/lib/src/core/provider/functional_provider.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;

class MyService {}

class MyFakeService extends MyService {}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Placeholder();
}

final otherProvider = Provider((ref) => 0);

dynamic snippet() async {
  final myService = Provider((ref) => MyService());

  runApp(
    ProviderScope(
      overrides: [
        // Replace the implementation of the provider with a different one
        myService.overrideWith((ref) {
          ref.watch(otherProvider);
          return MyFakeService();
        }),
      ],
      child: MyApp(),
    ),
  );
}
