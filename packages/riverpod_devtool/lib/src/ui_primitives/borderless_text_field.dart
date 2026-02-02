// Fork of DevtoolClearableTextField from devtools_shared_ui with no border

// Copyright 2024 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file or at https://developers.google.com/open-source/licenses/bsd.

import 'package:devtools_app_shared/ui.dart';
import 'package:flutter/material.dart';

/// A DevTools-styled text field with a suffix action to clear the search field.
final class BorderlessTextField extends StatelessWidget {
  BorderlessTextField({
    super.key,
    TextEditingController? controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.additionalSuffixActions = const <Widget>[],
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.enabled,
    this.roundedBorder = false,
    this.focusNode,
    this.onEditingComplete,
    this.textInputAction,
  }) : controller = controller ?? TextEditingController();

  final TextEditingController controller;
  final String? hintText;
  final Widget? prefixIcon;
  final List<Widget> additionalSuffixActions;
  final String? labelText;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onEditingComplete;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final bool? enabled;
  final bool roundedBorder;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: defaultTextFieldHeight + densePadding,
      child: TextField(
        onEditingComplete: onEditingComplete,
        textInputAction: textInputAction,
        focusNode: focusNode,
        textAlignVertical: TextAlignVertical.center,
        cursorHeight: defaultTextFieldHeight / 2,
        autofocus: autofocus,
        controller: controller,
        enabled: enabled,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        style: theme.regularTextStyle,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.only(
            top: densePadding,
            bottom: densePadding,
            left: denseSpacing,
          ),
          constraints: BoxConstraints(
            minHeight: defaultTextFieldHeight,
            maxHeight: defaultTextFieldHeight,
          ),
          border: .none,
          labelText: labelText,
          labelStyle: theme.subtleTextStyle,
          hintText: hintText,
          hintStyle: theme.subtleTextStyle,
          prefixIcon: prefixIcon,
          suffixIcon: SizedBox(
            height: inputDecorationElementHeight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...additionalSuffixActions,
                InputDecorationSuffixButton.clear(
                  onPressed: () {
                    controller.clear();
                    onChanged?.call('');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A DevTools-styled icon action button intended to be used as an
/// [InputDecoration.suffix] widget.
final class InputDecorationSuffixButton extends StatelessWidget {
  const InputDecorationSuffixButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  factory InputDecorationSuffixButton.clear({
    required VoidCallback? onPressed,
  }) => InputDecorationSuffixButton(
    icon: Icons.clear,
    onPressed: onPressed,
    tooltip: 'Clear',
  );

  factory InputDecorationSuffixButton.close({
    required VoidCallback? onPressed,
  }) => InputDecorationSuffixButton(
    icon: Icons.close,
    onPressed: onPressed,
    tooltip: 'Close',
  );

  factory InputDecorationSuffixButton.help({
    required VoidCallback? onPressed,
  }) => InputDecorationSuffixButton(
    icon: Icons.question_mark,
    onPressed: onPressed,
    tooltip: 'Help',
  );

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return maybeWrapWithTooltip(
      tooltip: tooltip,
      child: SizedBox(
        height: inputDecorationElementHeight,
        width: inputDecorationElementHeight + denseSpacing,
        child: IconButton(
          padding: EdgeInsets.zero,
          onPressed: onPressed,
          iconSize: defaultIconSize,
          splashRadius: defaultIconSize,
          icon: Icon(icon),
        ),
      ),
    );
  }
}
