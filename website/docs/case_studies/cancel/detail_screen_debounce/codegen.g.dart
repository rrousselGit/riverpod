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

String _$activityHash() => r'ef908e3b46693862f082769663b14d5369d6e155';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
