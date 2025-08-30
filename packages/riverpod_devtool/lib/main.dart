import 'dart:async';

import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'src/frame_view.dart';

final class Observer extends ProviderObserver {
  const Observer();
  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    // ignore: avoid_print
    print(
      'Error in provider ${context.provider}:'
      '\n$error'
      '\n$stackTrace',
    );
  }
}

void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();
      runApp(
        const ProviderScope(
          observers: [Observer()],
          child: RiverpodDevtoolExtension(),
        ),
      );
    },
    (err, stack) {
      // ignore: avoid_print
      print('Uncaught error: $err\n$stack');
    },
  );
}

class RiverpodDevtoolExtension extends ConsumerStatefulWidget {
  const RiverpodDevtoolExtension({super.key});

  @override
  ConsumerState<RiverpodDevtoolExtension> createState() =>
      _RiverpodDevtoolExtensionState();
}

class _RiverpodDevtoolExtensionState
    extends ConsumerState<RiverpodDevtoolExtension> {
  Timer? _timer;
  WidgetsBinding _binding = WidgetsBinding.instance;
  late ProviderContainer _container;
  @override
  void initState() {
    super.initState();
    // Check for hot-restart on web, because widgets are not disposed.
    // This works around it by manually disposing some of the resources that
    // Flutter should have disposed.
    if (kDebugMode && kIsWeb) {
      _timer = Timer.periodic(Duration.zero, (_) {
        final binding = WidgetsBinding.instance;
        if (_binding != binding) {
          // Hot-restart detected, and on web it fails to dispose the previous widget
          // tree. We at the very least dispose the old providers.
          _binding = binding;
          _timer?.cancel();

          _container.dispose();
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _container = ProviderScope.containerOf(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const DevToolsExtension(child: FrameView());
  }
}
