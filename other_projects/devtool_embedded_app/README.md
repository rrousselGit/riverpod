# devtool_embedded_app

A test app for the Riverpod devtool: a single macOS window showing
[devtool_debug_app](../devtool_debug_app) on the left and the devtool
inspecting it on the right.

```sh
flutter run -d macos
```

or use the `devtool_embedded_app` launch configuration in VS Code. There is
nothing to connect: one debug session covers both sides, and hot-reload and
hot-restart apply to both.

## Driving the devtool from a tool

Pass `--dart-define=flutter_driver=true` to enable the Flutter Driver
extension in the devtool's isolate. Tools such as the Dart MCP server can then
tap, type and take screenshots in the devtool:

```sh
flutter run -d macos --dart-define=flutter_driver=true
```

It is opt-in because it replaces the keyboard of the devtool with an emulated
one.

## How it works

The macOS runner (`macos/Runner/MainFlutterWindow.swift`) starts two Flutter
engines and shows them in a split view:

- one runs `main`, which is the debugged application;
- the other runs `devtoolMain`, which is the UI of `riverpod_devtool`.

Each engine has its own isolate, but both share the Dart VM of the process.
The devtool therefore connects to the VM service of its own process
(`Service.getInfo()`) and inspects the other isolate. Since the devtool lives
in a separate isolate, its own providers do not show up in the list.

The devtool is hosted without DevTools, so features relying on it (such as the
IDE theme) are unavailable. macOS is the only supported platform.
