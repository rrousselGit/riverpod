import 'dart:async';

import 'package:collection/collection.dart';

import 'builders.dart';
import 'common.dart';
import 'framework.dart';
import 'framework/family2.dart';
import 'listenable.dart';
import 'result.dart';
import 'synchronous_future.dart';

part 'stream_provider/auto_dispose.dart';
part 'stream_provider/base.dart';

ProviderElementProxy<Future<T>> _future<T>(
  _StreamProviderBase<T> that,
) {
  return ProviderElementProxy<Future<T>>(
    that,
    (element, setListen) {
      if (element is StreamProviderElement<T>) {
        return element._futureNotifier;
      }

      throw UnsupportedError('Unknown element type ${element.runtimeType}');
    },
  );
}

ProviderElementProxy<Stream<T>> _stream<T>(
  _StreamProviderBase<T> that,
) {
  return ProviderElementProxy<Stream<T>>(
    that,
    (element, setListen) {
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
    return true;
  }
}
