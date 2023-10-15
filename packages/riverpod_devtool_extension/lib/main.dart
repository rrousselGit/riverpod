import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/provider_screen.dart';
import 'src/utils/riverpod_error_logger_observer.dart';

void main() {
  runApp(const ProviderScope(
    observers: [ErrorLoggerObserver()],
    child: ProviderDevToolsExtension(),
  ));
}

class ProviderDevToolsExtension extends StatelessWidget {
  const ProviderDevToolsExtension({super.key});

  @override
  Widget build(BuildContext context) {
    return const DevToolsExtension(
      child: ProviderScreenBody(),
    );
  }
}
