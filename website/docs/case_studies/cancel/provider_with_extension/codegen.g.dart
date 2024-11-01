// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef ActivityRef = Ref<AsyncValue<Activity>>;

@ProviderFor(activity)
const activityProvider = ActivityProvider._();

final class ActivityProvider
    extends $FunctionalProvider<AsyncValue<Activity>, FutureOr<Activity>>
    with $FutureModifier<Activity>, $FutureProvider<Activity, ActivityRef> {
  const ActivityProvider._(
      {FutureOr<Activity> Function(
        ActivityRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'activityProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<Activity> Function(
    ActivityRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$activityHash();

  @$internal
  @override
  $FutureProviderElement<Activity> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(this, pointer);

  @override
  ActivityProvider $copyWithCreate(
    FutureOr<Activity> Function(
      ActivityRef ref,
    ) create,
  ) {
    return ActivityProvider._(create: create);
  }

  @override
  FutureOr<Activity> create(ActivityRef ref) {
    final _$cb = _createCb ?? activity;
    return _$cb(ref);
  }
}

String _$activityHash() => r'c1d2d6dca725a8b75b31c73630a5641dba0bec2b';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
