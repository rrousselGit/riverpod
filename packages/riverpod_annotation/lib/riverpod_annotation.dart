// Annotations used by code-generators
// ignore_for_file: invalid_use_of_internal_member

import 'package:meta/meta.dart' as meta;

export 'dart:async' show FutureOr;

// ignore: invalid_export_of_internal_element
export 'package:riverpod/src/internals.dart'
    show
        $Ref,
        $ClassProviderElement,
        // General stuff
        ProviderContainer,
        Family,
        ProviderOrFamily,
        Override,
        $FamilyOverride,
        $FunctionalProvider,
        $FutureModifier,
        Ref,
        NotifierBase,
        $AsyncClassModifier,
        $ClassProvider,
        $ValueProvider,
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
        $Notifier;

// Separate export to avoid silencing valid @internal issues
// ignore: invalid_export_of_internal_element
export 'package:riverpod/src/mutation.dart'
    show
        mutationZoneKey,
        mutation,
        Mutation,
        MutationState,
        IdleMutationState,
        PendingMutationState,
        ErrorMutationState,
        SuccessMutationState,
        MutationBase,
        $SyncMutationBase,
        $AsyncMutationBase;

export 'src/riverpod_annotation.dart'
    show
        riverpod,
        Riverpod,
        ProviderFor,
        Raw,
        MissingScopeException,
        Dependencies;

/// An implementation detail of `riverpod_generator`.
/// Do not use.
const $internal = meta.internal;
