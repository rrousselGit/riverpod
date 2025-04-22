import 'dart:async';

import 'package:meta/meta.dart';

import '../builder.dart';
import '../common/internal_lints.dart';
import '../core/async_value.dart';
import '../framework.dart';
import 'future_provider.dart' show FutureProvider;
import 'notifier.dart';

part 'async_notifier/orphan.dart';
part 'async_notifier/family.dart';

/// Implementation detail of `riverpod_generator`.
/// Do not use.
@Public.inLibrary('riverpod_annotation')
abstract class $AsyncNotifier<StateT> extends $AsyncNotifierBase<StateT>
    with $AsyncClassModifier<StateT, FutureOr<StateT>, StateT> {}

/// Implementation detail of `riverpod_generator`.
/// Do not use.
@Public.inLibrary('riverpod_annotation')
abstract base class $AsyncNotifierProvider< //
        NotifierT extends $AsyncNotifier<StateT>,
        StateT> //
    extends $ClassProvider< //
        NotifierT,
        AsyncValue<StateT>,
        StateT,
        FutureOr<StateT>> //
    with
        $FutureModifier<StateT> {
  /// Implementation detail of `riverpod_generator`.
  /// Do not use.
  const $AsyncNotifierProvider({
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
  $AsyncNotifierProviderElement<NotifierT, StateT> $createElement(
    $ProviderPointer pointer,
  ) {
    return $AsyncNotifierProviderElement(pointer);
  }
}

/// Implementation detail of `riverpod_generator`.
/// Do not use.
@internal
@Public.inLibrary('riverpod_annotation')
class $AsyncNotifierProviderElement< //
        NotifierT extends $AsyncNotifier<StateT>,
        StateT> //
    extends $ClassProviderElement< //
        NotifierT,
        AsyncValue<StateT>,
        StateT,
        FutureOr<StateT>> //
    with
        FutureModifierElement<StateT>,
        FutureModifierClassElement<NotifierT, StateT, FutureOr<StateT>> {
  /// Implementation detail of `riverpod_generator`.
  /// Do not use.
  $AsyncNotifierProviderElement(super.pointer);

  @override
  void handleValue(Ref ref, FutureOr<StateT> created) {
    handleFuture(ref, () => created);
  }
}
