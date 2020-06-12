import 'package:state_notifier/state_notifier.dart';

import 'common.dart';
import 'framework/framework.dart';
import 'internals.dart';

// ignore: must_be_immutable, false positive, _state is immutable but lazy loaded.
class StateNotifierProvider<Notifier extends StateNotifier<Object>>
    extends Provider<Notifier> {
  StateNotifierProvider(
    Create<Notifier, ProviderReference> create, {
    String name,
  }) : super(
          (ref) {
            final notifier = create(ref);
            ref.onDispose(notifier.dispose);
            return notifier;
          },
          name: name,
        );

  SetStateProvider<Object> _state;
}

/// Adds [state] to [StateNotifierProvider].
///
/// This is done as an extension as a workaround to language limitations.
extension StateNotifierStateProviderX<Value>
    on StateNotifierProvider<StateNotifier<Value>> {
  SetStateProvider<Value> get state {
    _state ??= StateNotifierStateProvider<Value>(this);
    return _state as StateNotifierStateProvider<Value>;
  }
}

class StateNotifierStateProvider<T> extends SetStateProvider<T> {
  StateNotifierStateProvider(this.controller)
      : super((ref) {
          final notifier = ref.dependOn(controller).value;

          ref.onDispose(
            notifier.addListener((newValue) => ref.state = newValue),
          );

          return ref.state;
        }, name: controller.name == null ? null : '${controller.name}.state');

  final StateNotifierProvider<StateNotifier<T>> controller;
}
