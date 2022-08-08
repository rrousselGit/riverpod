import 'dart:async';

import 'builders.dart';
import 'common.dart';
import 'framework.dart';
import 'framework/family2.dart';
import 'listenable.dart';
import 'result.dart';
import 'synchronous_future.dart';

part 'future_provider/auto_dispose.dart';
part 'future_provider/base.dart';

ProviderElementProxy<Future<T>> _future<T>(
  _FutureProviderBase<T> that,
) {
  return ProviderElementProxy<Future<T>>(
    that,
    (element, setListen) {
      if (element is FutureProviderElement<T>) {
        return element._futureNotifier;
      }

      throw UnsupportedError('Unknown element type ${element.runtimeType}');
    },
  );
}

ProviderElementProxy<Stream<T>> _stream<T>(
  _FutureProviderBase<T> that,
) {
  return ProviderElementProxy<Stream<T>>(
    that,
    (element, setListen) {
      if (element is FutureProviderElement<T>) {
        return element._streamNotifier;
      }

      throw UnsupportedError('Unknown element type ${element.runtimeType}');
    },
  );
}

/// {@template riverpod.futureprovider}
/// A provider that asynchronously creates a single value.
///
/// [FutureProvider] can be considered as a combination of [Provider] and
/// `FutureBuilder`.
/// By using [FutureProvider], the UI will be able to read the state of the
/// future synchronously, handle the loading/error states, and rebuild when the
/// future completes.
///
/// A common use-case for [FutureProvider] is to represent an asynchronous operation
/// such as reading a file or making an HTTP request, that is then listened to by the UI.
///
/// It can then be combined with:
/// - [FutureProvider.family], for parameterizing the http request based on external
///   parameters, such as fetching a `User` from its id.
/// - [FutureProvider.autoDispose], to cancel the HTTP request if the user
///   leaves the screen before the [Future] completed.
///
/// ## Usage example: reading a configuration file
///
/// [FutureProvider] can be a convenient way to expose a `Configuration` object
/// created by reading a JSON file.
///
/// Creating the configuration would be done with your typical async/await
/// syntax, but inside the provider.
/// Using Flutter's asset system, this would be:
///
/// ```dart
/// final configProvider = FutureProvider<Configuration>((ref) async {
///   final content = json.decode(
///     await rootBundle.loadString('assets/configurations.json'),
///   ) as Map<String, Object?>;
///
///   return Configuration.fromJson(content);
/// });
/// ```
///
/// Then, the UI can listen to configurations like so:
///
/// ```dart
/// Widget build(BuildContext context, WidgetRef ref) {
///   AsyncValue<Configuration> config = ref.watch(configProvider);
///
///   return config.when(
///     loading: () => const CircularProgressIndicator(),
///     error: (err, stack) => Text('Error: $err'),
///     data: (config) {
///       return Text(config.host);
///     },
///   );
/// }
/// ```
///
/// This will automatically rebuild the UI when the [Future] completes.
///
/// As you can see, listening to a [FutureProvider] inside a widget returns
/// an [AsyncValue] – which allows handling the error/loading states.
///
/// See also:
///
/// - [Provider], a provider that synchronously creates a value
/// - [StreamProvider], a provider that asynchronously exposes a value that
///   can change over time.
/// - [FutureProvider.family], to create a [FutureProvider] from external parameters
/// - [FutureProvider.autoDispose], to destroy the state of a [FutureProvider] when no longer needed.
/// {@endtemplate}
mixin _FutureProviderElementMixin<State>
    on ProviderElementBase<AsyncValue<State>> {}

abstract class _FutureProviderBase<T> extends ProviderBase<AsyncValue<T>> {
  _FutureProviderBase({
    required this.dependencies,
    required super.name,
    required super.from,
    required super.argument,
    required super.cacheTime,
    required super.disposeDelay,
  });

  @override
  final List<ProviderOrFamily>? dependencies;

  ProviderListenable<Future<T>> get future;
  ProviderListenable<Stream<T>> get stream;

  FutureOr<T> _create(covariant FutureProviderElement<T> ref);

  @override
  bool updateShouldNotify(AsyncValue<T> previousState, AsyncValue<T> newState) {
    return true;
  }
}
