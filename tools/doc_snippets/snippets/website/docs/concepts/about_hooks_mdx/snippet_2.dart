// GENERATED from website/docs/concepts/about_hooks.mdx by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_ui/material_ui.dart';

class FadeIn extends HookWidget {
  const FadeIn({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Create an AnimationController. The controller will automatically be
    // disposed when the widget is unmounted.
    final animationController = useAnimationController(
      duration: const Duration(seconds: 2),
    );

    // useEffect is the equivalent of initState + didUpdateWidget + dispose.
    // The callback passed to useEffect is executed the first time the hook is
    // invoked, and then whenever the list passed as second parameter changes.
    // Since we pass an empty const list here, that's strictly equivalent to `initState`.
    useEffect(() {
      // start the animation when the widget is first rendered.
      animationController.forward();
      // We could optionally return some "dispose" logic here
      return null;
    }, const []);

    // Tell Flutter to rebuild this widget when the animation updates.
    // This is equivalent to AnimatedBuilder
    useAnimation(animationController);

    return Opacity(opacity: animationController.value, child: child);
  }
}
