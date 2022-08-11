import 'internals.dart';
import 'listenable.dart';
import 'result.dart';
import 'state_controller.dart';

part 'state_provider/auto_dispose.dart';
part 'state_provider/base.dart';

ProviderElementProxy<T, StateController<T>> _notifier<T>(
  _StateProviderBase<T> that,
) {
  return ProviderElementProxy<T, StateController<T>>(
    that,
    (element) {
      if (element is StateProviderElement<T>) {
        return element._controllerNotifier;
      }

      throw UnsupportedError('Unknown element type ${element.runtimeType}');
    },
  );
}

ProviderElementProxy<T, StateController<T>> _state<T>(
  _StateProviderBase<T> that,
) {
  return ProviderElementProxy<T, StateController<T>>(
    that,
    (element) {
      if (element is StateProviderElement<T>) {
        return element._stateNotifier;
      }

      throw UnsupportedError('Unknown element type ${element.runtimeType}');
    },
  );
}

abstract class _StateProviderBase<T> extends ProviderBase<T> {
  _StateProviderBase({
    required super.name,
    required super.from,
    required super.argument,
    required this.dependencies,
    required super.cacheTime,
    required super.disposeDelay,
  });

  @override
  final List<ProviderOrFamily>? dependencies;

  ProviderListenable<StateController<T>> get notifier;
  ProviderListenable<StateController<T>> get state;

  T _create(covariant StateProviderElement<T> ref);

  @override
  bool updateShouldNotify(T previousState, T newState) {
    return true;
  }
}
