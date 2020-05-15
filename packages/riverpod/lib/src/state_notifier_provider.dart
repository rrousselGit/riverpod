import 'package:state_notifier/state_notifier.dart';

import 'common.dart';
import 'framework/framework.dart';
import 'internals.dart';

// ignore: must_be_immutable, false positive, value is immutable.
class StateNotifierProvider<Notifier extends StateNotifier<Value>, Value>
    extends Provider<Notifier> {
  StateNotifierProvider(Create<Notifier, ProviderReference> create)
      : super((ref) {
          final notifier = create(ref);
          ref.onDispose(notifier.dispose);
          return notifier;
        });

  // TODO replace with `late final` when available
  SetStateProvider<Value> _valueProvider;
  SetStateProvider<Value> get value {
    return _valueProvider ??= SetStateProvider((ref) {
      final notifier = ref.dependOn(this).value;

      ref.onDispose(
        notifier.addListener((newValue) => ref.state = newValue),
      );

      return ref.state;
    });
  }
}
