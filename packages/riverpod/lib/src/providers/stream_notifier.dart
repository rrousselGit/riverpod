import 'dart:async';

import 'package:meta/meta.dart';

import '../builder.dart';
import '../core/async_value.dart';
import '../framework.dart';
import 'async_notifier.dart';
import 'future_provider.dart' show FutureProvider;
import 'stream_provider.dart';

part 'stream_notifier/family.dart';
part 'stream_notifier/orphan.dart';

/// Implementation detail of `riverpod_generator`.
/// Do not use.
abstract class $StreamNotifier<StateT> extends $AsyncNotifierBase<StateT>
    with $AsyncClassModifier<StateT, Stream<StateT>, StateT> {}

/// Implementation detail of `riverpod_generator`.
/// Do not use.
abstract base class $StreamNotifierProvider<
        NotifierT extends $StreamNotifier<StateT>, //
        StateT> //
    extends $ClassProvider< //
        NotifierT,
        AsyncValue<StateT>,
        StateT,
        Stream<StateT>> //
    with
        $FutureModifier<StateT> {
  /// Implementation detail of `riverpod_generator`.
  /// Do not use.
  const $StreamNotifierProvider({
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
  $StreamNotifierProviderElement<NotifierT, StateT> $createElement(
    $ProviderPointer pointer,
  ) {
    return $StreamNotifierProviderElement(pointer);
  }
}

/// Implementation detail of `riverpod_generator`.
/// Do not use.
@internal
class $StreamNotifierProviderElement< //
        NotifierT extends $StreamNotifier<StateT>,
        StateT> //
    extends $ClassProviderElement< //
        NotifierT,
        AsyncValue<StateT>,
        StateT,
        Stream<StateT>> //
    with
        FutureModifierElement<StateT>,
        FutureModifierClassElement<NotifierT, StateT, Stream<StateT>> {
  /// Implementation detail of `riverpod_generator`.
  /// Do not use.
  $StreamNotifierProviderElement(super.pointer);

  @override
  void handleValue(Ref ref, Stream<StateT> created) {
    handleStream(ref, () => created);
  }
}
