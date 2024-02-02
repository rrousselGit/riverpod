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

@internal
abstract base class AsyncNotifierProviderBase< //
        NotifierT extends AsyncNotifierBase<StateT>,
        StateT> //
    extends ClassProvider< //
        NotifierT,
        AsyncValue<StateT>,
        FutureOr<StateT>,
        Ref<AsyncValue<StateT>>> //
    with
        $FutureModifier<StateT> {
  const AsyncNotifierProviderBase(
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

class _AsyncNotifierProviderElement< //
        NotifierT extends AsyncNotifierBase<StateT>,
        StateT> //
    extends ClassProviderElement< //
        NotifierT,
        AsyncValue<StateT>,
        FutureOr<StateT>> //
    with
        FutureModifierElement<StateT> {
  _AsyncNotifierProviderElement(this.provider, super.container);

  @override
  final AsyncNotifierProviderBase<NotifierT, StateT> provider;

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
    FutureOr<StateT> created, {
    required bool didChangeDependency,
  }) {
    handleFuture(
      () => created,
      didChangeDependency: didChangeDependency,
    );
  }
}
