import 'package:flutter/material.dart';
import 'package:devtools_app_shared/ui.dart' as ui;

class Terminal extends StatelessWidget {
  const Terminal({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: const Placeholder()),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ui.DevToolsClearableTextField(
            hintText: 'Enter command',
            labelText: 'Terminal',
          ),
        ),
      ],
    );
  }
}
