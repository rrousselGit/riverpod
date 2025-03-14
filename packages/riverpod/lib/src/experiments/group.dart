part of '../framework.dart';

class _Group<KeyT, StateT> with Group<KeyT, StateT> {
  _Group(this._keyFor);
  final KeyT Function(StateT value) _keyFor;

  @override
  KeyT keyFor(StateT value) => _keyFor(value);
}

abstract mixin class Group<KeyT, ValueT> {
  factory Group(KeyT Function(ValueT value) keyFor) = _Group;

  late final bind = GroupBindBuilder<KeyT, ValueT>(this);

  KeyT keyFor(ValueT value);

  late final ProviderListenable2<List<ValueT>> all = throw UnimplementedError();
  late final ProviderListenable2<List<KeyT>> keys = throw UnimplementedError();
  ProviderListenable2<ValueT?> byId(KeyT key) => throw UnimplementedError();
}

@internal
class GroupBindBuilder<KeyT, StateT> {
  GroupBindBuilder(this._group);
  final Group<KeyT, StateT> _group;

  GroupBind<R> call<R>({
    required Iterable<StateT> Function(R state) emit,
    required void Function(Ref2<R> ref, Iterable<StateT> updates) sync,
  }) =>
      throw UnimplementedError();

  GroupBind<AsyncValue<List<StateT>>> get asyncList =>
      throw UnimplementedError();
  GroupBind<List<StateT>> get list => throw UnimplementedError();
  GroupBind<AsyncValue<StateT>> get asyncValue => throw UnimplementedError();
  GroupBind<StateT> get value => throw UnimplementedError();
}

class GroupBind<ProviderT> {
  GroupBind<ProviderT?> get optional => throw UnimplementedError();
}
