import 'dart:collection';

import 'package:meta/meta.dart';

import '../common.dart';

part 'base_provider.dart';
part 'keep_alive_provider.dart';

typedef OnError = void Function(dynamic error, StackTrace stackTrace);

// ignore: avoid_private_typedef_functions
typedef _FallbackProviderStateReader = BaseProviderState<BaseProviderValue, T,
        BaseProvider<BaseProviderValue, T>>
    Function<T>(
  BaseProvider<BaseProviderValue, T>,
);
// ignore: avoid_private_typedef_functions
typedef _ProviderStateReader = BaseProviderState<BaseProviderValue, Object,
        BaseProvider<BaseProviderValue, Object>>
    Function();

class ProviderStateOwner {
  ProviderStateOwner({
    ProviderStateOwner parent,
    List<ProviderOverride> overrides = const [],
    OnError onError,
  })  : _overrides = overrides,
        _onError = onError {
    updateParent(parent);
  }

  final OnError _onError;
  final _providerState = <BaseProvider, BaseProviderState>{};
  List<ProviderOverride> _overrides;
  Map<BaseProvider, _ProviderStateReader> _stateReaders;
  _FallbackProviderStateReader _fallback;

  Map<BaseProvider, BaseProviderValue> _dependencies;

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
  }

  BaseProviderState<BaseProviderValue, T, BaseProvider<BaseProviderValue, T>>
      _putIfAbsent<T>(
    BaseProvider<BaseProviderValue, T> provider, {
    BaseProvider origin,
  }) {
    final key = origin ?? provider;

    final localState = _providerState[key];
    if (localState != null) {
      return localState as BaseProviderState<BaseProviderValue, T,
          BaseProvider<BaseProviderValue, T>>;
    }

    final state = _createProviderState(provider);
    state.$state = state.initState();

    _providerState[key] = state;

    return state;
  }

  BaseProviderState<CombiningValue, ListeningValue,
          BaseProvider<CombiningValue, ListeningValue>>
      _createProviderState<CombiningValue extends BaseProviderValue,
          ListeningValue>(
    BaseProvider<CombiningValue, ListeningValue> provider,
  ) {
    return provider.createState()
      .._provider = provider
      .._owner = this;
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
      }

      return true;
    }(), '');

    final newOverrideForOverridenStates =
        overrides.fold<Map<BaseProviderState, BaseProvider>>(
      {},
      (acc, element) {
        final state = _providerState[element._origin];
        if (state != null) {
          acc[state] = element._provider;
        }
        return acc;
      },
    );

    visitNodesInDependencyOrder(
      newOverrideForOverridenStates.keys.toSet(),
      (state) {
        final oldOverride = state._provider;
        final newOverride = newOverrideForOverridenStates[state];
        assert(newOverride != null, '');

        state._provider = newOverride;

        try {
          state.didUpdateProvider(oldOverride);
        } catch (error, stack) {
          _onError?.call(error, stack);
        }
      },
    );
  }

  BaseProviderState<CombiningValue, ListeningValue,
          BaseProvider<CombiningValue, ListeningValue>>
      _readProviderState<CombiningValue extends BaseProviderValue,
          ListeningValue>(
    BaseProvider<CombiningValue, ListeningValue> provider,
  ) {
    final result = _stateReaders[provider]?.call() ?? _fallback(provider);
    return result as BaseProviderState<CombiningValue, ListeningValue,
        BaseProvider<CombiningValue, ListeningValue>>;
  }

  Res dependOn<Res extends BaseProviderValue>(
    BaseProvider<Res, Object> provider,
  ) {
    _dependencies ??= {};

    return _dependencies.putIfAbsent(provider, () {
      final state = _readProviderState(provider);
      return state.createProviderValue();
    }) as Res;
  }

  void dispose() {
    if (_dependencies != null) {
      for (final value in _dependencies.values) {
        value.dispose();
      }
    }
    visitNodesInDependencyOrder(_providerState.values.toSet(), (state) {
      try {
        state.dispose();
      } catch (err, stack) {
        _onError?.call(err, stack);
      }
    });
  }
}

@visibleForTesting
extension ReadProviderState on ProviderStateOwner {
  @visibleForTesting
  BaseProviderState<CombiningValue, ListeningValue,
          BaseProvider<CombiningValue, ListeningValue>>
      readProviderState<CombiningValue extends BaseProviderValue,
          ListeningValue>(
    BaseProvider<CombiningValue, ListeningValue> provider,
  ) {
    return _readProviderState(provider);
  }
}

class ProviderOverride<CombiningValue extends BaseProviderValue,
    ListeningValue extends Object> {
  ProviderOverride._(this._provider, this._origin);

  final BaseProvider<CombiningValue, ListeningValue> _origin;
  final BaseProvider<CombiningValue, ListeningValue> _provider;
}

abstract class BaseProviderValue {
  @protected
  void dispose() {}
}

class ProviderState {
  ProviderState(this._providerState);

  final BaseProviderState _providerState;

  bool get mounted => _providerState.mounted;

  void onDispose(VoidCallback cb) {
    assert(
      mounted,
      '`onDispose` was called on a state that is already disposed',
    );
    _providerState.onDispose(cb);
  }

  T dependOn<T extends BaseProviderValue>(BaseProvider<T, Object> provider) {
    assert(
      mounted,
      '`dependOn` was called on a state that is already disposed',
    );
    return _providerState.dependOn(provider);
  }

  // TODO report error?
}

/// A provider is somehow dependending on itself
class CircularDependencyError extends Error {
  CircularDependencyError._();
}
