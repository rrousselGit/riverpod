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

String _$activityHash() => r'7b532e70a92d6bc198900ca61f0e714c5484c34d';

@ProviderFor(ActivityNotifier2)
const activityNotifier2Provider = ActivityNotifier2Provider._();

final class ActivityNotifier2Provider
    extends $AsyncNotifierProvider<ActivityNotifier2, Activity> {
  const ActivityNotifier2Provider._(
      {super.runNotifierBuildOverride, ActivityNotifier2 Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'activityNotifier2Provider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final ActivityNotifier2 Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$activityNotifier2Hash();

  @$internal
  @override
  ActivityNotifier2 create() => _createCb?.call() ?? ActivityNotifier2();

  @$internal
  @override
  ActivityNotifier2Provider $copyWithCreate(
    ActivityNotifier2 Function() create,
  ) {
    return ActivityNotifier2Provider._(create: create);
  }

  @$internal
  @override
  ActivityNotifier2Provider $copyWithBuild(
    FutureOr<Activity> Function(
      Ref<AsyncValue<Activity>>,
      ActivityNotifier2,
    ) build,
  ) {
    return ActivityNotifier2Provider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $AsyncNotifierProviderElement<ActivityNotifier2, Activity> $createElement(
          $ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(this, pointer);
}

String _$activityNotifier2Hash() => r'280f4d82a186cfb62827f4d7c74f5349bb0a9e4a';

abstract class _$ActivityNotifier2 extends $AsyncNotifier<Activity> {
  FutureOr<Activity> build();
  @$internal
  @override
  FutureOr<Activity> runBuild() => build();
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
