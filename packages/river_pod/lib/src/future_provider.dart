import 'dart:async';

import 'package:meta/meta.dart';

import 'common.dart';
import 'framework/framework.dart';

class FutureProviderValue<T> extends BaseProviderValue {
  FutureProviderValue._({@required this.future});

  final Future<T> future;
}

class FutureProvider<Res>
    extends AlwaysAliveProvider<FutureProviderValue<Res>, AsyncValue<Res>> {
  FutureProvider(this._create);

  final Create<Future<Res>, ProviderState> _create;

  @override
  _FutureProviderState<Res> createState() {
    return _FutureProviderState<Res>();
  }

  ProviderOverride debugOverrideFromValue(AsyncValue<Res> value) {
    return overrideForSubtree(
      _DebugFutureProviderValue(value),
    );
  }
}

class _FutureProviderState<Res> extends BaseProviderState<
    FutureProviderValue<Res>, AsyncValue<Res>, FutureProvider<Res>> {
  Future<Res> _future;

  @override
  AsyncValue<Res> initState() {
    _future = provider._create(ProviderState(this));
    _listen();

    return const AsyncValue.loading();
  }

  Future<void> _listen() async {
    try {
      final value = await _future;
      if (mounted) {
        $state = AsyncValue.data(value);
      }
    } catch (err, stack) {
      if (mounted) {
        $state = AsyncValue.error(err, stack);
      }
    }
  }

  @override
  FutureProviderValue<Res> createProviderValue() {
    return FutureProviderValue._(future: _future);
  }
}

class _DebugFutureProviderValue<Res>
    extends BaseProvider<FutureProviderValue<Res>, AsyncValue<Res>> {
  _DebugFutureProviderValue(this._value);

  final AsyncValue<Res> _value;

  @override
  _DebugFutureProviderValueState<Res> createState() {
    _DebugFutureProviderValueState<Res> result;
    assert(() {
      result = _DebugFutureProviderValueState<Res>();
      return true;
    }(), '');
    return result;
  }
}

class _DebugFutureProviderValueState<Res> extends BaseProviderState<
    FutureProviderValue<Res>, AsyncValue<Res>, _DebugFutureProviderValue<Res>> {
  final _completer = Completer<Res>();

  @override
  AsyncValue<Res> initState() {
    provider._value.when(
      data: _completer.complete,
      loading: () {},
      error: _completer.completeError,
    );

    return provider._value;
  }

  @override
  void didUpdateProvider(_DebugFutureProviderValue<Res> oldProvider) {
    super.didUpdateProvider(oldProvider);

    if (provider._value != oldProvider._value) {
      oldProvider._value.maybeWhen(
        loading: () {},
        orElse: () => throw UnsupportedError(
          'Once an overide was built with a data/error, its state cannot change',
        ),
      );

      provider._value.when(
        data: _completer.complete,
        // Never reached. Either it doesn't enter the if, or it throws before
        loading: () {},
        error: _completer.completeError,
      );
    }
  }

  @override
  FutureProviderValue<Res> createProviderValue() {
    return FutureProviderValue._(future: _completer.future);
  }
}
