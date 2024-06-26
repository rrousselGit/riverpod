import 'dart:async';

import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart' hide Retry;

part 'matrix/async_notifier_provider.dart';
part 'matrix/stream_notifier_provider.dart';
part 'matrix/notifier_provider.dart';

class TestMatrix<T extends TestFactory<Object?>> {
  TestMatrix(this.values);

  final Map<String, T> values;

  void createGroup(void Function(T factory) cb) {
    for (final entry in values.entries) {
      group(entry.key, () => cb(entry.value));
    }
  }
}

class TestFactory<T> {
  TestFactory({
    required this.value,
    required this.isAutoDispose,
    required this.isFamily,
  });

  final T value;
  final bool isAutoDispose;
  final bool isFamily;
}

typedef ProviderFactory<BaseT, ProviderT, RefT>
    = ProviderT Function([Object? arg]) Function(
  BaseT Function(RefT ref, Object? arg) create, {
  String? name,
  Iterable<ProviderOrFamily>? dependencies,
  Retry? retry,
});

extension $Modifiers on ProviderBase<Object?> {
  Refreshable<Object?>? get notifier {
    final that = this;
    return switch (that) {
      $ClassProvider() => that.notifier,
      _ => null,
    };
  }

  Refreshable<FutureOr<Object?>>? get future {
    final that = this;
    return switch (that) {
      $FutureModifier() => that.future,
      _ => null,
    };
  }
}

final providerFactory =
    <ProviderFactory<Object?, Provider<Object?>, Ref<Object?>>>[
  (create, {name, dependencies, retry}) => ([arg]) {
        return Provider<Object?>(
          (ref) => create(ref, arg),
          name: name,
          dependencies: dependencies,
          retry: retry,
        );
      },
  (create, {name, dependencies, retry}) => ([arg]) {
        return Provider.autoDispose<Object?>(
          (ref) => create(ref, arg),
          name: name,
          dependencies: dependencies,
          retry: retry,
        );
      },
  (create, {name, dependencies, retry}) => ([arg]) {
        return Provider.family<Object?, Object?>(
          (ref, arg) => create(ref, arg),
          name: name,
          dependencies: dependencies,
          retry: retry,
        )(arg);
      },
  (create, {name, dependencies, retry}) => ([arg]) {
        return Provider.autoDispose.family<Object?, Object?>(
          (ref, arg) => create(ref, arg),
          name: name,
          dependencies: dependencies,
          retry: retry,
        )(arg);
      },
];

final futureProviderFactories =
    <ProviderFactory<FutureOr<Object?>, FutureProvider<Object?>, Ref<Object?>>>[
  (create, {name, dependencies, retry}) => ([arg]) {
        return FutureProvider<Object?>(
          (ref) => create(ref, arg),
          name: name,
          dependencies: dependencies,
          retry: retry,
        );
      },
  (create, {name, dependencies, retry}) => ([arg]) {
        return FutureProvider.autoDispose<Object?>(
          (ref) => create(ref, arg),
          name: name,
          dependencies: dependencies,
          retry: retry,
        );
      },
  (create, {name, dependencies, retry}) => ([arg]) {
        return FutureProvider.family<Object?, Object?>(
          (ref, arg) => create(ref, arg),
          name: name,
          dependencies: dependencies,
          retry: retry,
        )(arg);
      },
  (create, {name, dependencies, retry}) => ([arg]) {
        return FutureProvider.autoDispose.family<Object?, Object?>(
          (ref, arg) => create(ref, arg),
          name: name,
          dependencies: dependencies,
          retry: retry,
        )(arg);
      },
];

final streamProviderFactories =
    <ProviderFactory<Stream<Object?>, StreamProvider<Object?>, Ref<Object?>>>[
  (create, {name, dependencies, retry}) => ([arg]) {
        return StreamProvider<Object?>(
          (ref) => create(ref, arg),
          name: name,
          dependencies: dependencies,
          retry: retry,
        );
      },
  (create, {name, dependencies, retry}) => ([arg]) {
        return StreamProvider.autoDispose<Object?>(
          (ref) => create(ref, arg),
          name: name,
          dependencies: dependencies,
          retry: retry,
        );
      },
  (create, {name, dependencies, retry}) => ([arg]) {
        return StreamProvider.family<Object?, Object?>(
          (ref, arg) => create(ref, arg),
          name: name,
          dependencies: dependencies,
          retry: retry,
        )(arg);
      },
  (create, {name, dependencies, retry}) => ([arg]) {
        return StreamProvider.autoDispose.family<Object?, Object?>(
          (ref, arg) => create(ref, arg),
          name: name,
          dependencies: dependencies,
          retry: retry,
        )(arg);
      },
];

final asyncProviderFactory =
    <ProviderFactory<Object?, ProviderBase<AsyncValue<Object?>>, Ref<Object?>>>[
  for (final factory in futureProviderFactories)
    (create, {name, dependencies, retry}) => factory(
          (ref, arg) async => create(ref, arg),
          name: name,
          dependencies: dependencies,
          retry: retry,
        ),
  for (final factory in streamProviderFactories)
    (create, {name, dependencies, retry}) => factory(
          (ref, arg) => Stream.value(create(ref, arg)),
          name: name,
          dependencies: dependencies,
          retry: retry,
        ),
];
