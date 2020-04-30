import 'dart:async';

import 'package:meta/meta.dart';

import '../combiner.dart';
import '../common.dart';
import '../framework/framework.dart';

part 'future_provider_builder.dart';
part 'future_provider1.dart';

class FutureProviderValue<T> extends BaseProviderValue {
  FutureProviderValue._({
    @required this.future,
  });

  final Future<T> future;
}

abstract class FutureProvider<Res>
    extends BaseProvider<FutureProviderValue<Res>, AsyncValue<Res>> {
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
    extends KeepAliveProvider<FutureProviderValue<Res>, AsyncValue<Res>>
    with _FutureProviderMixin<Res> {
  _FutureProviderKeepAlive(FutureProvider<Res> origin) : super(origin);
}

class _FutureProvider<Res>
    extends BaseProvider<FutureProviderValue<Res>, AsyncValue<Res>>
    with _FutureProviderMixin<Res> {
  _FutureProvider(this._create);

  final Create<Future<Res>, ProviderState> _create;

  @override
  _FutureProviderState<Res> createState() {
    return _FutureProviderState<Res>();
  }
}

class _FutureProviderState<Res> extends BaseProviderState<
        FutureProviderValue<Res>, AsyncValue<Res>, _FutureProvider<Res>>
    with _FutureProviderStateMixin<Res, _FutureProvider<Res>> {
  @override
  Future<Res> create() {
    return provider._create(ProviderState(this));
  }
}

mixin _FutureProviderStateMixin<Res, Provider extends _FutureProviderMixin<Res>>
    on BaseProviderState<FutureProviderValue<Res>, AsyncValue<Res>, Provider> {
  Future<Res> _future;

  Future<Res> create();

  @override
  AsyncValue<Res> initState() {
    _future = create();
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
  FutureProviderValue<Res> createProviderState() {
    return FutureProviderValue._(future: _future);
  }
}

class _DebugFutureProviderValue<Res>
    extends BaseProvider<FutureProviderValue<Res>, AsyncValue<Res>>
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
  FutureProviderValue<Res> createProviderState() {
    return FutureProviderValue._(future: _completer.future);
  }
}
