import 'dart:async';

import 'package:meta/meta.dart';

import '../builder.dart';
import '../core/async_value.dart';
import '../framework.dart';
import 'async_notifier.dart';
import 'provider.dart' show Provider;
import 'stream_provider.dart' show StreamProvider;

/// Implementation detail of `riverpod_generator`.
/// Do not use, as this may be removed at any time.
@internal
base mixin $FutureProvider<StateT>
    on $FunctionalProvider<AsyncValue<StateT>, FutureOr<StateT>> {
  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<StateT> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $AsyncValueProvider<StateT>(value),
    );
  }
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
final class FutureProvider<StateT>
    extends $FunctionalProvider<AsyncValue<StateT>, FutureOr<StateT>>
    with
        $FutureModifier<StateT>,
        $FutureProvider<StateT>,
        LegacyProviderMixin<AsyncValue<StateT>> {
  /// {@macro riverpod.future_provider}
  FutureProvider(
    this._create, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
    super.retry,
  }) : super(
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          from: null,
          argument: null,
        );

  /// An implementation detail of Riverpod
  @internal
  FutureProvider.internal(
    this._create, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.from,
    required super.argument,
    required super.isAutoDispose,
    required super.retry,
  });

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeFutureProviderBuilder();

  /// {@macro riverpod.family}
  static const family = FutureProviderFamilyBuilder();

  final Create<FutureOr<StateT>> _create;

  @internal
  @override
  FutureOr<StateT> create(Ref ref) => _create(ref);

  @internal
  @override
  $FutureProviderElement<StateT> $createElement($ProviderPointer pointer) {
    return $FutureProviderElement(pointer);
  }
}

/// The element of a [FutureProvider]
/// Implementation detail of `riverpod_generator`. Do not use.
@internal
class $FutureProviderElement<StateT>
    extends $FunctionalProviderElement<AsyncValue<StateT>, FutureOr<StateT>>
    with FutureModifierElement<StateT> {
  /// The element of a [FutureProvider]
  /// Implementation detail of `riverpod_generator`. Do not use.
  $FutureProviderElement(super.pointer);

  @override
  WhenComplete create(Ref ref) {
    return handleFuture(ref, () => provider.create(ref));
  }

  @override
  bool updateShouldNotify(
    AsyncValue<StateT> previous,
    AsyncValue<StateT> next,
  ) {
    return FutureModifierElement.handleUpdateShouldNotify(
      previous,
      next,
    );
  }
}

/// The [Family] of a [FutureProvider]
class FutureProviderFamily<StateT, ArgT> extends FunctionalFamily<
    AsyncValue<StateT>, ArgT, FutureOr<StateT>, FutureProvider<StateT>> {
  FutureProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
    super.isAutoDispose = false,
    super.retry,
  }) : super(
          providerFactory: FutureProvider<StateT>.internal,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );

  /// Implementation detail of the code-generator.
  @internal
  FutureProviderFamily.internal(
    super._createFn, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.isAutoDispose,
    required super.retry,
  }) : super(providerFactory: FutureProvider<StateT>.internal);
}
