part of '../framework.dart';

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
typedef Create<T, R extends Ref> = T Function(R ref);

/// A callback used to catches errors
@internal
typedef OnError = void Function(Object, StackTrace);

/// A typedef for `debugGetCreateSourceHash` parameters.
@internal
typedef DebugGetCreateSourceHash = String Function();

/// A base class for _all_ providers.
@immutable
abstract class ProviderBase<State> extends ProviderOrFamily
    with ProviderListenable<State>
    implements Refreshable<State>, ProviderOverride {
  /// A base class for _all_ providers.
  const ProviderBase({
    required super.name,
    required this.from,
    required this.argument,
    required this.debugGetCreateSourceHash,
    required super.dependencies,
    required super.allTransitiveDependencies,
  });

  /// {@template riverpod.create_source_hash}
  /// A debug-only function for obtaining a hash of the source code of the
  /// initialization function.
  ///
  /// If after a hot-reload this function returns a different result, the
  /// provider will be re-executed.
  ///
  /// This variable is only set by `riverpod_generator`.
  /// {@endtemplate}
  @internal
  final DebugGetCreateSourceHash? debugGetCreateSourceHash;

  /// If this provider was created with the `.family` modifier, [from] is the `.family` instance.
  @override
  final Family? from;

  /// If this provider was created with the `.family` modifier, [argument] is
  /// the variable that was used.
  ///
  /// On generated providers, this will be a record of all arguments.
  final Object? argument;

  @override
  ProviderSubscription<State> addListener(
    Node node,
    void Function(State? previous, State next) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
  }) {
    onError ??= Zone.current.handleUncaughtError;

    final element = node.readProviderElement(this);

    element.flush();
    if (fireImmediately) {
      _handleFireImmediately(
        element.getState()!,
        listener: listener,
        onError: onError,
      );
    }

    element._onListen();

    return node._listenElement(
      element,
      listener: listener,
      onError: onError,
    );
  }

  @override
  State read(Node node) {
    final element = node.readProviderElement(this);

    element.flush();

    // In case `read` was called on a provider that has no listener
    element.mayNeedDispose();

    return element.requireState;
  }

  /// An internal method that defines how a provider behaves.
  @visibleForOverriding
  ProviderElementBase<State> createElement(ProviderContainer container);

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    if (from == null) return super.hashCode;

    return from.hashCode ^ argument.hashCode;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (from == null) return identical(other, this);

    return other.runtimeType == runtimeType &&
        other is ProviderBase<State> &&
        other.from == from &&
        other.argument == argument;
  }

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

var _debugIsRunningSelector = false;

class _ExternalProviderSubscription<State>
    implements ProviderSubscription<State> {
  _ExternalProviderSubscription._(
    this._listenedElement,
    this._listener, {
    required this.onError,
  });

  final void Function(State? previous, State next) _listener;
  final ProviderElementBase<State> _listenedElement;
  final void Function(Object error, StackTrace stackTrace) onError;
  var _closed = false;

  @override
  void close() {
    _closed = true;
    _listenedElement._externalDependents.remove(this);
    _listenedElement._onRemoveListener();
  }

  @override
  State read() {
    if (_closed) {
      throw StateError(
        'called ProviderSubscription.read on a subscription that was closed',
      );
    }
    return _listenedElement.readSelf();
  }
}

/// Deals with the internals of synchronously calling the listeners
/// when using `fireImmediately: true`
void _handleFireImmediately<State>(
  Result<State> currentState, {
  required void Function(State? previous, State current) listener,
  required void Function(Object error, StackTrace stackTrace) onError,
}) {
  currentState.map(
    data: (data) => runBinaryGuarded(listener, null, data.state),
    error: (error) => runBinaryGuarded(onError, error.error, error.stackTrace),
  );
}
