import 'dart:async';

import 'package:meta/meta.dart';

import 'internals.dart';

/// Adds [future] and [stream] to providers that emit an [AsyncValue]
extension AlwaysAliveAsyncProviderX<State>
    on AlwaysAliveProviderBase<AsyncValue<State>> {
  /// {@template riverpod.asyncprovider.future}
  /// Exposes a [Future] that resolves with the last value or error emitted.
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
  ///   final configs = await ref.watch(configsProvider.future);
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
  /// On the other hand, if we used [future], our code would
  /// correctly execute:
  ///
  /// ```dart
  /// final exampleProvider = StreamProvider<int>((ref) async* {
  ///   yield 42;
  /// });
  ///
  /// final anotherProvider = FutureProvider<void>((ref) async {
  ///   print(await ref.watch(exampleProvider.future));
  ///   print(await ref.watch(exampleProvider.future));
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
  /// {@endtemplate}
  AlwaysAliveProviderBase<Future<State>> get future =>
      AsyncValueAsFutureProvider(this, from: from, argument: argument);

  /// {@template riverpod.asyncprovider.stream}
  /// Converts the provider into a stream.
  ///
  /// If the transformed provider created a stream, it is important to keep in mind
  /// that the stream obtained and the stream created will be different.
  ///
  /// The stream obtained may change over time if the provider is
  /// re-evaluated, such as when it is using [Ref.watch] and the
  /// provider being listened to changes, or on [ProviderContainer.refresh].
  ///
  /// If the provider was overridden using `overrideWithValue`,
  /// a stream will be generated and manipulated based on the [AsyncValue] used.
  /// {@endtemplate}
  AlwaysAliveProviderBase<Stream<State>> get stream =>
      AsyncValueAsStreamProvider(this, from: from, argument: argument);
}

/// Adds [future] and [stream] to autoDispose providers that emit an [AsyncValue]
extension AutoDisposeAsyncProviderX<State>
    on AutoDisposeProviderBase<AsyncValue<State>> {
  /// {@macro riverpod.asyncprovider.future}
  AutoDisposeProviderBase<Future<State>> get future =>
      AutoDisposeAsyncValueAsFutureProvider(
        this,
        from: from,
        argument: argument,
        cacheTime: cacheTime,
        disposeDelay: disposeDelay,
      );

  /// {@macro riverpod.asyncprovider.stream}
  AutoDisposeProviderBase<Stream<State>> get stream =>
      AutoDisposeAsyncValueAsStreamProvider(
        this,
        from: from,
        argument: argument,
        cacheTime: cacheTime,
        disposeDelay: disposeDelay,
      );
}

///
@protected
class AsyncValueAsStreamProvider<State>
    extends AlwaysAliveProviderBase<Stream<State>> {
  ///
  AsyncValueAsStreamProvider(
    this._provider, {
    required Family? from,
    required Object? argument,
  }) : super(
          name: modifierName(_provider.name, 'stream'),
          from: from,
          argument: argument,
        );

  final AlwaysAliveProviderBase<AsyncValue<State>> _provider;

  @override
  late final List<ProviderOrFamily>? dependencies = [_provider];

  @override
  ProviderBase<Object?> get originProvider => _provider;

  @override
  AsyncValueAsStreamProviderElement<State> createElement() {
    return AsyncValueAsStreamProviderElement(this);
  }

  @override
  bool updateShouldNotify(
    Stream<State> previousState,
    Stream<State> newState,
  ) {
    return true;
  }

  @override
  bool operator ==(Object other) {
    return other is AsyncValueAsStreamProvider<State> &&
        other._provider == _provider;
  }

  @override
  int get hashCode => _provider.hashCode;
}

/// The element for [AsyncValueAsStreamProvider].
class AsyncValueAsStreamProviderElement<State>
    extends ProviderElementBase<Stream<State>> {
  /// The element for [AsyncValueAsStreamProvider].
  AsyncValueAsStreamProviderElement(this.provider);

  @override
  final AsyncValueAsStreamProvider<State> provider;

  @override
  Stream<State> create() {
    return _asyncValueToStream(provider._provider, this);
  }
}

/// Transforms a Provider<AsyncValue<T>> into Provider<Stream<T>>
@protected
class AutoDisposeAsyncValueAsStreamProvider<State>
    extends AutoDisposeProviderBase<Stream<State>> {
  ///
  AutoDisposeAsyncValueAsStreamProvider(
    this._provider, {
    required Family? from,
    required Object? argument,
    required Duration? cacheTime,
    required Duration? disposeDelay,
  }) : super(
          name: modifierName(_provider.name, 'stream'),
          from: from,
          argument: argument,
          cacheTime: cacheTime,
          disposeDelay: disposeDelay,
        );

  final AutoDisposeProviderBase<AsyncValue<State>> _provider;

  @override
  late final List<ProviderOrFamily>? dependencies = [_provider];

  @override
  ProviderBase<Object?> get originProvider => _provider;

  @override
  AutoDisposeAsyncValueAsStreamProviderElement<State> createElement() {
    return AutoDisposeAsyncValueAsStreamProviderElement(this);
  }

  @override
  bool updateShouldNotify(
    Stream<State> previousState,
    Stream<State> newState,
  ) {
    return true;
  }

  @override
  bool operator ==(Object other) {
    return other is AutoDisposeAsyncValueAsStreamProvider<State> &&
        other._provider == _provider;
  }

  @override
  int get hashCode => _provider.hashCode;
}

/// The element for [AutoDisposeAsyncValueAsStreamProvider].
class AutoDisposeAsyncValueAsStreamProviderElement<State>
    extends AutoDisposeProviderElementBase<Stream<State>> {
  /// The element for [AutoDisposeAsyncValueAsStreamProvider].
  AutoDisposeAsyncValueAsStreamProviderElement(this.provider);

  @override
  final AutoDisposeAsyncValueAsStreamProvider<State> provider;

  @override
  Stream<State> create() {
    return _asyncValueToStream(provider._provider, this);
  }
}

Stream<State> _asyncValueToStream<State>(
  ProviderBase<AsyncValue<State>> provider,
  ProviderElementBase<Stream<State>> ref,
) {
  StreamController<State>? controller;

  StreamController<State> getController() {
    if (controller == null) {
      // Using a non-broadcast controller followed by asBroadcastStream instead
      // of directly creating a broadcast controller so that `add`/`addError` calls
      // are queued. This ensures that listeners will properly receive the first value.
      controller = StreamController<State>();
      ref.setState(
        controller!.stream.asBroadcastStream(
          onListen: (sub) => sub.resume(),
          onCancel: (sub) => sub.pause(),
        ),
      );
    }
    return controller!;
  }

  ref.onDispose(() => controller?.close());

  void listener(AsyncValue<State>? previous, AsyncValue<State> value) {
    if (value.isLoading || value.isRefreshing) {
      controller?.close();
      controller = null;
      // will call ref.state =
      getController();
    }

    value.map(
      loading: (_) {
        // already taken care of above
      },
      data: (value) {
        if (!value.isRefreshing) getController().add(value.value);
      },
      error: (value) {
        if (!value.isRefreshing) {
          getController().addError(value.error, value.stackTrace);
        }
      },
    );
  }

  ref.listen<AsyncValue<State>>(provider, listener, fireImmediately: true);

  return ref.requireState;
}

///
@protected
class AsyncValueAsFutureProvider<State>
    extends AlwaysAliveProviderBase<Future<State>> {
  ///
  AsyncValueAsFutureProvider(
    this._provider, {
    required Family? from,
    required Object? argument,
  }) : super(
          name: modifierName(_provider.name, 'future'),
          from: from,
          argument: argument,
        );

  final AlwaysAliveProviderBase<AsyncValue<State>> _provider;

  @override
  late final List<ProviderOrFamily>? dependencies = [_provider];

  @override
  ProviderBase<Object?> get originProvider => _provider;

  @override
  bool updateShouldNotify(
    Future<State> previousState,
    Future<State> newState,
  ) {
    return true;
  }

  @override
  AsyncValueAsFutureProviderElement<State> createElement() {
    return AsyncValueAsFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AsyncValueAsFutureProvider<State> &&
        other._provider == _provider;
  }

  @override
  int get hashCode => _provider.hashCode;
}

/// The element for [AutoDisposeAsyncValueAsFutureProvider].
class AsyncValueAsFutureProviderElement<State>
    extends ProviderElementBase<Future<State>> {
  /// The element for [AsyncValueAsFutureProvider].
  AsyncValueAsFutureProviderElement(this.provider);

  @override
  final AsyncValueAsFutureProvider<State> provider;

  @override
  Future<State> create() => _asyncValueAsFuture(provider._provider, this);
}

///
@protected
class AutoDisposeAsyncValueAsFutureProvider<State>
    extends AutoDisposeProviderBase<Future<State>> {
  ///
  AutoDisposeAsyncValueAsFutureProvider(
    this._provider, {
    required Family? from,
    required Object? argument,
    required Duration? cacheTime,
    required Duration? disposeDelay,
  }) : super(
          name: modifierName(_provider.name, 'future'),
          from: from,
          argument: argument,
          cacheTime: cacheTime,
          disposeDelay: disposeDelay,
        );

  final AutoDisposeProviderBase<AsyncValue<State>> _provider;

  @override
  late final List<ProviderOrFamily>? dependencies = [_provider];

  @override
  ProviderBase<Object?> get originProvider => _provider;

  @override
  bool updateShouldNotify(
    Future<State> previousState,
    Future<State> newState,
  ) {
    return true;
  }

  @override
  AutoDisposeAsyncValueAsFutureProviderElement<State> createElement() {
    return AutoDisposeAsyncValueAsFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AutoDisposeAsyncValueAsFutureProvider<State> &&
        other._provider == _provider;
  }

  @override
  int get hashCode => _provider.hashCode;
}

/// The element for [AutoDisposeAsyncValueAsFutureProvider].
class AutoDisposeAsyncValueAsFutureProviderElement<State>
    extends AutoDisposeProviderElementBase<Future<State>> {
  /// The element for [AutoDisposeAsyncValueAsFutureProvider].
  AutoDisposeAsyncValueAsFutureProviderElement(this.provider);

  @override
  final AutoDisposeAsyncValueAsFutureProvider<State> provider;

  @override
  Future<State> create() => _asyncValueAsFuture(provider._provider, this);
}

Future<State> _asyncValueAsFuture<State>(
  ProviderBase<AsyncValue<State>> provider,
  ProviderElementBase<Future<State>> ref,
) {
  Completer<State>? loadingCompleter;

  ref.onDispose(() {
    if (loadingCompleter != null) {
      loadingCompleter!.completeError(
        StateError(
          'The provider $provider was disposed before a value was emitted.',
        ),
      );
    }
  });

  void listener(AsyncValue<State>? previous, AsyncValue<State> value) {
    if (value.isLoading || value.isRefreshing) {
      if (loadingCompleter == null) {
        loadingCompleter = Completer<State>();
        ref.setState(
          // TODO test ignore
          loadingCompleter!.future..ignore(),
        );
      }
    }

    value.map(
      loading: (_) {
        // already taken care of above
      },
      data: (data) {
        // already taken care of above
        if (data.isRefreshing) return;

        if (loadingCompleter != null) {
          loadingCompleter!.complete(data.value);
          // allow follow-up data calls to go on the 'else' branch
          loadingCompleter = null;
        } else {
          ref.setState(Future<State>.value(data.value));
        }
      },
      error: (error) {
        // already taken care of above
        if (error.isRefreshing) return;

        if (loadingCompleter != null) {
          loadingCompleter!.completeError(error.error, error.stackTrace);
          // allow follow-up error calls to go on the 'else' branch
          loadingCompleter = null;
        } else {
          ref.setState(Future<State>.error(error.error, error.stackTrace));
        }
      },
    );
  }

  ref.listen<AsyncValue<State>>(provider, listener, fireImmediately: true);

  return ref.requireState;
}
