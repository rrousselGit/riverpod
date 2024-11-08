import 'dart:async';

import 'package:meta/meta.dart';

import '../builder.dart';
import '../common/result.dart';
import '../core/async_value.dart';
import '../core/persist.dart';
import '../framework.dart';
import 'async_notifier.dart';
import 'future_provider.dart' show FutureProvider;
import 'stream_provider.dart';

part 'stream_notifier/family.dart';
part 'stream_notifier/orphan.dart';

/// Implementation detail of `riverpod_generator`.
/// Do not use.
abstract class $StreamNotifier<StateT> extends NotifierBase< //
        AsyncValue<StateT>,
        Stream<StateT>> //
    with
        $AsyncClassModifier<StateT, Stream<StateT>> {}

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
    required super.runNotifierBuildOverride,
    required super.retry,
    required super.persistOptions,
    required super.shouldPersist,
  });
}

/// Implementation detail of `riverpod_generator`.
/// Do not use.
@internal
class $StreamNotifierProviderElement< //
        NotifierT extends $StreamNotifier<StateT>,
        StateT> //
    extends ClassProviderElement< //
        NotifierT,
        AsyncValue<StateT>,
        StateT,
        Stream<StateT>> //
    with
        FutureModifierElement<StateT>,
        FutureModifierClassElement<NotifierT, StateT, Stream<StateT>> {
  /// Implementation detail of `riverpod_generator`.
  /// Do not use.
  $StreamNotifierProviderElement(this.provider, super.pointer);

  @override
  final $StreamNotifierProvider<NotifierT, StateT> provider;

  @override
  void handleValue(
    Stream<StateT> created, {
    required bool seamless,
    required bool isMount,
  }) {
    handleStream(
      () => created,
      seamless: seamless,
      isMount: isMount,
    );
  }

  @override
  void callDecode(
    PersistAdapter<StateT> adapter,
    Object? encoded,
  ) {
    setStateResult(Result.data(AsyncData(adapter.decode(encoded))));
  }
}
