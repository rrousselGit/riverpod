// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
