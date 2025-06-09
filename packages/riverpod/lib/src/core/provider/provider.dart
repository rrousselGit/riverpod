part of '../../framework.dart';

/// A callback used by providers to create the value exposed.
///
/// If an exception is thrown within that callback, all attempts at reading
/// the provider associated with the given callback will throw.
///
/// The parameter [ref] can be used to interact with other providers
/// and the life-cycles of this provider.
///
/// See also:
///
/// - [Ref], which exposes the methods to read other providers.
/// - [Provider], a provider that uses [Create] to expose an immutable value.
@internal
typedef Create<CreatedT> = CreatedT Function(Ref ref);

/// A callback used to catches errors
@internal
typedef OnError = void Function(Object error, StackTrace stackTrace);

/// A base class for _all_ providers.
@immutable
@publicInMisc
sealed class ProviderBase<StateT> extends ProviderOrFamily
    implements
        ProviderListenable<StateT>,
        Refreshable<StateT>,
        _ProviderOverride {
  /// A base class for _all_ providers.
  const ProviderBase({
    required super.name,
    required this.from,
    required this.argument,
    required super.dependencies,
    required super.$allTransitiveDependencies,
    required super.isAutoDispose,
    required super.retry,
  }) : assert(
          from == null || $allTransitiveDependencies == null,
          'When from a family, providers cannot specify dependencies.',
        );

  /// If this provider was created with the `.family` modifier, [from] is the `.family` instance.
  @override
  final Family? from;

  /// If this provider was created with the `.family` modifier, [argument] is
  /// the variable that was used.
  ///
  /// On generated providers, this will be a record of all arguments.
  final Object? argument;

  /// An internal method that defines how a provider behaves.
  /// @nodoc
  @visibleForOverriding
  ElementWithFuture<StateT, Object?> $createElement($ProviderPointer pointer);

  /// A debug-only function for obtaining a hash of the source code of the
  /// initialization function.
  ///
  /// If after a hot-reload this function returns a different result, the
  /// provider will be re-executed.
  ///
  /// This method only returns a non-null value when using `riverpod_generator`.
  // This is voluntarily not implemented by default, to force all non-generated
  // providers to apply the LegacyProviderMixin.
  /// @nodoc
  @internal
  String? debugGetCreateSourceHash();

  @override
  String toString() {
    var leading = '';
    if (from != null) {
      leading = '($argument)';
    }

    String label;
    if (name case final name?) {
      label = name;
    } else {
      label = describeIdentity(this);
    }

    return '$label$leading';
  }
}

/// A base class for _all_ providers.
@immutable
@internal
abstract final class $ProviderBaseImpl<StateT, ValueT>
    extends ProviderBase<StateT>
    with ProviderListenableWithOrigin<StateT, StateT> {
  /// A base class for _all_ providers.
  const $ProviderBaseImpl({
    required super.name,
    required super.from,
    required super.argument,
    required super.dependencies,
    required super.$allTransitiveDependencies,
    required super.isAutoDispose,
    required super.retry,
  });

  @override
  ProviderSubscriptionWithOrigin<StateT, StateT> _addListener(
    Node source,
    void Function(StateT? previous, StateT next) listener, {
    required void Function(Object error, StackTrace stackTrace) onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool weak,
  }) {
    final element = source.readProviderElement(this);

    if (!weak) element.flush();

    return ProviderStateSubscription<StateT, ValueT>(
      source: source,
      listenedElement: element,
      weak: weak,
      listener: listener,
      onError: onError,
    );
  }

  @override
  @visibleForOverriding
  ElementWithFuture<StateT, ValueT> $createElement($ProviderPointer pointer);
}

/// A mixin that implements some methods for non-generic providers.
@internal
base mixin LegacyProviderMixin<StateT, ValueT>
    on $ProviderBaseImpl<StateT, ValueT> {
  @override
  int get hashCode {
    if (from == null) return super.hashCode;

    return from.hashCode ^ argument.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (from == null) return identical(other, this);

    return other.runtimeType == runtimeType &&
        other is $ProviderBaseImpl<StateT, ValueT> &&
        other.from == from &&
        other.argument == argument;
  }

  /// @nodoc
  @internal
  @override
  String? debugGetCreateSourceHash() => null;
}
