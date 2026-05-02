import 'package:devtools_app_shared/ui.dart' as ui;
import 'package:flutter/material.dart';

class DevtoolSearchBar extends StatelessWidget {
  const DevtoolSearchBar({
    super.key,
    required this.hintText,
    required this.controller,
  });

  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return ui.DevToolsClearableTextField(
      prefixIcon: const Icon(Icons.search),
      roundedBorder: true,

      hintText: hintText,
      controller: controller,
    );
  }
}
