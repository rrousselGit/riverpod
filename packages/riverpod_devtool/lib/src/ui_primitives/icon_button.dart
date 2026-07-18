import 'package:flutter/material.dart';

/// A small icon button styled for use in panel header actions, with no
/// built-in logic.
class DevtoolIconButton extends StatelessWidget {
  const DevtoolIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final Widget icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: icon,
      iconSize: 18,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 32, height: 32),
    );
  }
}
