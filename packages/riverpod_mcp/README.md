# riverpod_mcp

An [MCP](https://modelcontextprotocol.io) server that lets AI agents inspect
the providers of a running Riverpod application.

It exposes the features of Riverpod's devtool, and shares its implementation
through `riverpod_devtool_core`.

## Usage

Run your application in debug mode and note its VM service URI, which
`flutter run` and `dart run --enable-vm-service` print:

```
A Dart VM Service on macOS is available at: http://127.0.0.1:51234/AbCdEf=/
```

Then register the server with your agent. With Claude Code, from this
repository:

```sh
claude mcp add riverpod -- dart run packages/riverpod_mcp/bin/riverpod_mcp.dart
```

The agent connects by calling `connect` with that URI.

## Tools

| Tool                  | Description                                                                 |
| --------------------- | --------------------------------------------------------------------------- |
| `connect`             | Connects to an application from its VM service URI.                         |
| `list_providers`      | Lists providers: name, family argument, where they are defined and changes. |
| `inspect_provider`    | Reads the state or notifier of a provider as a tree of values.              |
| `list_frames`         | Lists recorded frames, and which providers changed in each.                 |
| `set_time_travel`     | Starts or stops recording a frame per change, to inspect past states.       |
| `invalidate_provider` | Invalidates a provider.                                                     |
| `evaluate`            | Evaluates an expression using `$state`, `$notifier` and `$previous`.        |

`inspect_provider` and `evaluate` read values `depth` levels deep. Deeper
values are marked as `truncated` and come with the `path` to pass to
`inspect_provider` to read them.
