import 'package:meta/meta.dart';

import '../riverpod.dart';
import 'builders.dart';
import 'framework.dart';
import 'listenable.dart';
import 'result.dart';

part 'notifier/base.dart';
part 'notifier/auto_dispose.dart';
part 'notifier/family.dart';
part 'notifier/auto_dispose_family.dart';

/// A base class for [NotifierBase].
///
/// Not meant for public consumption.
@internal
abstract class NotifierBase<State> {
  NotifierProviderElement<NotifierBase<State>, State> get _element;

  void _setElement(ProviderElementBase<State> element);

  /// The value currently exposed by this [Notifier].
  ///
  /// Invoking the setter will notify listeners if [updateShouldNotify] returns true.
  /// By default, this will compare the previous and new value using [identical].
  ///
  /// Reading [state] if the provider is out of date (such as if one of its
  /// dependency has changed) will trigger [Notifier.build] to be re-executed.
  ///
  /// If [Notifier.build] threw, reading [state] will rethow the exception.
  @protected
  State get state {
    _element.flush();
    // ignore: invalid_use_of_protected_member
    return _element.requireState;
  }

  set state(State value) {
    // ignore: invalid_use_of_protected_member
    _element.setState(value);
  }

  Ref<State> get ref;

  bool updateShouldNotify(State previous, State next) {
    return !identical(previous, next);
  }
}

ProviderElementProxy<T, NotifierT>
    _notifier<NotifierT extends NotifierBase<T>, T>(
  NotifierProviderBase<NotifierT, T> that,
) {
  return ProviderElementProxy<T, NotifierT>(
    that,
    (element) {
      return (element as NotifierProviderElement<NotifierT, T>)
          ._notifierNotifier;
    },
  );
}

/// An internal base class for [Notifier].
///
/// Not meant for public consumption.
@internal
abstract class NotifierProviderBase<NotifierT extends NotifierBase<T>, T>
    extends ProviderBase<T> {
  /// An internal base class for [Notifier].
  ///
  /// Not meant for public consumption.
  NotifierProviderBase(
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

  T _runNotifierBuild(NotifierBase<T> notifier);
}
