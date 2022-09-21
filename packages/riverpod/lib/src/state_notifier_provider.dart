import 'package:state_notifier/state_notifier.dart';

import 'internals.dart';

part 'state_notifier_provider/auto_dispose.dart';
part 'state_notifier_provider/base.dart';

ProviderElementProxy<T, NotifierT>
    _notifier<NotifierT extends StateNotifier<T>, T>(
  _StateNotifierProviderBase<NotifierT, T> that,
) {
  return ProviderElementProxy<T, NotifierT>(
    that,
    (element) {
      return (element as StateNotifierProviderElement<NotifierT, T>)
          ._notifierNotifier;
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
    required super.debugGetCreateSourceHash,
  });

  @override
  final List<ProviderOrFamily>? dependencies;

  /// Obtains the [StateNotifier] associated with this provider, without listening
  /// to state changes.
  ///
  /// This is typically used to invoke methods on a [StateNotifier]. For example:
  ///
  /// ```dart
  /// Button(
  ///   onTap: () => ref.read(stateNotifierProvider.notifer).increment(),
  /// )
  /// ```
  ///
  /// This listenable will notify its notifiers if the [StateNotifier] instance
  /// changes.
  /// This may happen if the provider is refreshed or one of its dependencies
  /// has changes.
  ProviderListenable<NotifierT> get notifier;

  NotifierT _create(covariant StateNotifierProviderElement<NotifierT, T> ref);
}
