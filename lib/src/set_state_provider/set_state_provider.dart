import 'dart:async';

import 'package:flutter/widgets.dart';

import '../combiner.dart';
import '../common.dart';
import '../framework.dart';
import '../provider/provider.dart' show ProviderBuilder;

part 'set_state_provider_builder.dart';
part 'set_state_provider1.dart';

/// A placeholder used by [SetStateProvider]/[SetStateProviderX].
///
/// It has no purpose other than working around language limitations on generic
/// parameters through extension methods.
/// See https://github.com/dart-lang/language/issues/620
class SetStateProviderValue<T> {
  SetStateProviderValue._({
    @required T value,
    @required void Function(void Function(T) listener) onChange,
  })  : _value = value,
        _onChange = onChange;

  final T _value;
  final void Function(void Function(T) listener) _onChange;
}

extension SetStateProviderX<T>
    on ProviderListenerState<SetStateProviderValue<T>> {
  void onChange(void Function(T) listener) => $instance._onChange(listener);
}

abstract class SetStateProvider<Res>
    extends BaseProvider<SetStateProviderValue<Res>> {
  factory SetStateProvider(
    Create<Res, SetStateProviderState<Res>> create,
  ) = _SetStateProvider<Res>;

  @override
  Res call();
}

abstract class SetStateProviderState<Res> extends ProviderState {
  Res get state;
  void setState(Res state);
}

mixin _SetStateProviderMixin<Res> implements SetStateProvider<Res> {
  @override
  Res call() {
    return BaseProvider.use(this)._value;
  }
}

class _SetStateProvider<Res> extends BaseProvider<SetStateProviderValue<Res>>
    with _SetStateProviderMixin<Res> {
  _SetStateProvider(this._create);

  final Create<Res, SetStateProviderState<Res>> _create;

  @override
  _SetStateProviderState<Res> createState() {
    return _SetStateProviderState<Res>();
  }
}

class _SetStateProviderState<Res> extends BaseProviderState<
        SetStateProviderValue<Res>, _SetStateProvider<Res>>
    with _SetStateProviderStateMixin<Res, _SetStateProvider<Res>> {
  @override
  Res create() {
    return provider._create(this);
  }
}

mixin _SetStateProviderStateMixin<Res,
        Provider extends _SetStateProviderMixin<Res>>  implements SetStateProviderState<Res>
    on BaseProviderState<SetStateProviderValue<Res>, Provider> {
  Res create();

  @override
  SetStateProviderValue<Res> initState() {
    return SetStateProviderValue._(
      value: create(),
      onChange: _onChange,
    );
  }

  void _onChange(void Function(Res) listener) {
    addListener((v) => listener(v._value), fireImmediately: false);
  }
}