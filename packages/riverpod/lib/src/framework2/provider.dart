part of 'framework.dart';

abstract class ProviderListenableOrFamily {}

abstract class ProviderOrFamily {}

abstract base class Family implements ProviderOrFamily {
  const Family();
}

/// {@template debug_provider_source}
/// Debug information about where a provider was defined.
///
/// This can enable better error messages and better debugging experience.
/// For instance, it enables the devtool to open the IDE at the location
/// where the provider was defined.
/// {@endtemplate}
@internal
class DebugProviderSource {
  const DebugProviderSource({
    required this.name,
    required this.file,
    required this.line,
    required this.column,
    required this.hash,
  });

  /// The name of the provider, as in the code.
  final String name;

  /// The absolute path to the file where this provider was defined.
  final String file;

  /// The line where this provider was defined.
  final int line;

  /// The column where this provider was defined.
  final int column;

  /// A hash of the source of this provider.
  ///
  /// This is used to determine if a provider was changed by a hot-reload.
  final String hash;
}

@deprecated
const renameProviderBaseToPRovider = Object();

@immutable
@renameProviderBaseToPRovider
abstract base class Provider<StateT>
    with ProviderListenable<StateT>
    implements ProviderOrFamily {
  const Provider({
    required this.name,
    required this.from,
    required this.arguments,
    required this.debugSource,
    required this.dependencies,
    required this.allTransitiveDependencies,
    required this.isAlwaysAlive,
  });

  /// Whether the provider isn't automatically disposed when all its listeners
  /// are removed.
  ///
  /// This is used for linting purposes.
  final bool isAlwaysAlive;

  /// A debug name for this provider.
  ///
  /// This changes error messages, [toString] and other debug messages.
  final String name;

  /// The "family" that owns this provider.
  ///
  /// A provider is part of a family if it has parameters.
  /// In which case, the parameters used can be retrieved with [arguments].
  final Family? from;

  /// Debug information about where this provider was defined.
  ///
  /// This is prefilled by the code-generator.
  final DebugProviderSource? debugSource;

  /// {@macro provider_arguments}
  @Deprecated('Use arguments')
  Object? get argument => arguments;

  /// {@template provider_arguments}
  /// The arguments used to create this provider.
  ///
  /// If created using the code-generator, this will be a [Record] of all
  /// the parameters used to create this provider.
  /// {@endtemplate}
  final Object? arguments;

  final List<ProviderOrFamily>? dependencies;
  final List<ProviderOrFamily>? allTransitiveDependencies;

  Refreshable<FutureOr<Object?>> get future;
  Refreshable<Future<Object?>> get syncFuture;
  Refreshable<Object?> get notifier;

  /// A method that always create a new [ProviderElement].
  @visibleForOverriding
  ProviderElement<Object?> createElement(ProviderContainer container);

  /// A method for fast lookup of the [ProviderElement] associated to this provider.
  ///
  /// Providers that cannot be "scoped" may obtain their [ProviderElement] from
  /// the "root" [ProviderContainer].
  ///
  /// Providers may override this for even faster lookup, such as by caching
  /// the [ProviderElement] in a static field.
  @protected
  ProviderElement<Object?> getElement(
    ProviderContainer container, {
    required DebugDependentSource? debugDependentSource,
  }) {
    return container._insertProvider(
      this,
      debugDependentSource: debugDependentSource,
    );
  }

  @visibleForOverriding
  @override
  ProviderSubscription<StateT> addListener(
    ProviderContainer container,
    void Function(StateT? previous, StateT next) listener, {
    required bool fireImmediately,
    required void Function(Object error, StackTrace stackTrace)? onError,
    required DebugDependentSource? debugDependentSource,
    required ProviderElement<Object?>? dependent,
    required void Function()? onCancel,
  });
}
