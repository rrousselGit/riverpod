import 'package:hooks_riverpod/hooks_riverpod.dart';

class StateNotifier<T> extends Notifier<T> {
  StateNotifier(this._builder);
  final T Function(Ref ref, StateNotifier<T> self) _builder;

  // Remove protected
  @override
  abstract T state;

  // Remove protected
  @override
  T? get stateOrNull;

  @override
  T build() => _builder(ref, this);
}
