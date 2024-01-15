// TODO CHANGELOG breaking: Riverpod now only re-exports StateNotifier from pkg:state_notifier.
//  for other classes, please add state_notifier as dependency.
export 'package:state_notifier/state_notifier.dart' show StateNotifier;

// TODO assert all provider variants have const constructors

export 'src/core/async_value.dart' hide AsyncTransition;
export 'src/framework.dart'
    hide
        ProviderScheduler,
        debugCanModifyProviders,
        Vsync,
        _ValueProviderElement,
        ValueProvider,
        FamilyCreate,
        AsyncSelector,
        FunctionalFamily,
        AutoDisposeProviderElementMixin,
        FamilyOverride,
        ClassFamily,
        SetupFamilyOverride,
        SetupOverride,
        AutoDisposeNotifierFamilyBase,
        ProviderOverride,
        AutoDisposeFamilyBase,
        DebugGetCreateSourceHash,
        ClassProviderFactory,
        FunctionalProviderFactory,
        computeAllTransitiveDependencies,
        Create,
        Node,
        ProviderElementProxy,
        OnError,
        ProviderContainerTest,
        DebugRiverpodDevtoolBiding,
        TransitiveFamilyOverride,
        TransitiveProviderOverride,
        ProviderPointer,
        ProviderPointerManager,
        ProviderDirectory;

export 'src/providers/async_notifier.dart'
    hide
        AsyncNotifierProviderImpl,
        AutoDisposeAsyncNotifierProviderImpl,
        AutoDisposeFamilyAsyncNotifierProviderImpl,
        FamilyAsyncNotifierProviderImpl,
        _AsyncNotifierBase,
        AsyncNotifierProviderBase,
        CancelAsyncSubscription,
        BuildlessAsyncNotifier,
        BuildlessAutoDisposeAsyncNotifier,
        FutureHandlerProviderElementMixin,
        FamilyStreamNotifierProviderImpl,
        StreamNotifierProviderImpl,
        AutoDisposeStreamNotifierProviderImpl,
        AutoDisposeFamilyStreamNotifierProviderImpl,
        StreamNotifierProviderBase,
        BuildlessAutoDisposeStreamNotifier,
        BuildlessStreamNotifier;

// TODO changelog breaking: StateNotifier & co are no-longer exported from pkg:riverpod/riverpod.dart
//  Use pkg:riverpod/legacy.dart

export 'src/providers/future_provider.dart';
export 'src/providers/notifier.dart'
    hide
        NotifierBase,
        NotifierProviderBase,
        AutoDisposeFamilyNotifierProviderImpl,
        AutoDisposeNotifierProviderImpl,
        FamilyNotifierProviderImpl,
        NotifierProviderImpl,
        BuildlessAutoDisposeNotifier,
        BuildlessNotifier;
export 'src/providers/provider.dart' hide InternalProvider;
export 'src/providers/stream_provider.dart';
