import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

abstract class BaseProvider<T> with DiagnosticableTreeMixin {
  ProviderOverride<T> overrideForSubstree(BaseProvider<T> provider) {
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

    final providerState = scope[this] as BaseProviderState<T, BaseProvider<T>>;
    return Hook.use(_ProviderHook(providerState));
  }

  BaseProviderState<T, BaseProvider<T>> createState();
}

abstract class BaseProviderState<Res, T extends BaseProvider<Res>>
    extends StateNotifier<Res> {
  BaseProviderState() : super(null);

  T _provider;
  T get provider => _provider;

  @protected
  Res initState();

  @mustCallSuper
  @protected
  void didUpdateProvider(T oldProvider) {}
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
      <BaseProvider<Object>, BaseProviderState<Object, BaseProvider<Object>>>{};

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
      // Was not overriden but now is
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
    BaseProviderState<T, BaseProvider<T>> readProviderState<T>(
      BaseProvider<T> provider, {
      BaseProvider<Object> origin,
    }) {
      return _providerState.putIfAbsent(origin ?? provider, () {
        final state = provider.createState().._provider = provider;
        //ignore: invalid_use_of_protected_member
        state.state = state.initState();
        return state;
      }) as BaseProviderState<T, BaseProvider<T>>;
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
