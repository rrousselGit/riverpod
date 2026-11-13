// GENERATED from website/docs/concepts2/consumers.mdx by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final myProvider = Provider<int>((ref) => 0);

// We subclass ConsumerWidget instead of StatelessWidget
class MyWidget extends ConsumerWidget {
  // "build" receives an extra parameter
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We can use that "ref" to listen to providers
    final value = ref.watch(myProvider);
    return Text(value.toString());
  }
}
