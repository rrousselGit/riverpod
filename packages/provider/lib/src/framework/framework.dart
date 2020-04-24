import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

part 'base_provider.dart';

typedef Create<Res, State extends ProviderState> = Res Function(State state);
typedef Create1<A, Res, State extends ProviderState> = Res Function(
  State state,
  ProviderListenerState<A> first,
);
typedef Create2<A, B, Res, State extends ProviderState> = Res Function(
  State state,
  ProviderListenerState<A> first,
  ProviderListenerState<B> second,
);
typedef Create3<A, B, C, Res, State extends ProviderState> = Res Function(
  State state,
  ProviderListenerState<A> first,
  ProviderListenerState<B> second,
  ProviderListenerState<C> third,
);

typedef VoidCallback = void Function();

// ignore: avoid_private_typedef_functions
typedef _FallbackProviderStateReader = BaseProviderState<T, BaseProvider<T>>
    Function<T>(BaseProvider<T>);
// ignore: avoid_private_typedef_functions
typedef _ProviderStateReader = BaseProviderState<Object, BaseProvider<Object>>
    Function();

class ProviderStateOwner {
  ProviderStateOwner({
    ProviderStateOwner parent,
    List<ProviderOverride> overrides = const [],
    void Function(dynamic error, StackTrace stackTrace) onError,
  })  : _overrides = overrides,
        _onError = onError {
    updateParent(parent);
  }

  final void Function(dynamic error, StackTrace stackTrace) _onError;

  List<ProviderOverride> _overrides;

  var _providerState =
      <BaseProvider<Object>, BaseProviderState<Object, BaseProvider<Object>>>{};

  Map<BaseProvider<Object>, _ProviderStateReader> _stateReaders;

  _FallbackProviderStateReader _fallback;

  void updateParent(ProviderStateOwner parent) {
    _fallback = parent?._fallback;
    _fallback ??= _putIfAbsent;

    _stateReaders = {
      ...?parent?._stateReaders,
      for (final override in _overrides)
        override._origin: () {
          return _putIfAbsent(
            override._provider,
            origin: override._origin,
          );
        },
    };

    // Verify that the providers that depends on other providers kept the same dependency
    assert(() {
      for (final providerState in _providerState.values) {
        final newDendencies = providerState.provider
            ._allDependencies()
            .map(readProviderState)
            .toList();

        if (!const DeepCollectionEquality().equals(
            providerState._debugInitialDependenciesState, newDendencies)) {
          _onError?.call(
            UnsupportedError('''
The provider $this, which denpends on other providers, was rebuilt with different dependencies.'''),
            StackTrace.current,
          );
        }
      }
      return true;
    }(), '');
  }

  BaseProviderState<T, BaseProvider<T>> _putIfAbsent<T>(
    BaseProvider<T> provider, {
    BaseProvider<Object> origin,
  }) {
    final key = origin ?? provider;

    final localState = _providerState[key];
    if (localState != null) {
      return localState as BaseProviderState<T, BaseProvider<T>>;
    }

    final state = _createProviderState(
      provider,
      provider //
          ._allDependencies()
          .map(readProviderState)
          .toList(),
    );
    _providerState[key] = state;

    //ignore: invalid_use_of_protected_member
    state.$state = state.initState();

    return state;
  }

  BaseProviderState<Res, BaseProvider<Res>> _createProviderState<Res>(
    BaseProvider<Res> provider,
    List<BaseProviderState<Object, BaseProvider<Object>>> dependencies,
  ) {
    return provider.createState()
      .._provider = provider
      .._owner = this
      .._initDependencies(dependencies);
  }

  void updateOverrides(List<ProviderOverride> overrides) {
    final oldOverrides = _overrides;
    _overrides = overrides;

    assert(() {
      if (overrides.length != oldOverrides.length) {
        throw UnsupportedError(
          'Adding or removing provider overrides is not supported',
        );
      }

      for (var i = 0; i < overrides.length; i++) {
        final previous = oldOverrides[i];
        final next = overrides[i];

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

        if (!const DeepCollectionEquality().equals(
          previous._provider._allDependencies(),
          next._provider._allDependencies(),
        )) {
          throw UnsupportedError('''
The provider ${previous._provider}, which denpends on other providers, was rebuilt with different dependencies.''');
        }
      }

      return true;
    }(), '');
    final previousProviderState = _providerState;
    _providerState = {..._providerState};

    for (final entry in previousProviderState.entries) {
      final oldOverride = oldOverrides.firstWhere(
        (p) => p._origin == entry.key,
        orElse: () => null,
      );
      final newOverride = overrides.firstWhere(
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

  void dispose() {
    // TODO: dispose order -> proxy first
    for (final state in _providerState.values) {
      try {
        state.dispose();
      } catch (err, stack) {
        _onError?.call(err, stack);
      }
    }
  }
}

extension OwnerPutIfAbsent on ProviderStateOwner {
  BaseProviderState<Res, BaseProvider<Res>> readProviderState<Res>(
    BaseProvider<Res> provider,
  ) {
    final result = _stateReaders[provider]?.call() ?? _fallback(provider);
    return result as BaseProviderState<Res, BaseProvider<Res>>;
  }
}

class ProviderOverride<T> {
  ProviderOverride._(this._provider, this._origin);

  final BaseProvider<T> _origin;
  final BaseProvider<T> _provider;
}

abstract class ProviderListenerState<T> {
  T get $state;
}

abstract class ProviderState {
  bool get mounted;

  void onDispose(VoidCallback cb);
}
