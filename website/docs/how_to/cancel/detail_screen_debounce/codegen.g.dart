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

final class ActivityProvider
    extends
        $FunctionalProvider<AsyncValue<Activity>, Activity, FutureOr<Activity>>
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

String _$activityHash() => r'dd7d10807315da17e775b99e8e03f5d9634fc822';
