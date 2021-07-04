import 'dart:async';

import 'package:meta/meta.dart';

import 'async_value_converters.dart';
import 'builders.dart';
import 'common.dart';
import 'framework.dart';
import 'future_provider.dart';
import 'provider.dart';
import 'value_provider.dart';

part 'stream_provider/auto_dispose.dart';
part 'stream_provider/base.dart';

mixin _StreamProviderMixin<T> on ProviderBase<AsyncValue<T>> {
  /// Exposes the [Stream] created by a [StreamProvider].
  ///
  /// The stream obtained is not strictly identical to the stream created.
  /// Instead, this stream is always a broadcast stream.
  ///
  /// The stream obtained may change over time, if the [StreamProvider] is
  /// re-evaluated, such as when it is using [ProviderRefBase.watch] and the
  /// provider listened changes, or on [ProviderContainer.refresh].
  ///
  /// If the [StreamProvider] was overridden using `overrideWithValue`,
  /// a stream will be generated and manipulated based on the [AsyncValue] used.
  ProviderBase<Stream<T>> get stream;

  /// Exposes a [Future] which resolves with the last value or error emitted.
  ///
  /// This can be useful for scenarios where we want to read the current value
  /// exposed by a [StreamProvider], but also handle the scenario were no
  /// value were emitted yet:
  ///
  /// ```dart
  /// final configsProvider = StreamProvider<Configuration>((ref) async* {
  ///   // somehow emit a Configuration instance
  /// });
  ///
  /// final productsProvider = FutureProvider<Products>((ref) async {
  ///   // If a "Configuration" was emitted, retrieve it.
  ///   // Otherwise, wait for a Configuration to be emitted.
  ///   final configs = await ref.watch(configsProvider.last);
  ///
  ///   final response = await httpClient.get('${configs.host}/products');
  ///   return Products.fromJson(response.data);
  /// });
  /// ```
  ///
  /// ## Why not use [StreamProvider.stream.first] instead?
  ///
  /// If you are familiar with streams, you may wonder why not use [Stream.first]
  /// instead:
  ///
  /// ```dart
  /// final configsProvider = StreamProvider<Configuration>((ref) {...});
  ///
  /// final productsProvider = FutureProvider<Products>((ref) async {
  ///   final configs = await ref.watch(configsProvider.stream).first;
  ///   ...
  /// }
  /// ```
  ///
  /// The problem with this code is, unless your [StreamProvider] is creating
  /// a `BehaviorSubject` from `package:rxdart`, you have a bug.
  ///
  /// By default, if we call [Stream.first] **after** the first value was emitted,
  /// then the [Future] created will not obtain that first value but instead
  /// wait for a second one – which may never come.
  ///
  /// The following code demonstrate this problem:
  ///
  /// ```dart
  /// final exampleProvider = StreamProvider<int>((ref) async* {
  ///   yield 42;
  /// });
  ///
  /// final anotherProvider = FutureProvider<void>((ref) async {
  ///   print(await ref.watch(exampleProvider.stream).first);
  ///   // The code will block here and wait forever
  ///   print(await ref.watch(exampleProvider.stream).first);
  ///   print('this code is never reached');
  /// });
  ///
  /// void main() async {
  ///   final container = ProviderContainer();
  ///   await container.read(anotherProvider.future);
  ///   // never reached
  ///   print('done');
  /// }
  /// ```
  ///
  /// This snippet will print `42` once, then wait forever.
  ///
  /// On the other hand, if we used [StreamProvider.last], our code would
  /// correctly execute:
  ///
  /// ```dart
  /// final exampleProvider = StreamProvider<int>((ref) async* {
  ///   yield 42;
  /// });
  ///
  /// final anotherProvider = FutureProvider<void>((ref) async {
  ///   print(await ref.watch(exampleProvider.last));
  ///   print(await ref.watch(exampleProvider.last));
  ///   print('completed');
  /// });
  ///
  /// void main() async {
  ///   final container = ProviderContainer();
  ///   await container.read(anotherProvider.future);
  ///   print('done');
  /// }
  /// ```
  ///
  /// with this modification, our code will now print:
  ///
  /// ```
  /// 42
  /// 42
  /// completed
  /// done
  /// ```
  ///
  /// which is the expected behavior.
  ProviderBase<Future<T>> get last;
}

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
/// - [StreamProvider.stream], to obtain the [Stream] created instead of an [AsyncValue].
/// - [StreamProvider.last], to obtain the last value emitted by a [Stream].
/// - [StreamProvider.family], to create a [StreamProvider] from external parameters
/// - [StreamProvider.autoDispose], to destroy the state of a [StreamProvider] when no-longer needed.
/// {@endtemplate}
AsyncValue<State> _listenStream<State>(
  Stream<State> Function() stream,
  ProviderRef<AsyncValue<State>> ref,
) {
  try {
    final sub = stream().listen(
      (event) => ref.state = AsyncValue.data(event),
      // ignore: avoid_types_on_closure_parameters
      onError: (Object err, StackTrace stack) {
        ref.state = AsyncValue.error(err, stack);
      },
    );

    ref.onDispose(sub.cancel);

    return const AsyncValue.loading();
  } catch (err, stack) {
    return AsyncValue.error(err, stack);
  }
}
