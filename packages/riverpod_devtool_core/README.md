# riverpod_devtool_core

The logic behind Riverpod's devtool, without any UI.

It talks to a running application through the Dart VM service: it lists
providers and their frames, inspects states, evaluates expressions and
invalidates providers. It only depends on `riverpod` and `vm_service`, so it
runs anywhere Dart does.

Two packages are built on it:

- `riverpod_devtool`, the DevTools extension.
- `riverpod_mcp`, an MCP server exposing the same features to AI agents.

## Usage

Everything is exposed as Riverpod providers. They read the application from
`appConnectionProvider`, which has to be overridden:

```dart
final service = await vmServiceConnectUri('ws://127.0.0.1:8181/ws');
final connection = await VmServiceConnection.start(service);

final container = ProviderContainer(
  overrides: [appConnectionProvider.overrideWith((ref) => connection)],
);

final frames = await container.read(framesProvider.future);
```
