import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

abstract class InheritedProvider<T> with DiagnosticableTreeMixin {
  ProviderOverride<T> overrideForSubstree(InheritedProvider<T> provider) {
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

    final providerState =
        scope[this] as InheritedProviderState<T, InheritedProvider<T>>;
    return Hook.use(_ProviderHook(providerState));
  }

  InheritedProviderState<T, InheritedProvider<T>> createState();
}

class InheritedProviderState<Res, T extends InheritedProvider<Res>>
    extends StateNotifier<Res> {
  InheritedProviderState(Res state) : super(state);

  T _provider;
  T get provider => _provider;

  @mustCallSuper
  @protected
  void initState() {}

  @mustCallSuper
  @protected
  void didUpdateProvider(T oldProvider) {}
}

class _ProviderHook<T> extends Hook<T> {
  const _ProviderHook(this._providerState);

  final InheritedProviderState<T, InheritedProvider<T>> _providerState;

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

  final InheritedProvider<T> _origin;
  final InheritedProvider<T> _provider;

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
  var _providerState = <InheritedProvider<Object>,
      InheritedProviderState<Object, InheritedProvider<Object>>>{};

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
    InheritedProviderState<T, InheritedProvider<T>> readProviderState<T>(
      InheritedProvider<T> provider, {
      InheritedProvider<Object> origin,
    }) {
      return _providerState.putIfAbsent(origin ?? provider, () {
        final state = provider.createState()
          .._provider = provider
          ..initState();
        return state;
      }) as InheritedProviderState<T, InheritedProvider<T>>;
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
typedef _FallbackProviderStateReader
    = InheritedProviderState<T, InheritedProvider<T>> Function<T>(
        InheritedProvider<T>);
// ignore: avoid_private_typedef_functions
typedef _ProviderStateReader
    = InheritedProviderState<Object, InheritedProvider<Object>> Function();

class _ProviderScope extends InheritedModel<InheritedProvider<Object>> {
  const _ProviderScope({
    Key key,
    @required this.providersState,
    @required this.fallback,
    @required Widget child,
  }) : super(key: key, child: child);

  final Map<InheritedProvider<Object>, _ProviderStateReader> providersState;
  final _FallbackProviderStateReader fallback;

  @override
  bool updateShouldNotify(_ProviderScope oldWidget) {
    return providersState != oldWidget.providersState ||
        fallback != oldWidget.fallback;
  }

  @override
  bool updateShouldNotifyDependent(
    _ProviderScope oldWidget,
    Set<InheritedProvider<Object>> dependencies,
  ) {
    for (final dependency in dependencies) {
      if (this[dependency] != oldWidget[dependency]) {
        return true;
      }
    }
    return false;
  }

  InheritedProviderState<Object, InheritedProvider<Object>> operator [](
    InheritedProvider<Object> provider,
  ) {
    return providersState[provider]?.call() ?? fallback(provider);
  }
}
