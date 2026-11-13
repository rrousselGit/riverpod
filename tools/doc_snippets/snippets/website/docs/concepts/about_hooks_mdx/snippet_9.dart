// GENERATED from website/docs/concepts/about_hooks.mdx by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_ui/material_ui.dart';

class Example extends HookWidget {
  const Example({required this.condition, super.key});
  final bool condition;
  @override
  Widget build(BuildContext context) {
    if (condition) {
      // Hooks should not be used inside "if"s/"for"s, ...
      final controller = useAnimationController();
    }
    // ...
    return const Placeholder();
  }
}
