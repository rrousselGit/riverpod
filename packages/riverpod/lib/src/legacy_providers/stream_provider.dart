import 'dart:async';

import 'package:meta/meta.dart';

import 'async_notifier.dart';
import 'builders.dart';
import '../core/async_value.dart';
import '../framework.dart';
import 'future_provider.dart' show FutureProvider;
import '../common/listenable.dart';
import 'provider.dart' show Provider;
import '../common/result.dart';

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

abstract class _StreamProviderBase<T> extends ProviderBase<AsyncValue<T>>
    with AsyncSelector<T> {
  const _StreamProviderBase({
    required super.allTransitiveDependencies,
    required super.dependencies,
    required super.name,
    required super.from,
    required super.argument,
    required super.debugGetCreateSourceHash,
  });

  Stream<T> _create(covariant StreamProviderElement<T> ref);
}
