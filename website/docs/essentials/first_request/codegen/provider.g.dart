// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// This will create a provider named `activityProvider`
/// which will cache the result of this function.
// {@endtemplate}

@ProviderFor(activity)
const activityProvider = ActivityProvider._();

/// This will create a provider named `activityProvider`
/// which will cache the result of this function.
// {@endtemplate}

final class ActivityProvider extends $FunctionalProvider<AsyncValue<Activity>,
        Activity, FutureOr<Activity>>
    with $FutureModifier<Activity>, $FutureProvider<Activity> {
  /// This will create a provider named `activityProvider`
  /// which will cache the result of this function.
// {@endtemplate}
  const ActivityProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'activityProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$activityHash();

  @$internal
  @override
  $FutureProviderElement<Activity> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Activity> create(Ref ref) {
    return activity(ref);
  }
}

String _$activityHash() => r'c90b5d6502e5e4c31a2fa8c974683171cad8f38f';
