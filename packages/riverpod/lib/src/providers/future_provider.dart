import 'dart:async';

import 'package:meta/meta.dart';

import '../builder.dart';
import '../framework.dart';
import 'async_notifier.dart';
import 'provider.dart' show Provider;
import 'stream_provider.dart' show StreamProvider;

ProviderElementProxy<AsyncValue<T>, Future<T>> _future<T>(
  _FutureProviderBase<T> that,
) {
  return ProviderElementProxy<AsyncValue<T>, Future<T>>(
    that,
    (element) {
      return FutureHandlerProviderElementMixin.futureNotifierOf(
        element as FutureHandlerProviderElementMixin<T>,
      );
    },
  );
}

/// {@template riverpod.future_provider}
/// A provider that asynchronously creates a value.
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
/// - [FutureProvider.family], to parameterize the http request based on external
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
/// - [AsyncNotifierProvider], similar to [FutureProvider] but also enables
///   modifying the state from the UI.
/// - [Provider], a provider that synchronously creates a value
/// - [StreamProvider], a provider that asynchronously exposes a value that
///   can change over time.
/// - [FutureProvider.family], to create a [FutureProvider] from external parameters
/// - [FutureProvider.autoDispose], to destroy the state of a [FutureProvider] when no longer needed.
/// {@endtemplate}
abstract class _FutureProviderBase<T> extends ProviderBase<AsyncValue<T>> {
  const _FutureProviderBase({
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.name,
    required super.from,
    required super.argument,
    required DebugGetCreateSourceHash? debugGetCreateSourceHash,
    required super.isAutoDispose,
  }) : _debugGetCreateSourceHash = debugGetCreateSourceHash;

  /// Obtains the [Future] associated with a [FutureProvider].
  ///
  /// The instance of [Future] obtained may change over time, if the provider
  /// was recreated (such as when using [Ref.watch]).
  ///
  /// This provider allows using `async`/`await` to easily combine
  /// [FutureProvider] together:
  ///
  /// ```dart
  /// final configsProvider = FutureProvider((ref) async => Configs());
  ///
  /// final productsProvider = FutureProvider((ref) async {
  ///   // Wait for the configurations to resolve
  ///   final configs = await ref.watch(configsProvider.future);
  ///
  ///   // Do something with the result
  ///   return await http.get('${configs.host}/products');
  /// });
  /// ```
  Refreshable<Future<T>> get future;

  FutureOr<T> _create(covariant FutureProviderElement<T> ref);

  final DebugGetCreateSourceHash? _debugGetCreateSourceHash;
  @override
  String? debugGetCreateSourceHash() => _debugGetCreateSourceHash?.call();
}

/// {@macro riverpod.provider_ref_base}
/// - [state], the value currently exposed by this provider.
@Deprecated('will be removed in 3.0.0. Use Ref instead')
abstract class FutureProviderRef<State> implements Ref<AsyncValue<State>> {
  /// Obtains the state currently exposed by this provider.
  ///
  /// Mutating this property will notify the provider listeners.
  ///
  /// Cannot be called while a provider is creating, unless the setter was called first.
  ///
  /// Will return [AsyncLoading] if used during the first initialization.
  /// Subsequent initializations will contain an [AsyncValue] with the previous
  /// state and [AsyncValueX.isRefreshing]/[AsyncValueX.isReloading] set accordingly.
  AsyncValue<State> get state;
  set state(AsyncValue<State> newState);

  /// Obtains the [Future] associated to this provider.
  ///
  /// This is equivalent to doing `ref.read(myProvider.future)`.
  /// See also [FutureProvider.future].
  Future<State> get future;
}

/// {@macro riverpod.future_provider}
class FutureProvider<T> extends _FutureProviderBase<T>
    with
        // ignore: deprecated_member_use_from_same_package
        AlwaysAliveProviderBase<AsyncValue<T>>,
        AlwaysAliveAsyncSelector<T> {
  /// {@macro riverpod.future_provider}
  FutureProvider(
    this._createFn, {
    super.name,
    super.dependencies,
    @Deprecated('Will be removed in 3.0.0') super.from,
    @Deprecated('Will be removed in 3.0.0') super.argument,
    @Deprecated('Will be removed in 3.0.0') super.debugGetCreateSourceHash,
  }) : super(
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          isAutoDispose: false,
        );

  /// An implementation detail of Riverpod
  @internal
  FutureProvider.internal(
    this._createFn, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    super.from,
    super.argument,
    super.isAutoDispose = false,
  });

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeFutureProviderBuilder();

  /// {@macro riverpod.family}
  static const family = FutureProviderFamilyBuilder();

  // ignore: deprecated_member_use_from_same_package
  final Create<FutureOr<T>, FutureProviderRef<T>> _createFn;

  @override
  // ignore: deprecated_member_use_from_same_package
  late final AlwaysAliveRefreshable<Future<T>> future = _future(this);

  @override
  FutureOr<T> _create(FutureProviderElement<T> ref) => _createFn(ref);

  @internal
  @override
  FutureProviderElement<T> createElement() => FutureProviderElement(this);

  /// {@macro riverpod.override_with}
  // ignore: deprecated_member_use_from_same_package
  Override overrideWith(Create<FutureOr<T>, FutureProviderRef<T>> create) {
    return ProviderOverride(
      origin: this,
      override: FutureProvider.internal(
        create,
        from: from,
        argument: argument,
        debugGetCreateSourceHash: null,
        dependencies: null,
        allTransitiveDependencies: null,
        name: null,
      ),
    );
  }
}

/// The element of a [FutureProvider]
@internal
class FutureProviderElement<T> extends ProviderElementBase<AsyncValue<T>>
    with
        FutureHandlerProviderElementMixin<T>
    implements
        // ignore: deprecated_member_use_from_same_package
        FutureProviderRef<T> {
  /// The element of a [FutureProvider]
  @internal
  // ignore: library_private_types_in_public_api
  FutureProviderElement(_FutureProviderBase<T> super._provider);

  @override
  Future<T> get future {
    flush();
    return futureNotifier.value;
  }

  @override
  void create({required bool didChangeDependency}) {
    final provider = this.provider as _FutureProviderBase<T>;

    handleFuture(
      () => provider._create(this),
      didChangeDependency: didChangeDependency,
    );
  }
}

/// The [Family] of a [FutureProvider]
// ignore: deprecated_member_use_from_same_package
class FutureProviderFamily<R, Arg> extends FamilyBase<FutureProviderRef<R>,
    AsyncValue<R>, Arg, FutureOr<R>, FutureProvider<R>> {
  /// The [Family] of a [FutureProvider]
  FutureProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
  }) : super(
          providerFactory: FutureProvider<R>.internal,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          isAutoDispose: false,
          debugGetCreateSourceHash: null,
        );

  /// Implementation detail of the code-generator.
  @internal
  FutureProviderFamily.generator(
    super._createFn, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
  }) : super(
          providerFactory: FutureProvider<R>.internal,
          isAutoDispose: false,
          debugGetCreateSourceHash: null,
        );

  /// {@macro riverpod.override_with}
  Override overrideWith(
    // ignore: deprecated_member_use_from_same_package
    FutureOr<R> Function(FutureProviderRef<R> ref, Arg arg) create,
  ) {
    return FamilyOverrideImpl<AsyncValue<R>, Arg, FutureProvider<R>>(
      this,
      (arg) => FutureProvider<R>.internal(
        (ref) => create(ref, arg),
        from: from,
        argument: arg,
        debugGetCreateSourceHash: null,
        dependencies: null,
        allTransitiveDependencies: null,
        name: null,
      ),
    );
  }
}

/// {@macro riverpod.provider_ref_base}
/// - [FutureProviderRef.state], the value currently exposed by this provider.
@Deprecated('will be removed in 3.0.0. Use Ref instead')
abstract class AutoDisposeFutureProviderRef<State>
    extends FutureProviderRef<State>
    implements AutoDisposeRef<AsyncValue<State>> {}

/// {@macro riverpod.future_provider}
class AutoDisposeFutureProvider<T> extends _FutureProviderBase<T>
    with AsyncSelector<T> {
  /// {@macro riverpod.future_provider}
  AutoDisposeFutureProvider(
    this._createFn, {
    super.name,
    super.dependencies,
    @Deprecated('Will be removed in 3.0.0') super.from,
    @Deprecated('Will be removed in 3.0.0') super.argument,
    @Deprecated('Will be removed in 3.0.0') super.debugGetCreateSourceHash,
  }) : super(
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          isAutoDispose: true,
        );

  /// An implementation detail of Riverpod
  @internal
  AutoDisposeFutureProvider.internal(
    this._createFn, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    super.from,
    super.argument,
    super.isAutoDispose = true,
  });

  /// {@macro riverpod.family}
  static const family = AutoDisposeFutureProviderFamily.new;

  // ignore: deprecated_member_use_from_same_package
  final Create<FutureOr<T>, AutoDisposeFutureProviderRef<T>> _createFn;

  @override
  FutureOr<T> _create(AutoDisposeFutureProviderElement<T> ref) =>
      _createFn(ref);

  @internal
  @override
  AutoDisposeFutureProviderElement<T> createElement() {
    return AutoDisposeFutureProviderElement(this);
  }

  @override
  late final Refreshable<Future<T>> future = _future(this);

  /// {@macro riverpod.override_with}
  Override overrideWith(
    // ignore: deprecated_member_use_from_same_package
    Create<FutureOr<T>, AutoDisposeFutureProviderRef<T>> create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AutoDisposeFutureProvider.internal(
        create,
        from: from,
        argument: argument,
        debugGetCreateSourceHash: null,
        dependencies: null,
        allTransitiveDependencies: null,
        name: null,
      ),
    );
  }
}

/// The [ProviderElementBase] of [AutoDisposeFutureProvider]
@internal
class AutoDisposeFutureProviderElement<T> extends FutureProviderElement<T>
    with
        AutoDisposeProviderElementMixin<AsyncValue<T>>
    implements
        // ignore: deprecated_member_use_from_same_package
        AutoDisposeFutureProviderRef<T> {
  /// The [ProviderElementBase] for [FutureProvider]
  @internal
  AutoDisposeFutureProviderElement(
    AutoDisposeFutureProvider<T> super._provider,
  ) : super();
}

/// The [Family] of an [AutoDisposeFutureProvider]
class AutoDisposeFutureProviderFamily<R, Arg> extends FamilyBase<
    // ignore: deprecated_member_use_from_same_package
    AutoDisposeFutureProviderRef<R>,
    AsyncValue<R>,
    Arg,
    FutureOr<R>,
    AutoDisposeFutureProvider<R>> {
  /// The [Family] of an [AutoDisposeFutureProvider]
  AutoDisposeFutureProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
  }) : super(
          providerFactory: AutoDisposeFutureProvider.internal,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          isAutoDispose: true,
          debugGetCreateSourceHash: null,
        );

  /// Implementation detail of the code-generator.
  @internal
  AutoDisposeFutureProviderFamily.generator(
    super._createFn, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
  }) : super(
          providerFactory: AutoDisposeFutureProvider<R>.internal,
          isAutoDispose: true,
          debugGetCreateSourceHash: null,
        );

  /// {@macro riverpod.override_with}
  Override overrideWith(
    // ignore: deprecated_member_use_from_same_package
    FutureOr<R> Function(AutoDisposeFutureProviderRef<R> ref, Arg arg) create,
  ) {
    return FamilyOverrideImpl<AsyncValue<R>, Arg, AutoDisposeFutureProvider<R>>(
      this,
      (arg) => AutoDisposeFutureProvider<R>.internal(
        (ref) => create(ref, arg),
        from: from,
        argument: arg,
        debugGetCreateSourceHash: null,
        dependencies: null,
        allTransitiveDependencies: null,
        name: null,
      ),
    );
  }
}
