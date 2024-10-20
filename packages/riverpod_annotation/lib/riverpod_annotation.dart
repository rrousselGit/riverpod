export 'dart:async' show FutureOr;

// Annotations used by code-generators
export 'package:meta/meta.dart' show visibleForOverriding;

// ignore: invalid_export_of_internal_element
export 'package:riverpod/src/internals.dart'
    show
        // General stuff
        Family,
        ProviderOrFamily,
        Override,
        // ignore: invalid_use_of_internal_member, Used by notifiers for overriding overrideWith
        ProviderOverride,
        // ignore: invalid_use_of_internal_member, used by families for overrideWith
        FamilyOverride,

        // Provider
        Provider,
        ProviderFamily,
        // ignore: deprecated_member_use
        ProviderRef,
        AutoDisposeProvider,
        AutoDisposeProviderFamily,
        // ignore: deprecated_member_use
        AutoDisposeProviderRef,
        ProviderElement,
        AutoDisposeProviderElement,

        // FutureProvider
        FutureProvider,
        FutureProviderFamily,
        // ignore: deprecated_member_use
        FutureProviderRef,
        AutoDisposeFutureProvider,
        AutoDisposeFutureProviderFamily,
        // ignore: deprecated_member_use
        AutoDisposeFutureProviderRef,
        FutureProviderElement,
        AutoDisposeFutureProviderElement,

        // StreamProvider
        StreamProvider,
        StreamProviderFamily,
        // ignore: deprecated_member_use
        StreamProviderRef,
        AutoDisposeStreamProvider,
        AutoDisposeStreamProviderFamily,
        // ignore: deprecated_member_use
        AutoDisposeStreamProviderRef,
        StreamProviderElement,
        AutoDisposeStreamProviderElement,

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
        // ignore: deprecated_member_use
        NotifierProviderRef,
        AutoDisposeNotifierProvider,
        // ignore: deprecated_member_use
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
        AsyncNotifierProvider,
        // ignore: deprecated_member_use
        AsyncNotifierProviderRef,
        AutoDisposeAsyncNotifierProvider,
        // ignore: deprecated_member_use
        AutoDisposeAsyncNotifierProviderRef,

        // StreamNotifier
        StreamNotifier,
        AutoDisposeStreamNotifier,
        StreamNotifierProviderElement,
        AutoDisposeStreamNotifierProviderElement,
        // ignore: invalid_use_of_internal_member
        StreamNotifierProviderImpl,
        // ignore: invalid_use_of_internal_member
        AutoDisposeStreamNotifierProviderImpl,
        // ignore: invalid_use_of_internal_member
        BuildlessStreamNotifier,
        // ignore: invalid_use_of_internal_member
        BuildlessAutoDisposeStreamNotifier,
        StreamNotifierProvider,
        // ignore: deprecated_member_use
        StreamNotifierProviderRef,
        AutoDisposeStreamNotifierProvider,
        // ignore: deprecated_member_use
        AutoDisposeStreamNotifierProviderRef;

export 'src/riverpod_annotation.dart';
