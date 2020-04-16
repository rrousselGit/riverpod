import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Provider<T> with DiagnosticableTreeMixin {
  Provider(this._value);

  final T _value;

  ProviderOverride<T> overrideForSubstree(Provider<T> provider) {
    return ProviderOverride._(provider, this);
  }

  T call() {
    final scope =
        useContext().dependOnInheritedWidgetOfExactType<_ProviderScope>(
      aspect: this,
    );
    if (scope == null) {
      throw StateError('No ProviderScope found');
    }

    final providerState = scope[this] as ProviderState<T, Provider<T>>;
    return Hook.use(_ProviderHook(providerState));
  }

  ProviderState<T, Provider<T>> createState() => ProviderState(_value);
}

class _ProviderHook<T> extends Hook<T> {
  const _ProviderHook(this._providerState);

  final ProviderState<T, Provider<T>> _providerState;

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

class ProviderOverride<T> with DiagnosticableTreeMixin {
  ProviderOverride._(this._provider, this._origin);

  final Provider<T> _origin;
  final Provider<T> _provider;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('origin', _origin))
      ..add(DiagnosticsProperty('provider', _provider));
  }
}

class ProviderScope extends StatefulWidget {
  const ProviderScope({
    Key key,
    this.overrides = const [],
    @required this.child,
  })  :
        // ignore: prefer_asserts_with_message
        assert(child != null),
        super(key: key);

  final Widget child;
  final List<ProviderOverride<Object>> overrides;

  @override
  _ProviderScopeState createState() => _ProviderScopeState();
}

class _ProviderScopeState extends State<ProviderScope> {
  /// The state of all providers that reached this [ProviderScope].
  ///
  /// This includes the state of global providers that were not overriden
  /// if this [ProviderScope] is the topmost scope.
  // TODO: should not-overiden providers be extracted to a different map
  // that is not disposed?
  var _providerState =
      <Provider<Object>, ProviderState<Object, Provider<Object>>>{};

  @override
  void didUpdateWidget(ProviderScope oldWidget) {
    super.didUpdateWidget(oldWidget);
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
      if (oldOverride == null && newOverride == null) {
        continue;
      }

      // Was overriden but isn't anymore, so we dispose the previous state.
      // We don't need to create a new state as it will be done automatically
      // the next time the state is read.
      if (newOverride == null) {
        // TODO: guard exceptions
        entry.value.dispose();
        _providerState.remove(entry.key);
      }
      // Was overriden and still is, It happens when ProviderScope rebuilds.
      else if (oldOverride != null) {
        // TODO: provider runtimeType change
        // TODO: guard exceptions
        _providerState[entry.key]
          .._provider = newOverride._provider
          ..didUpdateProvider(oldOverride._provider);
      }
      // not overriden but now is
      else {
        // TODO: should it really dispose the state?
        entry.value.dispose();
        _providerState.remove(entry.key);
      }
    }
  }

  @override
  void dispose() {
    // TODO: dispose order -> proxy first
    for (final state in _providerState.values) {
      // TODO: guard exceptions
      state.dispose();
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

    /// A function that reads and potentially create the state associated
    /// to a given provider.
    /// It is critical for this function to be "pure". Even is the state
    /// associated to a provider changes in the future, this function
    /// should still point to the original state of the provider.
    ProviderState<T, Provider<T>> readProviderState<T>(
      Provider<T> provider, {
      Provider<Object> origin,
    }) {
      return _providerState.putIfAbsent(origin ?? provider, () {
        final state = provider.createState()
          .._provider = provider
          ..initState();
        return state;
      }) as ProviderState<T, Provider<T>>;
    }

    // Declaration split in multiple lines because of https://github.com/dart-lang/sdk/issues/41543
    var fallback = ancestorScope?.fallback;
    fallback ??= readProviderState;

    return _ProviderScope(
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
typedef _FallbackProviderStateReader = ProviderState<T, Provider<T>>
    Function<T>(Provider<T>);
// ignore: avoid_private_typedef_functions
typedef _ProviderStateReader = ProviderState<Object, Provider<Object>>
    Function();

class _ProviderScope extends InheritedModel<Provider<Object>> {
  const _ProviderScope({
    Key key,
    @required this.providersState,
    @required this.fallback,
    @required Widget child,
  }) : super(key: key, child: child);

  final Map<Provider<Object>, _ProviderStateReader> providersState;
  final _FallbackProviderStateReader fallback;

  @override
  bool updateShouldNotify(_ProviderScope oldWidget) {
    return providersState != oldWidget.providersState ||
        fallback != oldWidget.fallback;
  }

  @override
  bool updateShouldNotifyDependent(
    _ProviderScope oldWidget,
    Set<Provider<Object>> dependencies,
  ) {
    for (final dependency in dependencies) {
      if (this[dependency] != oldWidget[dependency]) {
        return true;
      }
    }
    return false;
  }

  ProviderState<Object, Provider<Object>> operator [](
    Provider<Object> provider,
  ) {
    return providersState[provider]?.call() ?? fallback(provider);
  }
}

class ProviderState<Res, T extends Provider<Res>> extends StateNotifier<Res> {
  ProviderState(Res state) : super(state);

  T _provider;
  T get provider => _provider;

  @mustCallSuper
  @protected
  void initState() {
    state = provider._value;
  }

  @mustCallSuper
  @protected
  void didUpdateProvider(covariant T oldProvider) {
    state = provider._value;
  }
}
