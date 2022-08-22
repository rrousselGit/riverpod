export 'dart:async' show FutureOr;

// ignore: invalid_export_of_internal_element
export 'package:riverpod/src/internals.dart'
    show
        // ignore: invalid_use_of_internal_member
        NotifierProviderImpl,
        // ignore: invalid_use_of_internal_member
        AsyncNotifierProviderImpl,
        // ignore: invalid_use_of_internal_member
        AutoDisposeNotifierProviderImpl,
        // ignore: invalid_use_of_internal_member
        AutoDisposeAsyncNotifierProviderImpl,
        // ignore: invalid_use_of_internal_member
        BuildlessAsyncNotifier,
        // ignore: invalid_use_of_internal_member
        BuildlessNotifier,
        // ignore: invalid_use_of_internal_member
        BuildlessAutoDisposeAsyncNotifier,
        // ignore: invalid_use_of_internal_member
        BuildlessAutoDisposeNotifier,
        // TODO remove those exports once Notifer API is stable
        NotifierProvider,
        NotifierProviderRef,
        AutoDisposeNotifierProvider,
        AutoDisposeNotifierProviderRef,
        AsyncNotifierProvider,
        AsyncNotifierProviderRef,
        AutoDisposeAsyncNotifierProvider,
        AutoDisposeAsyncNotifierProviderRef,
        Notifier,
        AutoDisposeNotifier,
        AsyncNotifier,
        AutoDisposeAsyncNotifier;

export 'src/riverpod_annotation.dart';
