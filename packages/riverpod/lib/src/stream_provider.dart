import 'dart:async';

import 'package:meta/meta.dart';

import 'builders.dart';
import 'common.dart' show AsyncLoading, AsyncValue;
import 'framework.dart';
import 'future_provider.dart';
import 'provider.dart';

part 'stream_provider/auto_dispose.dart';
part 'stream_provider/base.dart';

mixin _StreamProviderMixin<T> on RootProvider<Stream<T>, AsyncValue<T>> {
  Override overrideWithValue(AsyncValue<T> value) {
    return ProviderOverride(
      ValueProvider<Stream<T>, AsyncValue<T>>((ref) {
        AsyncValue<T>? lastValue;
        final controller = StreamController<T>();
        ref.onDispose(controller.close);

        ref.onChange = (newValue) {
          newValue.when(
            data: controller.add,
            loading: () {
              if (lastValue != null && lastValue is! AsyncLoading) {
                ref.markMustRecomputeState();
              }
            },
            error: controller.addError,
          );
          lastValue = newValue;
        };

        ref.onChange!(value);

        return controller.stream.asBroadcastStream();
      }, value),
      this,
    );
  }

  /// Exposes the [Stream] created by a [StreamProvider].
  ///
  /// The stream obtained is not strictly identical to the stream created.
  /// Instead, this stream is always a broadcast stream.
  ///
  /// The stream obtained may change over time, if the [StreamProvider] is
  /// re-evaluated, such as when it is using [ProviderReference.watch] and the
  /// provider listened changes, or on [ProviderContainer.refresh].
  ///
  /// If the [StreamProvider] was overridden using `overrideWithValue`,
  /// a stream will be generated and manipulated based on the [AsyncValue] used.
  RootProvider<Stream<T>, Stream<T>> get stream;

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
  RootProvider<Object?, Future<T>> get last;
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
/// Widget build(BuildContext, ScopedReader watch) {
///   AsyncValue<String> message = watch(messageProvider);
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
mixin _StreamProviderStateMixin<T>
    on ProviderStateBase<Stream<T>, AsyncValue<T>> {
  StreamSubscription<T>? sub;
  StreamController<T>? _proxyController;
  Stream<T> get proxyStream {
    _proxyController ??= StreamController.broadcast();
    return _proxyController!.stream;
  }

  @override
  void valueChanged({Stream<T>? previous}) {
    if (createdValue == previous) {
      return;
    }
    sub?.cancel();
    _proxyController?.close();
    _proxyController = null;

    // TODO transition between state ??= vs =
    // TODO don't notify if already loading
    exposedValue = const AsyncValue.loading();
    sub = createdValue.listen(
      (value) {
        exposedValue = AsyncValue.data(value);
        _proxyController?.add(value);
      },
      // ignore: avoid_types_on_closure_parameters
      onError: (Object error, StackTrace stack) {
        exposedValue = AsyncValue.error(error, stack);
        _proxyController?.addError(error, stack);
      },
      onDone: () => _proxyController?.close(),
    );
  }

  @override
  bool handleError(Object error, StackTrace stackTrace) {
    exposedValue = AsyncValue.error(error, stackTrace);
    return true;
  }

  @override
  void dispose() {
    sub?.cancel();
    _proxyController?.close();
    super.dispose();
  }
}

Future<T> _readLast<T>(
  ProviderElement ref,
  _StreamProviderMixin<T> provider,
) {
  return ref.watch(provider).when(
        data: (value) => Future.value(value),
        loading: () {
          final stream = ref.watch(provider.stream);

          final completer = Completer<T>();
          late StreamSubscription<T> sub;

          sub = stream.listen(
            (value) {
              completer.complete(value);
              sub.cancel();
            },
            // ignore: avoid_types_on_closure_parameters
            onError: (Object err, StackTrace stack) {
              completer.completeError(err, stack);
              sub.cancel();
            },
            onDone: () {
              completer.completeError(
                StateError('The stream was closed before emitting a value'),
              );
              sub.cancel();
            },
          );

          ref.onDispose(() {
            sub.cancel();
            if (!completer.isCompleted) {
              completer.completeError(
                StateError(
                  'The provider was disposed the stream could emit a value',
                ),
              );
            }
          });

          return completer.future;
        },
        error: (err, stack) => Future.error(err, stack),
      );
}

// Fork of CreatedProvider to retrieve _proxyStream instead of createdValue

@sealed
class _CreatedStreamProvider<T> extends Provider<Stream<T>> {
  _CreatedStreamProvider(
    AlwaysAliveProviderBase<Stream<T>, Object?> provider, {
    String? name,
  }) : super((ref) {
          ref.watch(provider);
          // ignore: invalid_use_of_visible_for_testing_member
          final state = ref.container.readProviderElement(provider).state;

          return state is _StreamProviderStateMixin<T>
              ? state.proxyStream
              : state.createdValue;
        }, name: name);
}

@sealed
class _AutoDisposeCreatedStreamProvider<T>
    extends AutoDisposeProvider<Stream<T>> {
  _AutoDisposeCreatedStreamProvider(
    RootProvider<Stream<T>, Object?> provider, {
    String? name,
  }) : super((ref) {
          ref.watch(provider);
          // ignore: invalid_use_of_visible_for_testing_member
          final state = ref.container.readProviderElement(provider).state;

          return state is _StreamProviderStateMixin<T>
              ? state.proxyStream
              // Reached when using `.stream` on a `StreamProvider.overrideWithValue`
              : state.createdValue;
        }, name: name);
}
