// Annotations used by code-generators
// ignore_for_file: invalid_use_of_internal_member

import 'package:meta/meta.dart' as meta;

export 'dart:async' show FutureOr;

// Annotations used by code-generators
export 'package:meta/meta.dart' show visibleForOverriding;

// ignore: invalid_export_of_internal_element
export 'package:riverpod/src/internals.dart'
    show
        $ClassProviderElement,
        // General stuff
        Family,
        ProviderOrFamily,
        Override,
        ProviderOverride,
        FamilyOverride,
        AnyNotifier,

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
        NotifierProviderImpl,
        AutoDisposeNotifierProviderImpl,
        BuildlessNotifier,
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
        AsyncNotifierProviderImpl,
        AutoDisposeAsyncNotifierProviderImpl,
        BuildlessAsyncNotifier,
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
        StreamNotifierProviderImpl,
        AutoDisposeStreamNotifierProviderImpl,
        BuildlessStreamNotifier,
        BuildlessAutoDisposeStreamNotifier,
        StreamNotifierProvider,
        // ignore: deprecated_member_use
        StreamNotifierProviderRef,
        AutoDisposeStreamNotifierProvider,
        // ignore: deprecated_member_use
        AutoDisposeStreamNotifierProviderRef;

export 'src/riverpod_annotation.dart';

/// An implementation detail of `riverpod_generator`.
/// Do not use.
const $internal = meta.internal;
