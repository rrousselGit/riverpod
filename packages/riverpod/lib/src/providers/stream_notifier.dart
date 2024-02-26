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
        Stream<StateT>,
        Ref<AsyncValue<StateT>>> //
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
  });
}

/// Implementation detail of `riverpod_generator`.
/// Do not use.
class $StreamNotifierProviderElement< //
        NotifierT extends $StreamNotifier<StateT>,
        StateT> //
    extends ClassProviderElement< //
        NotifierT,
        AsyncValue<StateT>,
        Stream<StateT>> //
    with
        FutureModifierElement<StateT> {
  /// Implementation detail of `riverpod_generator`.
  /// Do not use.
  $StreamNotifierProviderElement(this.provider, super.container);

  @override
  final $StreamNotifierProvider<NotifierT, StateT> provider;

  @override
  void handleError(
    Object error,
    StackTrace stackTrace, {
    required bool didChangeDependency,
  }) {
    onError(AsyncError(error, stackTrace), seamless: !didChangeDependency);
  }

  @override
  void handleValue(
    Stream<StateT> created, {
    required bool didChangeDependency,
  }) {
    handleStream(
      () => created,
      didChangeDependency: didChangeDependency,
    );
  }
}
