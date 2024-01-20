import 'dart:async';

import 'package:meta/meta.dart';

import '../builder.dart';
import '../framework.dart';
import 'async_notifier.dart';

part 'notifier/orphan.dart';
part 'notifier/family.dart';

/// A base class for [_NotifierBase].
///
/// Not meant for public consumption.
abstract class _NotifierBase<StateT> extends ClassBase<StateT, StateT> {
  /// The value currently exposed by this [Notifier].
  ///
  /// If used inside [Notifier.build], may throw if the notifier is not yet initialized.
  ///
  /// Invoking the setter will notify listeners if [updateShouldNotify] returns true.
  /// By default, this will compare the previous and new value using [identical].
  ///
  /// Reading [state] if the provider is out of date (such as if one of its
  /// dependency has changed) will trigger [Notifier.build] to be re-executed.
  ///
  /// If [Notifier.build] threw, reading [state] will rethrow the exception.
  @override
  @protected
  @visibleForTesting
  StateT get state;

  /// The value currently exposed by this [Notifier].
  ///
  /// If used inside [Notifier.build], may return null if the notifier is not yet initialized.
  /// It will also return null if [Notifier.build] threw.
  ///
  /// Invoking the setter will notify listeners if [updateShouldNotify] returns true.
  /// By default, this will compare the previous and new value using [identical].
  ///
  /// Reading [stateOrNull] if the provider is out of date (such as if one of its
  /// dependency has changed) will trigger [Notifier.build] to be re-executed.
  @protected
  @visibleForTesting
  StateT? get stateOrNull {
    final element = this.element;
    if (element == null) throw StateError(uninitializedElementError);

    element.flush();
    return element.getState()?.stateOrNull;
  }

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
  @override
  @visibleForOverriding
  bool updateShouldNotify(StateT previous, StateT next) {
    // TODO unify updateShouldNotify to use == or identical everywhere
    return !identical(previous, next);
  }
}

abstract base class _NotifierProvider //
    <NotifierT extends _NotifierBase<StateT>, StateT>
    extends ClassProvider<NotifierT, StateT, StateT, Ref<StateT>> {
  /// An internal base class for [Notifier].
  ///
  /// Not meant for public consumption.
  const _NotifierProvider(
    this._createNotifier, {
    required super.name,
    required super.from,
    required super.argument,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.isAutoDispose,
    required super.runNotifierBuildOverride,
  });

  final NotifierT Function() _createNotifier;

  @override
  NotifierT create() => _createNotifier();
}
