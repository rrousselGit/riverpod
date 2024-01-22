import 'dart:async';

import 'package:meta/meta.dart';

import '../builder.dart';
import '../core/async_value.dart';
import '../framework.dart';
import 'future_provider.dart' show FutureProvider;
import 'notifier.dart';

part 'async_notifier/orphan.dart';
part 'async_notifier/family.dart';

@internal
abstract class AsyncNotifierBase<StateT> extends ClassBase< //
        AsyncValue<StateT>,
        FutureOr<StateT>> //
    with
        AsyncClassMixin<StateT, FutureOr<StateT>> {}

abstract base class _AsyncNotifierProviderBase< //
        NotifierT extends AsyncNotifierBase<StateT>,
        StateT> //
    extends ClassProvider< //
        NotifierT,
        AsyncValue<StateT>,
        FutureOr<StateT>,
        Ref<AsyncValue<StateT>>> //
    with
        FutureModifier<StateT> {
  const _AsyncNotifierProviderBase(
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
