export 'dart:async' show FutureOr;

// Annotations used by code-generators
export 'package:meta/meta.dart' show visibleForOverriding;

// ignore: invalid_export_of_internal_element
export 'package:riverpod/src/internals.dart'
    show
        // General stuff
        // TODO changelog exported ProviderContainer,
        ProviderContainer,
        Family,
        ProviderOrFamily,
        Override,
        // ignore: invalid_use_of_internal_member, Used by notifiers for overriding overrideWith
        ProviderOverride,
        // ignore: invalid_use_of_internal_member, used by families for overrideWith
        FamilyOverride,
        Ref,

        // Provider
        Provider,
        ProviderFamily,
        ProviderElement,

        // FutureProvider
        FutureProvider,
        FutureProviderFamily,
        FutureProviderRef,
        FutureProviderElement,

        // StreamProvider
        StreamProvider,
        StreamProviderFamily,
        StreamProviderElement,

        // AsyncValue
        AsyncValue,
        AsyncLoading,
        AsyncData,
        AsyncError,
        AsyncValueX,

        // Notifier
        Notifier,
        // ignore: invalid_use_of_internal_member
        NotifierProvider,

        // AsyncNotifier
        AsyncNotifier,
        AsyncNotifierProvider,
        // StreamNotifier
        StreamNotifier,
        StreamNotifierProvider;

export 'src/riverpod_annotation.dart';
