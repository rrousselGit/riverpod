// GENERATED from website/docs/concepts/about_hooks.mdx by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_ui/material_ui.dart';

double useFadeIn() {
  final animationController = useAnimationController(
    duration: const Duration(seconds: 2),
  );
  useEffect(() {
    animationController.forward();
    return null;
  }, const []);
  useAnimation(animationController);
  return animationController.value;
}
