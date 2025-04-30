// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(activity)
const activityProvider = ActivityProvider._();

final class ActivityProvider
    extends $FunctionalProvider<AsyncValue<Activity>, FutureOr<Activity>>
    with $FutureModifier<Activity>, $FutureProvider<Activity> {
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

String _$activityHash() => r'609ac1c1d8008d8109ea5869c7aa88013032917c';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
