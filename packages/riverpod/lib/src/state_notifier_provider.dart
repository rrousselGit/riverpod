import 'package:state_notifier/state_notifier.dart';

import 'builders.dart';
import 'framework.dart';
import 'provider.dart';

part 'state_notifier_provider/base.dart';
part 'state_notifier_provider/auto_dispose.dart';

mixin _StateNotifierStateProviderStateMixin<T>
    on ProviderStateBase<StateNotifier<T>, T> {
  void Function() removeListener;

  @override
  void valueChanged({StateNotifier<T> previous}) {
    assert(
      createdValue != null,
      'StateNotifierProvider must return a non-null value',
    );
    if (createdValue == previous) {
      return;
    }
    removeListener?.call();
    removeListener = createdValue.addListener(_listener);
  }

  // ignore: use_setters_to_change_properties
  void _listener(T value) {
    exposedValue = value;
  }

  @override
  void dispose() {
    removeListener?.call();
    super.dispose();
  }
}
