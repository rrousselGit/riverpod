import 'dart:async';

import 'async_notifier.dart';
import 'builders.dart';
import 'common.dart';
import 'framework.dart';
import 'future_provider.dart' show FutureProvider;
import 'listenable.dart';
import 'provider.dart' show Provider;
import 'result.dart';

part 'stream_provider/auto_dispose.dart';
part 'stream_provider/base.dart';

ProviderElementProxy<AsyncValue<T>, Future<T>> _future<T>(
  _StreamProviderBase<T> that,
) {
  return ProviderElementProxy<AsyncValue<T>, Future<T>>(
    that,
    (element) => FutureHandlerProviderElementMixin.futureNotifierOf(
      element as FutureHandlerProviderElementMixin<T>,
    ),
  );
}

ProviderElementProxy<AsyncValue<T>, Stream<T>> _stream<T>(
  _StreamProviderBase<T> that,
) {
  return ProviderElementProxy<AsyncValue<T>, Stream<T>>(
    that,
    (element) {
      return (element as StreamProviderElement<T>)._streamNotifier;
    },
  );
}

abstract class _StreamProviderBase<T> extends ProviderBase<AsyncValue<T>> {
  _StreamProviderBase({
    required this.dependencies,
    required super.name,
    required super.from,
    required super.argument,
    required super.debugGetCreateSourceHash,
  });

  @override
  final List<ProviderOrFamily>? dependencies;

  ProviderListenable<Future<T>> get future;
  ProviderListenable<Stream<T>> get stream;

  Stream<T> _create(covariant StreamProviderElement<T> ref);
}
