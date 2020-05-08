import 'package:state_notifier/state_notifier.dart';

import 'common.dart';
import 'framework/framework.dart';
import 'internals.dart';

// ignore: must_be_immutable, false positive, value is immutable.
class StateNotifierProvider<Notifier extends StateNotifier<Value>, Value>
    extends Provider<Notifier> {
  StateNotifierProvider(Create<Notifier, ProviderState> create)
      : super((state) {
          final notifier = create(state);
          state.onDispose(notifier.dispose);
          return notifier;
        });

  // TODO replace with `late final` when available
  SetStateProvider<Value> _valueProvider;
  SetStateProvider<Value> get value {
    return _valueProvider ??= SetStateProvider((state) {
      final notifier = state.dependOn(this).value;

      state.onDispose(
        notifier.addListener((newValue) => state.state = newValue),
      );

      return state.state;
    });
  }
}
