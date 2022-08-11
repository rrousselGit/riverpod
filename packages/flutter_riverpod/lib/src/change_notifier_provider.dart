import 'package:flutter/widgets.dart';
// ignore: implementation_imports
import 'package:riverpod/src/internals.dart';

import 'builders.dart';

part 'change_notifier_provider/auto_dispose.dart';
part 'change_notifier_provider/base.dart';

ProviderElementProxy<NotifierT, NotifierT>
    _notifier<NotifierT extends ChangeNotifier?>(
  _ChangeNotifierProviderBase<NotifierT> that,
) {
  return ProviderElementProxy<NotifierT, NotifierT>(
    that,
    (element) {
      if (element is ChangeNotifierProviderElement<NotifierT>) {
        return element._notifierNotifier;
      }

      throw UnsupportedError('Unknown element type ${element.runtimeType}');
    },
  );
}

// ignore: subtype_of_sealed_class
/// {@template riverpod.changenotifierprovider}
/// Creates a [ChangeNotifier] and subscribes to it.
///
/// Note: By using Riverpod, [ChangeNotifier] will no longer be O(N^2) for
/// dispatching notifications, but instead O(N)
/// {@endtemplate}
abstract class _ChangeNotifierProviderBase<NotifierT extends ChangeNotifier?>
    extends ProviderBase<NotifierT> {
  _ChangeNotifierProviderBase({
    required super.name,
    required super.from,
    required super.argument,
    required this.dependencies,
    required super.cacheTime,
    required super.disposeDelay,
  });

  @override
  final List<ProviderOrFamily>? dependencies;

  /// Obtains the [ChangeNotifier] associated with this provider, without listening
  /// to state changes.
  ///
  /// This is typically used to invoke methods on a [ChangeNotifier]. For example:
  ///
  /// ```dart
  /// Button(
  ///   onTap: () => ref.read(changeNotifierProvider.notifer).increment(),
  /// )
  /// ```
  ///
  /// This listenable will notify its notifiers if the [ChangeNotifier] instance
  /// changes.
  /// This may happen if the provider is refreshed or one of its dependencies
  /// has changes.
  ProviderListenable<NotifierT> get notifier;

  NotifierT _create(covariant ChangeNotifierProviderElement<NotifierT> ref);

  @override
  bool updateShouldNotify(NotifierT previousState, NotifierT newState) => true;
}
