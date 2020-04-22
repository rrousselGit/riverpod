import 'dart:async';

import 'package:flutter/widgets.dart';

import '../combiner.dart';
import '../common.dart';
import '../framework.dart';
import '../provider/provider.dart' show ProviderBuilder;

part 'future_provider_builder.dart';
part 'future_provider1.dart';

/// A placeholder used by [FutureProvider]/[FutureProviderX].
///
/// It has no purpose other than working around language limitations on generic
/// parameters through extension methods.
/// See https://github.com/dart-lang/language/issues/620
class FutureProviderValue<T> {
  FutureProviderValue._({
    @required Future<T> future,
    @required AsyncValue<T> value,
  })  : _future = future,
        _value = value;

  final Future<T> _future;
  final AsyncValue<T> _value;
}

extension FutureProviderX<T> on ProviderListenerState<FutureProviderValue<T>> {
  /// The [Future] returned by the callback of [FutureProvider].
  ///
  /// When using [FutureProvider.debugOverrideFromValue], this [Future] is
  /// mocked based on the status of the [AsyncValue] passed.
  Future<T> get future => $instance._future;
}

class FutureProvider<Res>
    extends BaseProvider<FutureProviderValue<Res>>
    with _FutureProviderMixin<Res> {
  FutureProvider(this._create);

  final Create<Future<Res>, ProviderState> _create;

  @override
  _FutureProviderState<Res> createState() {
    return _FutureProviderState<Res>();
  }
}

mixin _FutureProviderMixin<Res> on BaseProvider<FutureProviderValue<Res>> {
  AsyncValue<Res> call() {
    return BaseProvider.use(this)._value;
  }

  ProviderOverride debugOverrideFromValue(AsyncValue<Res> value) {
    return overrideForSubtree(
      _DebugFutureProviderValue(value),
    );
  }
}

class _FutureProviderState<Res>
    extends BaseProviderState<FutureProviderValue<Res>, FutureProvider<Res>>
    with _FutureProviderStateMixin<Res, FutureProvider<Res>> {
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
        state = FutureProviderValue._(
          future: _future,
          value: AsyncValue.data(value),
        );
      }
    } catch (err, stack) {
      if (mounted) {
        state = FutureProviderValue._(
          future: _future,
          value: AsyncValue.error(err, stack),
        );
      }
    }
  }
}

class _DebugFutureProviderValue<Res>
    extends BaseProvider<FutureProviderValue<Res>> {
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
        loading: () {},
        error: _completer.completeError,
      );
    }
  }
}
