import 'package:state_notifier/state_notifier.dart';

import 'common.dart';
import 'framework/framework.dart';
import 'internals.dart';

// ignore: must_be_immutable, false positive, _value is immutable but lazy loaded.
class StateNotifierProvider<Notifier extends StateNotifier<Object>>
    extends Provider<Notifier> {
  StateNotifierProvider(Create<Notifier, ProviderReference> create)
      : super((ref) {
          final notifier = create(ref);
          ref.onDispose(notifier.dispose);
          return notifier;
        });

  SetStateProvider<Object> _value;
}

/// Adds [value] to [StateNotifierProvider].
/// 
/// This is done as an extension as a workaround to language limitations.
extension StateNotifierProviderValue<Value>
    on StateNotifierProvider<StateNotifier<Value>> {
  SetStateProvider<Value> get value {
    _value ??= SetStateProvider<Value>((ref) {
      final notifier = ref.dependOn(this).value;

      ref.onDispose(
        notifier.addListener((newValue) => ref.state = newValue),
      );

      return ref.state;
    });
    return _value as SetStateProvider<Value>;
  }
}
