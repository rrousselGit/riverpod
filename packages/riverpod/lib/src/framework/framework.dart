import 'dart:collection';

import 'package:meta/meta.dart';

import '../common.dart';
import '../provider.dart';

part 'base_provider.dart';
part 'keep_alive_provider.dart';

typedef OnError = void Function(dynamic error, StackTrace stackTrace);

// ignore: avoid_private_typedef_functions
typedef _FallbackProviderStateReader = ProviderBaseState<
        ProviderBaseSubscription, T, ProviderBase<ProviderBaseSubscription, T>>
    Function<T>(
  ProviderBase<ProviderBaseSubscription, T>,
);
// ignore: avoid_private_typedef_functions
typedef _ProviderStateReader = ProviderBaseState<ProviderBaseSubscription,
        Object, ProviderBase<ProviderBaseSubscription, Object>>
    Function();

final _refProvider = Provider((c) => c);

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
  final _providerState = <ProviderBase, ProviderBaseState>{};
  List<ProviderOverride> _overrides;
  Map<ProviderBase, _ProviderStateReader> _stateReaders;
  _FallbackProviderStateReader _fallback;

  ProviderReference get ref => _refProvider.readOwner(this);

  Map<ProviderBase, ProviderBaseSubscription> _dependencies;

  void updateParent(ProviderStateOwner parent) {
    _fallback = parent?._fallback;
    _fallback ??= _putIfAbsent;

    _stateReaders = {
      ...?parent?._stateReaders,
      _refProvider: () => _putIfAbsent(_refProvider),
      for (final override in _overrides)
        override._origin: () {
          return _putIfAbsent(
            override._provider,
            origin: override._origin,
          );
        },
    };
  }

  ProviderBaseState<ProviderBaseSubscription, T,
      ProviderBase<ProviderBaseSubscription, T>> _putIfAbsent<T>(
    ProviderBase<ProviderBaseSubscription, T> provider, {
    ProviderBase origin,
  }) {
    final key = origin ?? provider;

    final localState = _providerState[key];
    if (localState != null) {
      return localState as ProviderBaseState<ProviderBaseSubscription, T,
          ProviderBase<ProviderBaseSubscription, T>>;
    }

    final state = _createProviderState(provider)..initState();

    _providerState[key] = state;

    return state;
  }

  ProviderBaseState<CombiningValue, ListeningValue,
          ProviderBase<CombiningValue, ListeningValue>>
      _createProviderState<CombiningValue extends ProviderBaseSubscription,
          ListeningValue>(
    ProviderBase<CombiningValue, ListeningValue> provider,
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
        overrides.fold<Map<ProviderBaseState, ProviderBase>>(
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

  ProviderBaseState<CombiningValue, ListeningValue,
          ProviderBase<CombiningValue, ListeningValue>>
      _readProviderState<CombiningValue extends ProviderBaseSubscription,
          ListeningValue>(
    ProviderBase<CombiningValue, ListeningValue> provider,
  ) {
    final result = _stateReaders[provider]?.call() ?? _fallback(provider);
    return result as ProviderBaseState<CombiningValue, ListeningValue,
        ProviderBase<CombiningValue, ListeningValue>>;
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
  ProviderBaseState<CombiningValue, ListeningValue,
          ProviderBase<CombiningValue, ListeningValue>>
      readProviderState<CombiningValue extends ProviderBaseSubscription,
          ListeningValue>(
    ProviderBase<CombiningValue, ListeningValue> provider,
  ) {
    return _readProviderState(provider);
  }
}

class ProviderOverride<CombiningValue extends ProviderBaseSubscription,
    ListeningValue extends Object> {
  ProviderOverride._(this._provider, this._origin);

  final ProviderBase<CombiningValue, ListeningValue> _origin;
  final ProviderBase<CombiningValue, ListeningValue> _provider;
}

abstract class ProviderBaseSubscription {
  @protected
  void dispose() {}
}

class ProviderBaseSubscriptionImpl extends ProviderBaseSubscription {}

/// A provider is somehow dependending on itself
class CircularDependencyError extends Error {
  CircularDependencyError._();
}

class ProviderReference {
  ProviderReference(this._providerState);

  final ProviderBaseState _providerState;

  bool get mounted => _providerState.mounted;

  void onDispose(VoidCallback cb) {
    assert(
      mounted,
      '`onDispose` was called on a state that is already disposed',
    );
    _providerState.onDispose(cb);
  }

  T dependOn<T extends ProviderBaseSubscription>(
    ProviderBase<T, Object> provider,
  ) {
    assert(
      mounted,
      '`dependOn` was called on a state that is already disposed',
    );
    return _providerState.dependOn(provider);
  }

  // TODO report error?
}
