import 'dart:async';

import 'package:meta/meta.dart';

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

abstract class _StreamProviderBase<T> extends ProviderBase<AsyncValue<T>> {
  const _StreamProviderBase({
    required super.allTransitiveDependencies,
    required super.dependencies,
    required super.name,
    required super.from,
    required super.argument,
    required super.debugGetCreateSourceHash,
  });

  ProviderListenable<Future<T>> get future;

  Stream<T> _create(covariant StreamProviderElement<T> ref);
}
