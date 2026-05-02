import 'package:hooks_riverpod/hooks_riverpod.dart';

class StateNotifier<ValueT> extends Notifier<ValueT> {
  StateNotifier(this._builder);
  final ValueT Function(Ref ref, StateNotifier<ValueT> self) _builder;

  // Remove protected
  @override
  abstract ValueT state;

  // Remove protected
  @override
  ValueT? get stateOrNull;

  @override
  ValueT build() => _builder(ref, this);
}
