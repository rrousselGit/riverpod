import 'package:state_notifier/state_notifier.dart';

import 'common.dart';
import 'framework/framework.dart';
import 'internals.dart';

// ignore: must_be_immutable, false positive, value is immutable.
class StateNotifierProvider<Notifier extends StateNotifier<Value>, Value>
    extends Provider<Notifier> {
  StateNotifierProvider(Create<Notifier, ProviderContext> create)
      : super((context) {
          final notifier = create(context);
          context.onDispose(notifier.dispose);
          return notifier;
        });

  // TODO replace with `late final` when available
  SetStateProvider<Value> _valueProvider;
  SetStateProvider<Value> get value {
    return _valueProvider ??= SetStateProvider((context) {
      final notifier = context.dependOn(this).value;

      context.onDispose(
        notifier.addListener((newValue) => context.state = newValue),
      );

      return context.state;
    });
  }
}
