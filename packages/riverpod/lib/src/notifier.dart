import 'package:meta/meta.dart';

import 'framework.dart';
import 'listenable.dart';
import 'result.dart';

part 'notifier/base.dart';
part 'notifier/auto_dispose.dart';

abstract class NotifierBase<State> {
  void _setElement(ProviderElementBase<State> element);

  @protected
  State get state;

  @protected
  set state(State value);

  Ref<State> get ref;

  @visibleForOverriding
  State build();

  bool updateShouldNotify(State previous, State next) {
    return !identical(previous, next);
  }
}

ProviderElementProxy<T, NotifierT>
    _notifier<NotifierT extends NotifierBase<T>, T>(
  _NotifierProviderBase<NotifierT, T> that,
) {
  return ProviderElementProxy<T, NotifierT>(
    that,
    (element) {
      return (element as NotifierProviderElement<NotifierT, T>)
          ._notifierNotifier;
    },
  );
}

abstract class _NotifierProviderBase<NotifierT extends NotifierBase<T>, T>
    extends ProviderBase<T> {
  _NotifierProviderBase(
    this._createNotifier, {
    required super.name,
    required super.from,
    required super.argument,
    required this.dependencies,
    required super.cacheTime,
    required super.disposeDelay,
  });

  @override
  final List<ProviderOrFamily>? dependencies;

  /// Obtains the [Notifier] associated with this provider, without listening
  /// to state changes.
  ///
  /// This is typically used to invoke methods on a [Notifier]. For example:
  ///
  /// ```dart
  /// Button(
  ///   onTap: () => ref.read(stateNotifierProvider.notifer).increment(),
  /// )
  /// ```
  ///
  /// This listenable will notify its notifiers if the [Notifier] instance
  /// changes.
  /// This may happen if the provider is refreshed or one of its dependencies
  /// has changes.
  ProviderListenable<NotifierT> get notifier;

  final NotifierT Function() _createNotifier;

  @override
  bool updateShouldNotify(T previousState, T newState) {
    return !identical(previousState, newState);
  }
}
