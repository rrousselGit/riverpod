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
typedef Create<CreatedT, RefT extends Ref<Object?>> = CreatedT Function(
  RefT ref,
);

/// A callback used to catches errors
@internal
typedef OnError = void Function(Object, StackTrace);

/// A base class for _all_ providers.
@immutable
// Marked as "base" because linters/generators rely on fields on const provider instances.
abstract base class ProviderBase<StateT> extends ProviderOrFamily
    with ProviderListenable<StateT>
    implements Refreshable<StateT>, _ProviderOverride {
  /// A base class for _all_ providers.
  const ProviderBase({
    required super.name,
    required this.from,
    required this.argument,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.isAutoDispose,
  }) : assert(
          from == null || allTransitiveDependencies == null,
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

  @override
  ProviderSubscription<StateT> addListener(
    Node node,
    void Function(StateT? previous, StateT next) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
  }) {
    onError ??= Zone.current.handleUncaughtError;

    final element = node.readProviderElement(this);

    element.flush();
    if (fireImmediately) {
      _handleFireImmediately(
        element.stateResult!,
        listener: listener,
        onError: onError,
      );
    }

    // Calling before initializing the subscription,
    // to ensure that "hasListeners" represents the state _before_
    // the listener is added
    element._onListen();

    return _ProviderStateSubscription<StateT>(
      node,
      listenedElement: element,
      listener: (prev, next) => listener(prev as StateT?, next as StateT),
      onError: onError,
    );
  }

  @override
  StateT read(Node node) {
    final element = node.readProviderElement(this);

    element.flush();

    // In case `read` was called on a provider that has no listener
    element._mayNeedDispose();

    return element.requireState;
  }

  /// An internal method that defines how a provider behaves.
  @visibleForOverriding
  ProviderElement<StateT> $createElement(ProviderContainer container);

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

/// A mixin that implements some methods for non-generic providers.
@internal
base mixin LegacyProviderMixin<StateT> on ProviderBase<StateT> {
  @override
  int get hashCode {
    if (from == null) return super.hashCode;

    return from.hashCode ^ argument.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (from == null) return identical(other, this);

    return other.runtimeType == runtimeType &&
        other is ProviderBase<StateT> &&
        other.from == from &&
        other.argument == argument;
  }

  @internal
  @override
  String? debugGetCreateSourceHash() => null;
}