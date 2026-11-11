import 'dart:async';
import 'dart:developer';
import 'dart:isolate' show Isolate;

import 'package:devtool_debug_app/main.dart' as debugged_app;
import 'package:devtools_app_shared/ui.dart' as shared_ui;
import 'package:devtools_app_shared/utils.dart' show setGlobal;
import 'package:flutter/material.dart' as sdk;
import 'package:flutter_driver/driver_extension.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_devtool/src/frame_view.dart';
import 'package:riverpod_devtool/src/observer.dart';
import 'package:riverpod_devtool_core/riverpod_devtool_core.dart';
import 'package:vm_service/vm_service.dart' show IsolateRef;
import 'package:vm_service/vm_service_io.dart';

/// The application that the devtool inspects.
///
/// The window shows it on the left. Its isolate is named `main`, which is the
/// one that [VmServiceConnection] selects.
void main() {
  debugTrackProviderCreation = true;
  debugged_app.main();
}

/// The devtool, which the window shows on the right.
///
/// The macOS runner starts it in a second Flutter engine. Both engines share
/// one Dart VM, so the devtool finds the application by connecting to the VM
/// service of its own process. Running in its own isolate keeps the providers
/// of the devtool out of the list of providers that it inspects.
@pragma('vm:entry-point')
void devtoolMain() {
  // Lets tools such as the Dart MCP server tap and type in the devtool.
  // Opt-in, as it replaces the keyboard with an emulated one.
  if (const bool.fromEnvironment('flutter_driver')) {
    enableFlutterDriverExtension();
  }
  WidgetsFlutterBinding.ensureInitialized();
  // Normally set by DevTools when it hosts the extension.
  setGlobal(shared_ui.IdeTheme, shared_ui.IdeTheme());

  runApp(
    ProviderScope(
      observers: const [Observer()],
      overrides: [
        appConnectionProvider.overrideWith(_connectToOwnProcess),
        // The root library belongs to this package, but the inspected code is
        // the one of the debugged application.
        currentPackageNameProvider.overrideWith((ref) => 'devtool_debug_app'),
      ],
      child: const _DevtoolHost(),
    ),
  );
}

/// Stands in for what DevTools wraps around an extension: its Material app
/// from the SDK, around the one that the widgets of the devtool use.
class _DevtoolHost extends StatelessWidget {
  const _DevtoolHost();

  @override
  Widget build(BuildContext context) {
    sdk.ThemeData sdkTheme({required bool isDark}) => shared_ui.themeFor(
      isDarkTheme: isDark,
      ideTheme: shared_ui.ideTheme,
      theme: sdk.ThemeData(
        colorScheme: isDark
            ? shared_ui.darkColorScheme
            : shared_ui.lightColorScheme,
      ),
    );

    return sdk.MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: sdkTheme(isDark: false),
      darkTheme: sdkTheme(isDark: true),
      home: sdk.Scaffold(
        body: Builder(
          builder: (context) {
            final colors = sdk.Theme.of(context).colorScheme;

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              // DevTools widgets use the SDK's distinct localization type.
              localizationsDelegates: const [
                sdk.DefaultMaterialLocalizations.delegate,
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
                      surface: colors.surface,
                      onSurface: colors.onSurface,
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

Future<AppConnection> _connectToOwnProcess(Ref ref) async {
  final info = await Service.getInfo();
  final uri = info.serverWebSocketUri;
  if (uri == null) {
    throw StateError(
      'This process has no VM service. Run the application in debug mode.',
    );
  }

  final service = await vmServiceConnectUri('$uri');
  var started = false;
  ref.onDispose(() {
    if (!started) unawaited(service.dispose());
  });

  // Both engines name their isolate `main`. Rename the one of the devtool, so
  // that the connection can only select the application.
  final ownId = Service.getIsolateId(Isolate.current)!;
  await service.setName(ownId, 'riverpod_devtool');

  // The engine of the application may start after the one of the devtool.
  // Starting the connection before that would make the devtool inspect itself.
  while (true) {
    final isolates = (await service.getVM()).isolates ?? const <IsolateRef>[];
    if (isolates.any((isolate) => isolate.id != ownId)) break;
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }

  final connection = await VmServiceConnection.start(service);
  started = true;
  ref.onDispose(connection.dispose);
  return connection;
}
