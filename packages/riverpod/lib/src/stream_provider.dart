import 'dart:async';

import 'package:meta/meta.dart';

import 'async_value_converters.dart';
import 'builders.dart';
import 'common.dart';
import 'framework.dart';
import 'future_provider.dart';
import 'provider.dart';

part 'stream_provider/auto_dispose.dart';
part 'stream_provider/base.dart';

/// {@template riverpod.streamprovider}
/// Creates a stream and expose its latest event.
///
/// [StreamProvider] is identical in behavior/usage to [FutureProvider], modulo
/// the fact that the value created is a [Stream] instead of a [Future].
///
/// It can be used to express a value asynchronously loaded that can change over
/// time, such as an editable `Message` coming from a web socket:
///
/// ```dart
/// final messageProvider = StreamProvider.autoDispose<String>((ref) async* {
///   // Open the connection
///   final channel = IOWebSocketChannel.connect('ws://echo.websocket.org');
///
///   // Close the connection when the stream is destroyed
///   ref.onDispose(() => channel.sink.close());
///
///   // Parse the value received and emit a Message instance
///   await for (final value in channel.stream) {
///     yield value.toString();
///   }
/// });
/// ```
///
/// Which the UI can then listen:
///
/// ```dart
/// Widget build(BuildContext context, WidgetRef ref) {
///   AsyncValue<String> message = ref.watch(messageProvider);
///
///   return message.when(
///     loading: () => const CircularProgressIndicator(),
///     error: (err, stack) => Text('Error: $err'),
///     data: (message) {
///       return Text(message);
///     },
///   );
/// }
/// ```
///
/// **Note**:
/// When listening to web sockets, firebase, or anything that consumes resources,
/// it is important to use [StreamProvider.autoDispose] instead of simply [StreamProvider].
///
/// This ensures that the resources are released when no-longer needed as,
/// by default, a [StreamProvider] is almost never destroyed.
///
/// See also:
///
/// - [Provider], a provider that synchronously creates a value
/// - [FutureProvider], a provider that asynchronously expose a value which
///   can change over time.
/// - [AlwaysAliveAsyncProviderX.stream], to obtain the [Stream] created instead of an [AsyncValue].
/// - [AlwaysAliveAsyncProviderX.future], to obtain the last value emitted by a [Stream].
/// - [StreamProvider.family], to create a [StreamProvider] from external parameters
/// - [StreamProvider.autoDispose], to destroy the state of a [StreamProvider] when no-longer needed.
/// {@endtemplate}
mixin _StreamProviderElementMixin<State>
    on ProviderElementBase<AsyncValue<State>> {
  AsyncValue<State> _listenStream(Stream<State> Function() stream) {
    try {
      final sub = stream().listen(
        (event) => setState(AsyncValue.data(event)),
        // ignore: avoid_types_on_closure_parameters
        onError: (Object err, StackTrace stack) {
          setState(AsyncValue.error(err, stackTrace: stack));
        },
      );

      onDispose(sub.cancel);

      return AsyncValue<State>.loading();
    } catch (err, stack) {
      return AsyncValue<State>.error(err, stackTrace: stack);
    }
  }
}
