import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import '../common.dart';

part 'base_provider.dart';
part 'base_provider1.dart';
part 'keep_alive_provider.dart';

// ignore: avoid_private_typedef_functions
typedef _FallbackProviderStateReader
    = BaseProviderState<Object, T, BaseProvider<Object, T>> Function<T>(
  BaseProvider<Object, T>,
);
// ignore: avoid_private_typedef_functions
typedef _ProviderStateReader
    = BaseProviderState<Object, Object, BaseProvider<Object, Object>>
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

  var _providerState = <BaseProvider<Object, Object>,
      BaseProviderState<Object, Object, BaseProvider<Object, Object>>>{};

  Map<BaseProvider<Object, Object>, _ProviderStateReader> _stateReaders;

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

  BaseProviderState<Object, T, BaseProvider<Object, T>> _putIfAbsent<T>(
    BaseProvider<Object, T> provider, {
    BaseProvider<Object, Object> origin,
  }) {
    final key = origin ?? provider;

    final localState = _providerState[key];
    if (localState != null) {
      return localState
          as BaseProviderState<Object, T, BaseProvider<Object, T>>;
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

  BaseProviderState<CombiningValue, ListeningValue,
          BaseProvider<CombiningValue, ListeningValue>>
      _createProviderState<CombiningValue, ListeningValue>(
    BaseProvider<CombiningValue, ListeningValue> provider,
    List<BaseProviderState<Object, Object, BaseProvider<Object, Object>>>
        dependencies,
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
  BaseProviderState<CombiningValue, ListeningValue,
          BaseProvider<CombiningValue, ListeningValue>>
      readProviderState<CombiningValue, ListeningValue>(
    BaseProvider<CombiningValue, ListeningValue> provider,
  ) {
    final result = _stateReaders[provider]?.call() ?? _fallback(provider);
    return result as BaseProviderState<CombiningValue, ListeningValue,
        BaseProvider<CombiningValue, ListeningValue>>;
  }
}

class ProviderOverride<CombiningValue, ListeningValue> {
  ProviderOverride._(this._provider, this._origin);

  final BaseProvider<CombiningValue, ListeningValue> _origin;
  final BaseProvider<CombiningValue, ListeningValue> _provider;
}

abstract class ProviderListenerState<T> {
  T get $state;
}

abstract class ProviderState {
  bool get mounted;

  void onDispose(VoidCallback cb);

  // TODO report error?
}
