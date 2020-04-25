import 'dart:async';

import 'package:meta/meta.dart';

import '../combiner.dart';
import '../common.dart';
import '../framework/framework.dart';

part 'future_provider_builder.dart';
part 'future_provider1.dart';

class FutureProviderValue<T> {
  FutureProviderValue._({
    @required Future<T> future,
    @required AsyncValue<T> value,
  })  : _future = future,
        _value = value;

  final Future<T> _future;
  final AsyncValue<T> _value;
}

extension $FutureProviderValue<T> on FutureProviderValue<T> {
  AsyncValue<T> get value => _value;
}

extension FutureProviderX<T> on ProviderListenerState<FutureProviderValue<T>> {
  Future<T> get future => $state._future;
}

abstract class FutureProvider<Res>
    extends BaseProvider<FutureProviderValue<Res>> {
  factory FutureProvider(
    Create<Future<Res>, ProviderState> create,
  ) = _FutureProvider<Res>;

  ProviderOverride debugOverrideFromValue(AsyncValue<Res> value);

  FutureProvider<Res> asKeepAlive();
}

mixin _FutureProviderMixin<Res> implements FutureProvider<Res> {
  @override
  ProviderOverride debugOverrideFromValue(AsyncValue<Res> value) {
    return overrideForSubtree(
      _DebugFutureProviderValue(value),
    );
  }

  @override
  FutureProvider<Res> asKeepAlive() {
    return _FutureProviderKeepAlive(this);
  }
}

class _FutureProviderKeepAlive<Res>
    extends KeepAliveProvider<FutureProviderValue<Res>>
    with _FutureProviderMixin<Res> {
  _FutureProviderKeepAlive(FutureProvider<Res> origin) : super(origin);
}

class _FutureProvider<Res> extends BaseProvider<FutureProviderValue<Res>>
    with _FutureProviderMixin<Res> {
  _FutureProvider(this._create);

  final Create<Future<Res>, ProviderState> _create;

  @override
  _FutureProviderState<Res> createState() {
    return _FutureProviderState<Res>();
  }
}

class _FutureProviderState<Res>
    extends BaseProviderState<FutureProviderValue<Res>, _FutureProvider<Res>>
    with _FutureProviderStateMixin<Res, _FutureProvider<Res>> {
  @override
  Future<Res> create() {
    return provider._create(this);
  }
}

mixin _FutureProviderStateMixin<Res, Provider extends _FutureProviderMixin<Res>>
    on BaseProviderState<FutureProviderValue<Res>, Provider> {
  Future<Res> _future;

  Future<Res> create();

  @override
  FutureProviderValue<Res> initState() {
    _future = create();
    _listen();

    return FutureProviderValue._(
      future: _future,
      value: const AsyncValue.loading(),
    );
  }

  Future<void> _listen() async {
    try {
      final value = await _future;
      if (mounted) {
        $state = FutureProviderValue._(
          future: _future,
          value: AsyncValue.data(value),
        );
      }
    } catch (err, stack) {
      if (mounted) {
        $state = FutureProviderValue._(
          future: _future,
          value: AsyncValue.error(err, stack),
        );
      }
    }
  }
}

class _DebugFutureProviderValue<Res>
    extends BaseProvider<FutureProviderValue<Res>>
    with _FutureProviderMixin<Res> {
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
    FutureProviderValue<Res>, _DebugFutureProviderValue<Res>> {
  final _completer = Completer<Res>();

  @override
  FutureProviderValue<Res> initState() {
    provider._value.when(
      data: _completer.complete,
      loading: () {},
      error: _completer.completeError,
    );

    return FutureProviderValue._(
      future: _completer.future,
      value: provider._value,
    );
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
}
