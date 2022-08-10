import 'package:state_notifier/state_notifier.dart';

import 'internals.dart';
import 'listenable.dart';
import 'result.dart';
import 'run_guarded.dart';

part 'state_notifier_provider/auto_dispose.dart';
part 'state_notifier_provider/base.dart';

ProviderElementProxy<T, NotifierT>
    _notifier<NotifierT extends StateNotifier<T>, T>(
  _StateNotifierProviderBase<NotifierT, T> that,
) {
  return ProviderElementProxy<T, NotifierT>(
    that,
    (element, setListen) {
      if (element is StateNotifierProviderElement<NotifierT, T>) {
        return element._notifierNotifier;
      }

      throw UnsupportedError('Unknown element type ${element.runtimeType}');
    },
  );
}

abstract class _StateNotifierProviderBase<NotifierT extends StateNotifier<T>, T>
    extends ProviderBase<T> {
  _StateNotifierProviderBase({
    required super.name,
    required super.from,
    required super.argument,
    required this.dependencies,
    required super.cacheTime,
    required super.disposeDelay,
  });

  @override
  final List<ProviderOrFamily>? dependencies;

  ProviderListenable<NotifierT> get notifier;

  NotifierT _create(covariant StateNotifierProviderElement<NotifierT, T> ref);

  @override
  bool updateShouldNotify(T previousState, T newState) => true;
}
