import 'dart:async';

import 'package:meta/meta.dart';

import '../builder.dart';
import '../common/internal_lints.dart';
import '../framework.dart';
import 'async_notifier.dart';
import 'future_provider.dart' show FutureProvider;
import 'stream_provider.dart';

part 'stream_notifier/family.dart';
part 'stream_notifier/orphan.dart';

/// Implementation detail of `riverpod_generator`.
/// Do not use.
@publicInCodegen
abstract class $StreamNotifier<ValueT> extends $AsyncNotifierBase<ValueT>
    with $AsyncClassModifier<ValueT, Stream<ValueT>> {}

/// Implementation detail of `riverpod_generator`.
/// Do not use.
@publicInCodegen
abstract base class $StreamNotifierProvider<
        NotifierT extends $StreamNotifier<ValueT>, //
        ValueT> //
    extends $ClassProvider< //
        NotifierT,
        AsyncValue<ValueT>,
        ValueT,
        Stream<ValueT>> //
    with
        $FutureModifier<ValueT> {
  /// Implementation detail of `riverpod_generator`.
  /// Do not use.
  const $StreamNotifierProvider({
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
  $StreamNotifierProviderElement<NotifierT, ValueT> $createElement(
    $ProviderPointer pointer,
  ) {
    return $StreamNotifierProviderElement(pointer);
  }
}

/// Implementation detail of `riverpod_generator`.
/// Do not use.
@internal
@publicInCodegen
class $StreamNotifierProviderElement< //
        NotifierT extends $StreamNotifier<ValueT>,
        ValueT> //
    extends $ClassProviderElement< //
        NotifierT,
        AsyncValue<ValueT>,
        ValueT,
        Stream<ValueT>> //
    with
        FutureModifierElement<ValueT>,
        FutureModifierClassElement<NotifierT, ValueT, Stream<ValueT>> {
  /// Implementation detail of `riverpod_generator`.
  /// Do not use.
  $StreamNotifierProviderElement(super.pointer);

  @override
  void handleValue(Ref ref, Stream<ValueT> created) {
    handleStream(ref, () => created);
  }
}
