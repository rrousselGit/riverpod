// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(activity)
const activityProvider = ActivityProvider._();

final class ActivityProvider extends $FunctionalProvider<AsyncValue<Activity>,
        Activity, FutureOr<Activity>>
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

String _$activityHash() => r'7b532e70a92d6bc198900ca61f0e714c5484c34d';

@ProviderFor(ActivityNotifier2)
const activityNotifier2Provider = ActivityNotifier2Provider._();

final class ActivityNotifier2Provider
    extends $AsyncNotifierProvider<ActivityNotifier2, Activity> {
  const ActivityNotifier2Provider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'activityNotifier2Provider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$activityNotifier2Hash();

  @$internal
  @override
  ActivityNotifier2 create() => ActivityNotifier2();
}

String _$activityNotifier2Hash() => r'280f4d82a186cfb62827f4d7c74f5349bb0a9e4a';

abstract class _$ActivityNotifier2 extends $AsyncNotifier<Activity> {
  FutureOr<Activity> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<Activity>, Activity>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<Activity>, Activity>,
        AsyncValue<Activity>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
