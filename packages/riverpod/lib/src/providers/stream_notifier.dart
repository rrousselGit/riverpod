import 'dart:async';

import 'package:meta/meta.dart';

import '../builder.dart';
import '../core/async_value.dart';
import '../framework.dart';
import 'future_provider.dart' show FutureProvider;

part 'stream_notifier/family.dart';
part 'stream_notifier/orphan.dart';

abstract class _StreamNotifierBase<StateT> extends ClassBase< //
        AsyncValue<StateT>,
        Stream<StateT>> //
    with
        AsyncClassMixin<StateT, Stream<StateT>> {}

abstract base class _StreamNotifierProviderBase<
        NotifierT extends _StreamNotifierBase<StateT>, //
        StateT> //
    extends ClassProvider< //
        NotifierT,
        AsyncValue<StateT>,
        Stream<StateT>,
        Ref<AsyncValue<StateT>>> //
    with
        FutureModifier<StateT> {
  const _StreamNotifierProviderBase(
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
