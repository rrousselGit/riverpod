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

export 'src/legacy_providers/async_notifier.dart'
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
export 'src/legacy_providers/deprecated/state_controller.dart';
export 'src/legacy_providers/deprecated/state_notifier_provider.dart';
export 'src/legacy_providers/deprecated/state_provider.dart';
export 'src/legacy_providers/future_provider.dart';
export 'src/legacy_providers/notifier.dart'
    hide
        NotifierBase,
        NotifierProviderBase,
        AutoDisposeFamilyNotifierProviderImpl,
        AutoDisposeNotifierProviderImpl,
        FamilyNotifierProviderImpl,
        NotifierProviderImpl,
        BuildlessAutoDisposeNotifier,
        BuildlessNotifier;
export 'src/legacy_providers/provider.dart' hide InternalProvider;
export 'src/legacy_providers/stream_provider.dart';
