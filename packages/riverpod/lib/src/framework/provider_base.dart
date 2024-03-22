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
abstract class ProviderBase<StateT> extends ProviderOrFamily
    with ProviderListenable<StateT>
    implements ProviderOverride, Refreshable<StateT> {
  /// A base class for _all_ providers.
  const ProviderBase({
    required super.name,
    required this.from,
    required this.argument,
    required this.debugGetCreateSourceHash,
    required super.dependencies,
    required super.allTransitiveDependencies,
  });

  @override
  ProviderBase<Object?> get _origin => this;

  @override
  ProviderBase<Object?> get _override => this;

  /// {@template riverpod.create_source_hash}
  /// A debug-only fucntion for obtaining a hash of the source code of the
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
  final Family<Object?>? from;

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
      handleFireImmediately(
        element.getState()!,
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
    element.mayNeedDispose();

    return element.requireState;
  }

  /// An internal method that defines how a provider behaves.
  @visibleForOverriding
  ProviderElementBase<StateT> createElement();

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
        other is ProviderBase<StateT> &&
        other.from == from &&
        other.argument == argument;
  }

  @override
  String toString() {
    var leading = '';
    if (from != null) {
      leading = '($argument)';
    }

    var trailing = '';
    if (name != null) {
      trailing = '$name:';
    }

    return '$trailing${describeIdentity(this)}$leading';
  }
}

var _debugIsRunningSelector = false;

/// When a provider listens to another provider using `listen`
@optionalTypeArgs
class _ProviderStateSubscription<StateT> extends ProviderSubscription<StateT> {
  _ProviderStateSubscription(
    super.source, {
    required this.listenedElement,
    required this.listener,
    required this.onError,
  }) {
    final dependents = listenedElement._dependents ??= [];
    dependents.add(this);
  }

  // Why can't this be typed correctly?
  final void Function(Object? prev, Object? state) listener;
  final ProviderElementBase<StateT> listenedElement;
  final OnError onError;

  @override
  StateT read() {
    if (_closed) {
      throw StateError(
        'called ProviderSubscription.read on a subscription that was closed',
      );
    }
    return listenedElement.readSelf();
  }

  @override
  void close() {
    if (!closed) {
      listenedElement._dependents?.remove(this);
      listenedElement._onRemoveListener();
    }

    super.close();
  }
}

/// A mixin to add [overrideWithValue] capability to a provider.
// TODO merge with Provider directy
mixin OverrideWithValueMixin<State> on ProviderBase<State> {
  /// {@template riverpod.overrridewithvalue}
  /// Overrides a provider with a value, ejecting the default behaviour.
  ///
  /// This will also disable the auto-scoping mechanism, meaning that if the
  /// overridden provider specified [dependencies], it will have no effect.
  ///
  /// Some common use-cases are:
  /// - testing, by replacing a service with a fake implementation, or to reach
  ///   a very specific state easily.
  /// - multiple environments, by changing the implementation of a class
  ///   based on the platform or other parameters.
  ///
  /// This function should be used in combination with `ProviderScope.overrides`
  /// or `ProviderContainer.overrides`:
  ///
  /// ```dart
  /// final myService = Provider((ref) => MyService());
  ///
  /// runApp(
  ///   ProviderScope(
  ///     overrides: [
  ///       myService.overrideWithValue(
  ///         // Replace the implementation of MyService with a fake implementation
  ///         MyFakeService(),
  ///       ),
  ///     ],
  ///     child: MyApp(),
  ///   ),
  /// );
  /// ```
  /// {@endtemplate}
  Override overrideWithValue(State value) {
    return ProviderOverride(
      origin: this,
      override: ValueProvider<State>(value),
    );
  }
}

/// A mixin to add `overrideWithProvider` capability to providers.
extension OverrideWithProviderExtension<State,
    ProviderType extends ProviderBase<State>> on ProviderType {
  /// {@template riverpod.overridewithprovider}
  /// Overrides a provider with a value, ejecting the default behaviour.
  ///
  /// This will also disable the auto-scoping mechanism, meaning that if the
  /// overridden provider specified `dependencies`, it will have no effect.
  ///
  /// The override must not specify a `dependencies`.
  ///
  /// Some common use-cases are:
  /// - testing, by replacing a service with a fake implementation, or to reach
  ///   a very specific state easily.
  /// - multiple environments, by changing the implementation of a class
  ///   based on the platform or other parameters.
  ///
  /// This function should be used in combination with `ProviderScope.overrides`
  /// or `ProviderContainer.overrides`:
  ///
  /// ```dart
  /// final myService = Provider((ref) => MyService());
  ///
  /// runApp(
  ///   ProviderScope(
  ///     overrides: [
  ///       myService.overrideWithProvider(
  ///         // Replace the implementation of the provider with a different one
  ///         Provider((ref) {
  ///           ref.watch('other');
  ///           return MyFakeService(),
  ///         }),
  ///       ),
  ///     ],
  ///     child: MyApp(),
  ///   ),
  /// );
  /// ```
  /// {@endtemplate}
  @Deprecated('Will be removed in 3.0.0. Use overrideWith instead.')
  Override overrideWithProvider(ProviderType override) {
    assert(
      override.dependencies == null,
      'When using overrideWithProvider, the override cannot specify `dependencies`.',
    );

    return ProviderOverride(origin: this, override: override);
  }
}
