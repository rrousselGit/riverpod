import 'dart:async';

import 'package:meta/meta.dart';

import '../builder.dart';
import '../common/internal_lints.dart';
import '../framework.dart';
import 'future_provider.dart' show FutureProvider;
import 'notifier.dart';

part 'async_notifier/orphan.dart';
part 'async_notifier/family.dart';

/// Implementation detail of `riverpod_generator`.
/// Do not use.
@publicInCodegen
abstract class $AsyncNotifier<ValueT> extends $AsyncNotifierBase<ValueT>
    with $AsyncClassModifier<ValueT, FutureOr<ValueT>> {}

/// Implementation detail of `riverpod_generator`.
/// Do not use.
@publicInCodegen
abstract base class $AsyncNotifierProvider< //
        NotifierT extends $AsyncNotifier<ValueT>,
        ValueT> //
    extends $ClassProvider< //
        NotifierT,
        AsyncValue<ValueT>,
        ValueT,
        FutureOr<ValueT>> //
    with
        $FutureModifier<ValueT> {
  /// Implementation detail of `riverpod_generator`.
  /// Do not use.
  const $AsyncNotifierProvider({
    required super.name,
    required super.from,
    required super.argument,
    required super.dependencies,
    required super.$allTransitiveDependencies,
    required super.isAutoDispose,
    required super.retry,
  });

  /// @nodoc
  @internal
  @override
  $AsyncNotifierProviderElement<NotifierT, ValueT> $createElement(
    $ProviderPointer pointer,
  ) {
    return $AsyncNotifierProviderElement(pointer);
  }

  /// @nodoc
  @override
  String toString() => super.toString();
}

/// Implementation detail of `riverpod_generator`.
/// Do not use.
@internal
@publicInCodegen
class $AsyncNotifierProviderElement< //
        NotifierT extends $AsyncNotifier<ValueT>,
        ValueT> //
    extends $ClassProviderElement< //
        NotifierT,
        AsyncValue<ValueT>,
        ValueT,
        FutureOr<ValueT>> //
    with
        FutureModifierElement<ValueT>,
        FutureModifierClassElement<NotifierT, ValueT, FutureOr<ValueT>> {
  /// Implementation detail of `riverpod_generator`.
  /// Do not use.
  $AsyncNotifierProviderElement(super.pointer);

  @override
  void handleValue(Ref ref, FutureOr<ValueT> created) {
    handleFuture(ref, () => created);
  }
}
