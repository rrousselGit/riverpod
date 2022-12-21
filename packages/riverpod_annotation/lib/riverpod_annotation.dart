export 'dart:async' show FutureOr;

// ignore: invalid_export_of_internal_element
export 'package:riverpod/src/internals.dart'
    show
        // General stuff
        Family,
        ProviderOrFamily,

        // Provider
        Provider,
        ProviderFamily,
        ProviderRef,
        AutoDisposeProvider,
        AutoDisposeProviderFamily,
        AutoDisposeProviderRef,
        ProviderElement,
        AutoDisposeProviderElement,

        // FutureProvider
        FutureProvider,
        FutureProviderFamily,
        FutureProviderRef,
        AutoDisposeFutureProvider,
        AutoDisposeFutureProviderFamily,
        AutoDisposeFutureProviderRef,
        FutureProviderElement,
        AutoDisposeFutureProviderElement,

        // AsyncValue
        AsyncValue,
        AsyncLoading,
        AsyncData,
        AsyncError,
        AsyncValueX,

        // Notifier
        Notifier,
        AutoDisposeNotifier,
        NotifierProviderElement,
        AutoDisposeNotifierProviderElement,
        // ignore: invalid_use_of_internal_member
        NotifierProviderImpl,
        // ignore: invalid_use_of_internal_member
        AutoDisposeNotifierProviderImpl,
        // ignore: invalid_use_of_internal_member
        BuildlessNotifier,
        // ignore: invalid_use_of_internal_member
        BuildlessAutoDisposeNotifier,
        NotifierProvider,
        NotifierProviderRef,
        AutoDisposeNotifierProvider,
        AutoDisposeNotifierProviderRef,

        // AsyncNotifier
        AsyncNotifier,
        AutoDisposeAsyncNotifier,
        AsyncNotifierProviderElement,
        AutoDisposeAsyncNotifierProviderElement,
        // ignore: invalid_use_of_internal_member
        AsyncNotifierProviderImpl,
        // ignore: invalid_use_of_internal_member
        AutoDisposeAsyncNotifierProviderImpl,
        // ignore: invalid_use_of_internal_member
        BuildlessAsyncNotifier,
        // ignore: invalid_use_of_internal_member
        BuildlessAutoDisposeAsyncNotifier,
        // TODO remove those exports once Notifer API is stable
        AsyncNotifierProvider,
        AsyncNotifierProviderRef,
        AutoDisposeAsyncNotifierProvider,
        AutoDisposeAsyncNotifierProviderRef;

export 'src/riverpod_annotation.dart';
