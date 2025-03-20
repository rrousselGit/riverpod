part of '../framework.dart';

class _Group<KeyT, StateT> with Group<KeyT, StateT> {
  _Group(this._keyFor);
  final KeyT Function(StateT value) _keyFor;

  @override
  KeyT keyFor(StateT value) => _keyFor(value);
}

abstract mixin class Group<IdT, ValueT> {
  factory Group(IdT Function(ValueT value) keyFor) = _Group;

  late final bind = GroupBindBuilder<IdT, ValueT>(this);

  IdT keyFor(ValueT value);

  late final ProviderListenable<List<ValueT>> all = throw UnimplementedError();
  late final ProviderListenable<List<IdT>> keys = throw UnimplementedError();
  ProviderListenable<ValueT?> byId(IdT id) => throw UnimplementedError();
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
