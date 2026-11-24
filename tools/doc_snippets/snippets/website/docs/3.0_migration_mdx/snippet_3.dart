// GENERATED from website/docs/3.0_migration.mdx by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

late WidgetRef ref;
final myProvider = FutureProvider<int>((ref) async => 0);

class NotFoundException implements Exception {}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Placeholder();
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TickerMode(
      enabled: true, // Never pause any descendant listener.
      child: Consumer(
        builder: (context, ref, child) {
          // This "watch" will not follow the automatic pausing behavior
          // until TickerMode is removed.
          final value = ref.watch(myProvider);
          return Text(value.toString());
        },
      ),
    );
  }
}
