/// Exports all the implementation classes of providers, such as `Provider` vs `AutoDisposeProvider`.
///
/// This is useful if you want to use the `always_specify_types` lint. Otherwise,
/// import `package:riverpod/riverpod.dart` instead, to avoid polluting the auto-complete.
library all;

export 'riverpod.dart';

export 'src/future_provider.dart'
    show
        AutoDisposeFutureProvider,
        AutoDisposeFutureProviderFamily,
        FutureProvider,
        FutureProviderFamily;

export 'src/provider.dart'
    show
        AutoDisposeProvider,
        AutoDisposeProviderFamily,
        Provider,
        ProviderFamily;

export 'src/state_notifier_provider.dart'
    show
        AutoDisposeStateNotifierProvider,
        AutoDisposeStateNotifierProviderFamily,
        AutoDisposeStateNotifierStateProvider,
        StateNotifierProvider,
        StateNotifierProviderFamily,
        StateNotifierStateProvider,
        AutoDisposeStateNotifierStateProviderX,
        StateNotifierStateProviderX;

export 'src/state_provider.dart'
    show
        AutoDisposeStateProvider,
        AutoDisposeStateProviderFamily,
        StateController,
        StateProvider,
        StateProviderFamily,
        AutoDisposeStateFamilyX,
        StateFamilyX;

export 'src/stream_provider.dart'
    show
        AutoDisposeStreamProvider,
        AutoDisposeStreamProviderFamily,
        StreamProvider,
        StreamProviderFamily;
