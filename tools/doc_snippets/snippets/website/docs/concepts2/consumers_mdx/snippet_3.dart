// GENERATED from website/docs/concepts2/consumers.mdx by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final myProvider = Provider<int>((ref) => 0);

// We subclass ConsumerStatefulWidget instead of StatefulWidget
class MyWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyWidget> createState() => _MyWidgetState();
}

// We subclass ConsumerState instead of State
class _MyWidgetState extends ConsumerState<MyWidget> {
  // A "this.ref" property is available
  @override
  Widget build(BuildContext context) {
    // We can use that "ref" to listen to providers
    final value = ref.watch(myProvider);
    return Text(value.toString());
  }
}
