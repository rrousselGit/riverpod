part of 'async_notifier.dart';

abstract base class _StreamNotifierProviderBase<
        NotifierT extends _AsyncNotifierBase<StateT>, //
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
  });

  final NotifierT Function() _createNotifier;
}

/// {@template riverpod.streamNotifier}
/// A variant of [AsyncNotifier] which has [build] creating a [Stream].
///
/// This can be considered as a [StreamProvider] that can mutate its value over time.
///
/// The syntax for using this provider is slightly different from the others
/// in that the provider's function doesn't receive a "ref" (and in case
/// of `family`, doesn't receive an argument either).
/// Instead the ref (and argument) are directly accessible in the associated
/// [AsyncNotifier].
///
/// This can be considered as a [StreamProvider] that can mutate its value over time.
/// When using `family`, your notifier type changes. Instead of extending
/// [StreamNotifier], you should extend [FamilyStreamNotifier].
/// {@endtemplate}
abstract class StreamNotifier<StateT> extends _AsyncNotifierBase<StateT> {
  @override
  Ref<AsyncValue<StateT>> get ref {
    final element = _element;
    if (element == null) throw StateError(uninitializedElementError);

    return element;
  }

  /// {@macro riverpod.async_notifier.build}
  @visibleForOverriding
  Stream<StateT> build();
}

// TODO hide all Elements and CreateElements from public API
class _StreamNotifierProviderElement< //
        NotifierT extends _AsyncNotifierBase<StateT>,
        StateT> //
    extends ProviderElementBase<AsyncValue<StateT>>
    with
        ClassProviderElement<NotifierT, AsyncValue<StateT>>,
        FutureModifierElement<StateT> {
  _StreamNotifierProviderElement(this.provider, super.container);

  @override
  final _StreamNotifierProviderBase<NotifierT, StateT> provider;

  @override
  void create({required bool didChangeDependency}) {
    final notifierResult = classListenable.result ??= Result.guard(() {
      return provider._createNotifier().._setElement(this);
    });

    notifierResult.when(
      error: (error, stackTrace) {
        onError(AsyncError(error, stackTrace), seamless: !didChangeDependency);
      },
      data: (notifier) {
        handleStream(
          () => provider.runNotifierBuild(this, notifier),
          didChangeDependency: didChangeDependency,
        );
      },
    );
  }
}
