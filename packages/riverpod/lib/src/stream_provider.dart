import 'dart:async';

import 'builders.dart';
import 'common.dart';
import 'framework.dart';
import 'future_provider.dart' show FutureProvider;
import 'listenable.dart';
import 'provider.dart' show Provider;
import 'result.dart';
import 'synchronous_future.dart';

part 'stream_provider/auto_dispose.dart';
part 'stream_provider/base.dart';

ProviderElementProxy<AsyncValue<T>, Future<T>> _future<T>(
  _StreamProviderBase<T> that,
) {
  return ProviderElementProxy<AsyncValue<T>, Future<T>>(
    that,
    (element) {
      if (element is StreamProviderElement<T>) {
        return element._futureNotifier;
      }

      throw UnsupportedError('Unknown element type ${element.runtimeType}');
    },
  );
}

ProviderElementProxy<AsyncValue<T>, Stream<T>> _stream<T>(
  _StreamProviderBase<T> that,
) {
  return ProviderElementProxy<AsyncValue<T>, Stream<T>>(
    that,
    (element) {
      if (element is StreamProviderElement<T>) {
        return element._streamNotifier;
      }

      throw UnsupportedError('Unknown element type ${element.runtimeType}');
    },
  );
}

abstract class _StreamProviderBase<T> extends ProviderBase<AsyncValue<T>> {
  _StreamProviderBase({
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

  Stream<T> _create(covariant StreamProviderElement<T> ref);

  @override
  bool updateShouldNotify(AsyncValue<T> previousState, AsyncValue<T> newState) {
    final wasLoading = previousState is AsyncLoading;
    final isLoading = newState is AsyncLoading;

    if (wasLoading || isLoading) return wasLoading != isLoading;

    return true;
  }
}
