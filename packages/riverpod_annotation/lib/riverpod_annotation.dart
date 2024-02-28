// Annotations used by code-generators
// ignore_for_file: invalid_use_of_internal_member

import 'package:meta/meta.dart' as meta;

export 'dart:async' show FutureOr;

// ignore: invalid_export_of_internal_element
export 'package:riverpod/src/internals.dart'
    show
        // General stuff
        // TODO changelog changed exports,
        ProviderContainer,
        Family,
        ProviderOrFamily,
        Override,
        $FamilyOverride,
        $FunctionalProvider,
        $FutureModifier,
        NotifierBase,
        $AsyncClassModifier,
        $ClassProvider,
        Ref,
        $ValueProvider,
        $ProviderOverride,

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

export 'src/riverpod_annotation.dart';

/// An implementation detail of `riverpod_generator`.
/// Do not use.
const $internal = meta.internal;
