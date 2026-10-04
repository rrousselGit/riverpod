import 'dart:async';

import 'package:devtools_app_shared/service.dart';
import 'package:devtools_app_shared/ui.dart' as shared_ui;
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as flutter_material;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'src/frame_view.dart';

final class Observer extends ProviderObserver {
  const Observer();
  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    // Replacing a frame disposes its inspector providers and cancels their
    // pending VM requests. Those cancellations are expected, not failures.
    if (error is CancelledException) return;

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
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
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
    return DevToolsExtension(
      // DevTools still supplies the SDK Material app. Give our migrated widgets
      // their own Material theme and localization delegates inside it.
      child: Builder(
        // DevToolsExtension initializes extensionManager before this builds.
        builder: (context) => ValueListenableBuilder<bool>(
          valueListenable: extensionManager.darkThemeEnabled,
          builder: (context, isDark, _) {
            final colors = isDark
                ? shared_ui.darkColorScheme
                : shared_ui.lightColorScheme;
            return MaterialApp(
              // DevTools widgets use the SDK's distinct localization type.
              localizationsDelegates: const [
                flutter_material.DefaultMaterialLocalizations.delegate,
              ],
              theme: ThemeData(
                colorScheme:
                    ColorScheme.fromSeed(
                      seedColor: colors.primary,
                      brightness: colors.brightness,
                    ).copyWith(
                      primary: colors.primary,
                      onPrimary: colors.onPrimary,
                      secondary: colors.secondary,
                      onSecondary: colors.onSecondary,
                      surface:
                          shared_ui.ideTheme.backgroundColor ?? colors.surface,
                      onSurface:
                          shared_ui.ideTheme.foregroundColor ??
                          colors.onSurface,
                      error: colors.error,
                      onError: colors.onError,
                    ),
              ),
              home: const Scaffold(body: FrameView()),
            );
          },
        ),
      ),
    );
  }
}
