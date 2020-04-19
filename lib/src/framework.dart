import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:meta/meta.dart';

import 'provider.dart' show Provider;

/// A base class for all providers.
///
/// Providers are objects that allows passing state around the widget tree,
/// without having to pass our variables to each individual widgets.
///
/// While providers are typically declared as a global variable, they are
/// **not** global variables/singletons.
/// As such, you do not need to reset the state of a provider between tests,
/// since two tests won't share state.
///
/// Similarly, providers have a rebuild mechanism, which will make widgets
/// that use a provider rebuild when the value associated changes.
///
/// # Usage
///
/// Providers are typically declared as final global variables
/// (but don't have to be global).
/// By convention, all provider instances should have their name start
/// with "use" as a mean to understand that they are "hooks".
///
/// Then, the application must be wrapped in a [ProviderScope] widget.
///
/// Finally, providers are then consumed by a [HookWidget].
///
/// Wrapping up, a "Hello world" example would be:
///
/// ```dart
/// // The provider is stored as a global variable.
/// // Its name starts with "use" to follow the hook convention.
/// final useGreeting = Provider((_) => 'Hello world');
///
/// void main() {
///   runApp(
///     // We wrapped our entire app in a ProviderScope widget.
///     // This widget is where the state of our providers will be stored.
///     ProviderScope(
///       child: MyApp(),
///     ),
///   );
/// }
///
/// // Note: This is a HookWidget, not a StatelessWidget
/// class MyApp extends HookWidget {
///   @override
///   Widget build(BuildContext context) {
///     // Read our provider. Calling `useGreeting` is possible only inside `build`.
///     final String greeting = useGreeting();
///
///     return MaterialApp(
///       home: Scaffold(
///         body: Text(greeting),
///       ),
///     );
///   }
/// }
/// ```
///
/// See also:
///
/// - `flutter_hooks` (https://github.com/rrousselGit/flutter_hooks), the package
///   that provides [HookWidget], which is necessary to consume providers.
/// - [Provider], a provider that expose an object without
///   caring about what the object is.
/// - [ProviderScope], the widget that stores the state of a provider and allows
///   the state to be overriden.
/// - [call], to obtain and subscribe to the provider.
@immutable
abstract class BaseProvider<T> with DiagnosticableTreeMixin {
  /// Override a provider for a widget tree.
  ///
  /// This is used in coordination with [ProviderScope].
  /// See [ProviderScope] for a usage example.
  ProviderOverride<T> overrideForSubtree(BaseProvider<T> provider) {
    return ProviderOverride._(provider, this);
  }

  /// Obtain and subscribe to the provider.
  ///
  /// This function is a "hook" and can only be used inside [HookWidget.build].
  /// [HookWidget] is a new kind of widget (different from [StatelessWidget]/...),
  /// that is implemented by the package `flutter_hooks`.
  T call() {
    final scope =
        useContext().dependOnInheritedWidgetOfExactType<_ProviderScope>(
      aspect: this,
    );
    if (scope == null) {
      throw StateError('No ProviderScope found');
    }

    final providerState = scope[this] as BaseProviderState<T, BaseProvider<T>>;
    return Hook.use(_ProviderHook(providerState));
  }

  Iterable<BaseProvider<Object>> _allDependencies() sync* {}

  /// DO NOT USE. An implementation detail of how the provider's
  /// state is created.
  ///
  /// It is similar to [StatefulWidget.createState].
  @visibleForOverriding
  BaseProviderState<T, BaseProvider<T>> createState();
}

/// DO NOT USE. The internal state of a Provider.
///
/// It is similar to [State].
@visibleForOverriding
abstract class BaseProviderState<Res, T extends BaseProvider<Res>>
    extends StateNotifier<Res> implements ProviderListenerState<Res> {
  /// DO NOT USE.
  BaseProviderState() : super(null);

  T _provider;

  /// DO NOT USE.
  @protected
  @visibleForTesting
  T get provider => _provider;

  void _initDependencies(
    Iterable<BaseProviderState<Object, BaseProvider<Object>>> dependenciesState,
  ) {}

  /// DO NOT USE.
  @protected
  Res initState();

  /// DO NOT USE.
  @mustCallSuper
  @protected
  void didUpdateProvider(T oldProvider) {}

  @override
  void onChange(void Function(Res p1) listener) {
    addListener(listener, fireImmediately: false);
  }

  @override
  Stream<Res> get stream => throw UnimplementedError();

  @override
  ValueListenable<Res> get valueListenable => throw UnimplementedError();
}

abstract class ProviderListenerState<T> {
  T get state;

  Stream<T> get stream;
  ValueListenable<T> get valueListenable;

  void onChange(void Function(T) listener);
}

abstract class BaseProvider1<First, Res> extends BaseProvider<Res> {
  BaseProvider1(this._first);

  final BaseProvider<First> _first;

  @override
  Iterable<BaseProvider<Object>> _allDependencies() sync* {
    yield _first;
  }

  @override
  BaseProvider1State<First, Res, BaseProvider1<First, Res>> createState();
}

abstract class BaseProvider1State<First, Res,
    T extends BaseProvider1<First, Res>> extends BaseProviderState<Res, T> {
  ProviderListenerState<First> _firstDependencyState;
  ProviderListenerState<First> get firstDependencyState {
    return _firstDependencyState;
  }

  @override
  void _initDependencies(
    Iterable<BaseProviderState<Object, BaseProvider<Object>>> dependenciesState,
  ) {
    _firstDependencyState =
        dependenciesState.first as ProviderListenerState<First>;
  }
}

class _ProviderHook<T> extends Hook<T> {
  const _ProviderHook(this._providerState);

  final BaseProviderState<T, BaseProvider<T>> _providerState;

  @override
  _ProviderHookState<T> createState() => _ProviderHookState();
}

class _ProviderHookState<T> extends HookState<T, _ProviderHook<T>> {
  T _state;
  VoidCallback _removeListener;

  @override
  T build(BuildContext context) => _state;

  @override
  void initHook() {
    super.initHook();
    _listen(hook._providerState);
  }

  @override
  void didUpdateHook(_ProviderHook<T> oldHook) {
    super.didUpdateHook(oldHook);
    if (hook._providerState != oldHook._providerState) {
      _listen(hook._providerState);
    }
  }

  void _listen(StateNotifier<T> notifier) {
    _removeListener?.call();
    _removeListener = notifier.addListener(_listener);
  }

  void _listener(T value) {
    setState(() => _state = value);
  }

  @override
  void dispose() {
    _removeListener?.call();
    super.dispose();
  }
}

/// An object used by [ProviderScope] to override a provider for a widget tree.
///
/// See also:
///
/// - [BaseProvider.overrideForSubtree], to create an instance of
///   [ProviderOverride] from a provider.
class ProviderOverride<T> with DiagnosticableTreeMixin {
  ProviderOverride._(this._provider, this._origin);

  final BaseProvider<T> _origin;
  final BaseProvider<T> _provider;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('origin', _origin))
      ..add(DiagnosticsProperty('provider', _provider));
  }
}

/// The widget that stores the state of providers, and expose it to its
/// descendants.
///
/// All applications using providers must have _at least_ one [ProviderScope],
/// usually above [MaterialApp] or "MyApp".
///
/// Further [ProviderScope] widgets can be added anywhere in the widget tree
/// to override for a specific widget tree how a provider is resolved.
///
/// # Basic usage
///
/// Most apps will have a single [ProviderScope] near the root of their tree:
///
/// ```dart
/// void main() {
///   runApp(
///     // ProviderScope is above everything
///     ProviderScope(
///       child: MyApp(),
///     ),
///   );
/// }
/// ```
///
/// # Overriding providers for a widget tree
///
/// Through [ProviderScope], it is possible to override a provider for
/// a specific widget tree.
///
/// This can be useful for multiple reasons, such as testing or making an
/// interactive gallery.
///
/// To do so, add a [ProviderScope] above the targeted widget tree, and
/// override the provider of your choice inside the [overrides] parameter.
///
/// For example, consider the scenario where we have a `Repository` class
/// that does some http requests:
///
/// ```dart
/// final useRepository = Provider((_) => Repository());
/// ```
///
/// In that situation, we may want to override that provider to replace
/// `Repository` with a fake implementation that returns a specific result.
///
/// To do so, our test would look like this:
///
/// ```dart
/// testWidgets('example', (tester) async {
///   // We create our fake repository, usually using Mockito
///   final mockedRepository = RepositoryMock();
///
///   await tester.pumpWidget(
///     ProviderScope(
///       overrides: [
///         // we called overrideForSubtree on the provider that we want
///         // to override, and passed it the new behavior
///         useRepository.overrideForSubtree(
///           Provider.value(mockedRepository),
///         ),
///       ],
///       // Now, when this widget tries to use our `useRepository` provider
///       // then it will obtain our `mockedRepository` instead.
///       child: WidgetThatWeWantToTest(),
///     ),
///   );
///   // some tests
/// });
/// ```
class ProviderScope extends StatefulWidget {
  /// Creates a [ProviderScope] and optionally allows overriding providers.
  const ProviderScope({
    Key key,
    this.overrides = const [],
    @required this.child,
  })  : assert(child != null, 'child cannot be `null`'),
        super(key: key);

  ///
  @visibleForTesting
  final Widget child;

  /// Override multiple providers for [child] and its descendants.
  ///
  /// To create the override, use the [BaseProvider.overrideForSubtree] method
  /// like so:
  ///
  /// ```dart
  /// final useGreeting = Provider((_) => 'Hello world');
  ///
  /// void main() {
  ///   runApp(
  ///     ProviderScope(
  ///       overrides: [
  ///         useGreeting.overrideForSubtree(
  ///           Provider((_) => 'Bonjour le monde'),
  ///         ),
  ///       ],
  ///       child: MyApp(),
  ///     ),
  ///   );
  /// }
  /// ```
  @visibleForTesting
  final List<ProviderOverride<Object>> overrides;

  @override
  _ProviderScopeState createState() => _ProviderScopeState();
}

class _ProviderScopeState extends State<ProviderScope> {
  /// The state of all providers that reached this [ProviderScope].
  ///
  /// This includes the state of global providers that were not overriden
  /// if this [ProviderScope] is the topmost scope.
  var _providerState =
      <BaseProvider<Object>, BaseProviderState<Object, BaseProvider<Object>>>{};

  @override
  void didUpdateWidget(ProviderScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(() {
      if (widget.overrides.length != oldWidget.overrides.length) {
        throw UnsupportedError(
          'Adding or removing provider overrides is not supported',
        );
      }

      for (var i = 0; i < widget.overrides.length; i++) {
        final previous = oldWidget.overrides[i];
        final next = widget.overrides[i];

        if (previous._provider.runtimeType != next._provider.runtimeType) {
          throw UnsupportedError('''
Replaced the override at index $i of type ${previous._provider.runtimeType} with an override of type ${next._provider.runtimeType}, which is different.
Changing the kind of override or reordering overrides is not supported.
''');
        }

        if (previous._origin != next._origin) {
          throw UnsupportedError(
            'The provider overriden at the index $i changed, which is unsupported.',
          );
        }
      }

      return true;
    }(), '');
    final previousProviderState = _providerState;
    _providerState = {..._providerState};

    for (final entry in previousProviderState.entries) {
      final oldOverride = oldWidget.overrides.firstWhere(
        (p) => p._origin == entry.key,
        orElse: () => null,
      );
      final newOverride = widget.overrides.firstWhere(
        (p) => p._origin == entry.key,
        orElse: () => null,
      );

      // Wasn't overriden before and is still not overriden
      if (oldOverride == null || newOverride == null) {
        continue;
      }

      _providerState[entry.key]
        .._provider = newOverride._provider
        ..didUpdateProvider(oldOverride._provider);
    }
  }

  @override
  void dispose() {
    // TODO: dispose order -> proxy first
    for (final state in _providerState.values) {
      try {
        state.dispose();
      } catch (err, stack) {
        FlutterError.reportError(
          FlutterErrorDetails(
            library: 'provider_hooks',
            exception: err,
            stack: stack,
          ),
        );
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ancestorScope =
        context.dependOnInheritedWidgetOfExactType<_ProviderScope>();

    // Dereference _providerState so that it becomes immutable
    // for `readProviderState` to stay pure.
    final _providerState = this._providerState;

    _ProviderScope scope;

    /// A function that reads and potentially create the state associated
    /// to a given provider.
    /// It is critical for this function to be "pure". Even is the state
    /// associated to a provider changes in the future, this function
    /// should still point to the original state of the provider.
    BaseProviderState<T, BaseProvider<T>> readProviderState<T>(
      BaseProvider<T> provider, {
      BaseProvider<Object> origin,
    }) {
      final key = origin ?? provider;

      final localState = _providerState[key];
      if (localState != null) {
        return localState as BaseProviderState<T, BaseProvider<T>>;
      }

      final state = provider.createState()
        .._provider = provider
        .._initDependencies(
          provider._allDependencies().map((dep) => scope[dep]),
        );
      _providerState[key] = state;

      //ignore: invalid_use_of_protected_member
      state.state = state.initState();

      return state;
    }

    // Declaration split in multiple lines because of https://github.com/dart-lang/sdk/issues/41543
    var fallback = ancestorScope?.fallback;
    fallback ??= readProviderState;

    return scope = _ProviderScope(
      providersState: {
        ...?ancestorScope?.providersState,
        for (final override in widget.overrides)
          override._origin: () {
            return readProviderState(
              override._provider,
              origin: override._origin,
            );
          },
      },
      fallback: fallback,
      child: widget.child,
    );
  }
}

// ignore: avoid_private_typedef_functions
typedef _FallbackProviderStateReader = BaseProviderState<T, BaseProvider<T>>
    Function<T>(BaseProvider<T>);
// ignore: avoid_private_typedef_functions
typedef _ProviderStateReader = BaseProviderState<Object, BaseProvider<Object>>
    Function();

class _ProviderScope extends InheritedModel<BaseProvider<Object>> {
  const _ProviderScope({
    Key key,
    @required this.providersState,
    @required this.fallback,
    @required Widget child,
  }) : super(key: key, child: child);

  final Map<BaseProvider<Object>, _ProviderStateReader> providersState;
  final _FallbackProviderStateReader fallback;

  @override
  bool updateShouldNotify(_ProviderScope oldWidget) {
    return providersState != oldWidget.providersState ||
        fallback != oldWidget.fallback;
  }

  @override
  bool updateShouldNotifyDependent(
    _ProviderScope oldWidget,
    Set<BaseProvider<Object>> dependencies,
  ) {
    for (final dependency in dependencies) {
      if (this[dependency] != oldWidget[dependency]) {
        return true;
      }
    }
    return false;
  }

  BaseProviderState<Object, BaseProvider<Object>> operator [](
    BaseProvider<Object> provider,
  ) {
    return providersState[provider]?.call() ?? fallback(provider);
  }
}
