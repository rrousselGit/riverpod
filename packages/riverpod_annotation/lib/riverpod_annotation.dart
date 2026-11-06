// Annotations used by code-generators
// ignore_for_file: invalid_use_of_internal_member

import 'package:meta/meta.dart' as meta;

export 'dart:async' show FutureOr;

export './src/internal.dart'
    show
        // ignore: invalid_export_of_internal_element
        $Ref,
        // ignore: invalid_export_of_internal_element
        $ClassProviderElement,
        // General stuff
        ProviderContainer,
        // ignore: invalid_export_of_internal_element
        $Family,
        ProviderOrFamily,
        Override,
        // ignore: invalid_export_of_internal_element
        $FamilyOverride,
        // ignore: invalid_export_of_internal_element
        $FunctionalProvider,
        // ignore: invalid_export_of_internal_element
        $FutureModifier,
        Ref,
        AnyNotifier,
        // ignore: invalid_export_of_internal_element
        $AsyncClassModifier,
        // ignore: invalid_export_of_internal_element
        $ClassProvider,
        // ignore: invalid_export_of_internal_element
        $SyncValueProvider,
        $ProviderOverride,
        // ignore: invalid_export_of_internal_element
        $RefArg,
        // ignore: invalid_export_of_internal_element
        $ProviderPointer,
        // Mutation/Listenables
        ProviderListenable,
        // ignore: invalid_export_of_internal_element
        $LazyProxyListenable,
        // ignore: invalid_export_of_internal_element
        ProviderElement,
        // ignore: invalid_export_of_internal_element
        $Observable,
        // ignore: invalid_export_of_internal_element
        $Result,
        // Provider
        // ignore: invalid_export_of_internal_element
        $Provider,
        // ignore: invalid_export_of_internal_element
        $ProviderElement,
        // FutureProvider
        // ignore: invalid_export_of_internal_element
        $FutureProvider,
        // ignore: invalid_export_of_internal_element
        $FutureProviderElement,
        // StreamProvider
        // ignore: invalid_export_of_internal_element
        $StreamProvider,
        // ignore: invalid_export_of_internal_element
        $StreamProviderElement,
        // AsyncValue
        AsyncValue,
        AsyncLoading,
        AsyncData,
        AsyncError,
        AsyncResult,
        AsyncValueExtensions,
        // AsyncNotifier
        // ignore: invalid_export_of_internal_element
        $AsyncNotifierProvider,
        // ignore: invalid_export_of_internal_element
        $AsyncNotifier,
        // ignore: invalid_export_of_internal_element
        $AsyncNotifierProviderElement,
        // StreamNotifier
        $StreamNotifierProvider,
        // ignore: invalid_export_of_internal_element
        $StreamNotifierProviderElement,
        // ignore: invalid_export_of_internal_element
        $StreamNotifier,
        // Notifier
        // ignore: invalid_export_of_internal_element
        $NotifierProvider,
        // ignore: invalid_export_of_internal_element
        $NotifierProviderElement,
        // ignore: invalid_export_of_internal_element
        $Notifier,
        // Misc
        riverpod,
        Riverpod,
        ProviderFor,
        Raw,
        MissingScopeException,
        // ignore: invalid_export_of_internal_element
        $FunctionalFamilyOverride,
        // ignore: invalid_export_of_internal_element
        $ClassFamilyOverride,
        WhenComplete;

/// An implementation detail of `riverpod_generator`.
/// Do not use.
const $internal = meta.internal;

/// An implementation detail of `riverpod_generator`.
/// Do not use.
const $mustCallSuper = meta.mustCallSuper;
