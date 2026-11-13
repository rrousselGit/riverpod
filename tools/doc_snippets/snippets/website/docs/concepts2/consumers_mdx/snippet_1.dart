// GENERATED from website/docs/concepts2/consumers.mdx by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final myProvider = Provider<int>((ref) => 0);

// We subclass StatelessWidget as usual
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // A FutureBuilder-like widget
    return Consumer(
      // The "builder" callback gives us a "ref" parameter
      builder: (context, ref, _) {
        // We can use that "ref" to listen to providers
        final value = ref.watch(myProvider);
        return Text(value.toString());
      },
    );
  }
}
