import 'package:meta/meta.dart';

import 'async_notifier.dart';
import 'builders.dart';
import 'framework.dart';
import 'listenable.dart';
import 'result.dart';

part 'notifier/auto_dispose.dart';
part 'notifier/auto_dispose_family.dart';
part 'notifier/base.dart';
part 'notifier/family.dart';

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

  /// The [Ref] from the provider associated with this [AsyncNotifier].
  Ref<State> get ref;

  /// A method invoked when the state exposed by this [Notifier] changes.
  /// It compares the previous and new value, and return whether listeners
  /// should be notified.
  ///
  /// By default, the previous and new value are compared using [identical]
  /// for performance reasons.
  ///
  /// Doing so ensured that doing:
  ///
  /// ```dart
  /// state = 42;
  /// state = 42;
  /// ```
  ///
  /// does not notify listeners twice.
  ///
  /// But at the same time, for very complex objects with potentially dozens
  /// if not hundreds of properties, Riverpod won't deeply compare every single
  /// value.
  ///
  /// This ensures that the comparison stays efficient for the most common scenarios.
  /// But it also means that listeners should be notified even if the
  /// previous and new values are considered "equal".
  ///
  /// If you do not want that, you can override this method to perform a deep
  /// comparison of the previous and new values.
  @protected
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
    required super.debugGetCreateSourceHash,
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

  /// Runs the `build` method of a notifier.
  ///
  /// This is an implementation detail for differentiating [Notifier.build]
  /// from [FamilyNotifier.build].
  @visibleForOverriding
  T runNotifierBuild(NotifierBase<T> notifier);
}
