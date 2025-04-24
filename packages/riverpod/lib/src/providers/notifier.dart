import 'package:meta/meta.dart';

import '../builder.dart';
import '../common/internal_lints.dart';
import '../common/result.dart';
import '../framework.dart';
import 'async_notifier.dart';
import 'provider.dart';

part 'notifier/orphan.dart';
part 'notifier/family.dart';

/// A base class for [$Notifier].
/// Not meant for public consumption.
@publicInCodegen
abstract class $Notifier<StateT> extends $SyncNotifierBase<StateT> {
  @override
  @protected
  @visibleForTesting
  StateT get state;

  /// The value currently exposed by this [Notifier].
  ///
  /// As opposed to [state], this is guaranteed to be safe to use inside [Notifier.build].
  /// If used inside [Notifier.build], may return null if the notifier is not yet initialized.
  /// It will also return null if [Notifier.build] threw.
  ///
  /// Invoking the setter will notify listeners if [updateShouldNotify] returns true.
  ///
  /// Reading [stateOrNull] if the provider is out of date (such as if one of its
  /// dependency has changed) will trigger [Notifier.build] to be re-executed.
  @protected
  @visibleForTesting
  StateT? get stateOrNull {
    final element = this.element();
    if (element == null) throw StateError(uninitializedElementError);

    element.flush();
    return element.stateResult?.value;
  }
}

/// An implementation detail of `riverpod_generator`.
/// Do not use.
@publicInCodegen
abstract base class $NotifierProvider //
    <NotifierT extends $Notifier<StateT>, StateT>
    extends $ClassProvider<NotifierT, StateT, StateT, StateT> {
  /// An internal base class for [Notifier].
  ///
  /// Not meant for public consumption.
  const $NotifierProvider({
    required super.name,
    required super.from,
    required super.argument,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.isAutoDispose,
    required super.retry,
  });

  @internal
  @override
  $NotifierProviderElement<NotifierT, StateT> $createElement(
    $ProviderPointer pointer,
  ) {
    return $NotifierProviderElement(pointer);
  }
}

/// An implementation detail of `riverpod_generator`.
/// Do not use.
@internal
@publicInCodegen
class $NotifierProviderElement< //
        NotifierT extends $Notifier<StateT>,
        StateT> //
    extends $ClassProviderElement< //
        NotifierT,
        StateT,
        StateT,
        StateT> {
  /// An implementation detail of `riverpod_generator`.
  /// Do not use.
  $NotifierProviderElement(super.pointer);

  @override
  void handleError(Ref ref, Object error, StackTrace stackTrace) =>
      setStateResult($ResultError<StateT>(error, stackTrace));

  @override
  void handleValue(Ref ref, StateT created) =>
      setStateResult($ResultData(created));
}
