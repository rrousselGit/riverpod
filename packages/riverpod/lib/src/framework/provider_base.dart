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
typedef Create<T, R extends Ref> = T Function(R ref);

/// A function that reads the state of a provider.
@Deprecated('Directly pass Ref to your providers instead')
typedef Reader = T Function<T>(ProviderBase<T> provider);

/// A base class for _all_ providers.
@immutable
abstract class ProviderBase<State> extends ProviderOrFamily
    with ProviderListenable<State>
    implements ProviderOverride {
  /// A base class for _all_ providers.
  ProviderBase({
    required this.name,
    required this.from,
    required this.argument,
  });

  @override
  ProviderBase get _origin => originProvider;
  @override
  ProviderBase get _override => originProvider;

  /// {@template riverpod.name}
  /// A custom label for providers.
  ///
  /// This is picked-up by devtools and [toString] to show better messages.
  /// {@endtemplate}
  final String? name;

  /// If this provider was created with the `.family` modifier, [from] is the `.family` instance.
  @override
  final Family? from;

  /// If this provider was created with the `.family` modifier, [argument] is
  /// the variable that was used.
  final Object? argument;

  /// The provider that will be refreshed when calling [ProviderContainer.refresh]
  /// and that will be overridden when passed to `ProviderScope`.
  ///
  /// Defaults to `this`.
  @visibleForOverriding
  // ignore: avoid_returning_this
  ProviderBase<Object?> get originProvider => this;

  @override
  ProviderSubscription<State> addListener(
    Node node,
    void Function(State? previous, State next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
    bool fireImmediately = false,
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

    element._onListen();

    return node._createSubscription(
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

  /// Initializes the state of a provider
  @visibleForOverriding
  State create(covariant Ref ref);

  /// Called when a provider is rebuilt. Used for providers to not notify their
  /// listeners if the exposed value did not change.
  @visibleForOverriding
  bool updateShouldNotify(State previousState, State newState);

  /// An internal method that defines how a provider behaves.
  @visibleForOverriding
  ProviderElementBase<State> createElement();

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

    var trailing = '';
    if (name != null) {
      trailing = '$name:';
    }

    return '$trailing${describeIdentity(this)}$leading';
  }
}

var _debugIsRunningSelector = false;

class _ProviderSubscription<State> implements ProviderSubscription<State> {
  _ProviderSubscription._(
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
    _listenedElement._listeners.remove(this);
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

/// When a provider listens to another provider using `listen`
class _ProviderListener<State> implements ProviderSubscription<State> {
  _ProviderListener._({
    required this.listenedElement,
    required this.dependentElement,
    required this.listener,
    required this.onError,
  });

// TODO can't we type it properly?
  final void Function(Object? prev, Object? state) listener;
  final ProviderElementBase<Object?> dependentElement;
  final ProviderElementBase<State> listenedElement;
  final void Function(Object, StackTrace) onError;

  @override
  void close() {
    dependentElement._subscriptions.remove(this);
    listenedElement
      .._subscribers.remove(this)
      .._onRemoveListener();
  }

  @override
  State read() => listenedElement.readSelf();
}

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
    // TODO handle autoDispose such that cacheTime is applied
    return ProviderOverride(
      origin: this,
      override: ValueProvider<State>(value),
    );
  }
}

mixin OverrideWithProviderMixin<State,
    ProviderType extends ProviderBase<Object?>> {
  ProviderBase<State> get originProvider;

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
  Override overrideWithProvider(ProviderType value) {
    assert(
      value.originProvider.dependencies == null,
      'When using overrideWithProvider, the override cannot specify `dependencies`.',
    );

    return ProviderOverride(
      origin: originProvider,
      override: value.originProvider,
    );
  }
}
