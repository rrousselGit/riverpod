// GENERATED from website/docs/concepts/about_hooks.mdx by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_ui/material_ui.dart';

class Example extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Not _actually_ inside the "build" method, but instead inside
        // a user interaction lifecycle (here "on pressed").
        final controller = useAnimationController();
      },
      child: Text('click me'),
    );
  }
}
