// Annotations used by code-generators
// ignore_for_file: invalid_use_of_internal_member

import 'package:meta/meta.dart' as meta;

export 'dart:async' show FutureOr;

// ignore: invalid_export_of_internal_element
export './src/internal.dart'
    show
        $Ref,
        $ClassProviderElement,
        // General stuff
        ProviderContainer,
        $Family,
        ProviderOrFamily,
        Override,
        $FamilyOverride,
        $FunctionalProvider,
        $FutureModifier,
        Ref,
        AnyNotifier,
        $AsyncClassModifier,
        $ClassProvider,
        $SyncValueProvider,
        $ProviderOverride,
        $RefArg,
        $ProviderPointer,

        // Mutation/Listenables
        ProviderListenable,
        $LazyProxyListenable,
        ProviderElement,
        $ElementLense,
        $Result,

        // Provider
        $Provider,
        $ProviderElement,

        // FutureProvider
        $FutureProvider,
        $FutureProviderElement,

        // StreamProvider
        $StreamProvider,
        $StreamProviderElement,

        // AsyncValue
        AsyncValue,
        AsyncLoading,
        AsyncData,
        AsyncError,

        // AsyncNotifier
        $AsyncNotifierProvider,
        $AsyncNotifier,
        $AsyncNotifierProviderElement,

        // StreamNotifier
        $StreamNotifierProvider,
        $StreamNotifierProviderElement,
        $StreamNotifier,

        // Notifier
        $NotifierProvider,
        $NotifierProviderElement,
        $Notifier,

        // Misc
        riverpod,
        Riverpod,
        ProviderFor,
        Raw,
        MissingScopeException,
        $FunctionalFamilyOverride,
        $ClassFamilyOverride;

/// An implementation detail of `riverpod_generator`.
/// Do not use.
const $internal = meta.internal;

/// An implementation detail of `riverpod_generator`.
/// Do not use.
const $mustCallSuper = meta.mustCallSuper;
