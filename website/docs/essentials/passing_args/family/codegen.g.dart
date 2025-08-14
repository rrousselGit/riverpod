// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(activity)
const activityProvider = ActivityFamily._();

final class ActivityProvider extends $FunctionalProvider<AsyncValue<Activity>,
        Activity, FutureOr<Activity>>
    with $FutureModifier<Activity>, $FutureProvider<Activity> {
  const ActivityProvider._(
      {required ActivityFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'activityProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$activityHash();

  @override
  String toString() {
    return r'activityProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Activity> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Activity> create(Ref ref) {
    final argument = this.argument as String;
    return activity(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ActivityProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activityHash() => r'6c815736c0d2b40a92695adcd78516534d7ac2fc';

final class ActivityFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Activity>, String> {
  const ActivityFamily._()
      : super(
          retry: null,
          name: r'activityProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ActivityProvider call(
    String activityType,
  ) =>
      ActivityProvider._(argument: activityType, from: this);

  @override
  String toString() => r'activityProvider';
}

@ProviderFor(ActivityNotifier2)
const activityNotifier2Provider = ActivityNotifier2Family._();

final class ActivityNotifier2Provider
    extends $AsyncNotifierProvider<ActivityNotifier2, Activity> {
  const ActivityNotifier2Provider._(
      {required ActivityNotifier2Family super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'activityNotifier2Provider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$activityNotifier2Hash();

  @override
  String toString() {
    return r'activityNotifier2Provider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ActivityNotifier2 create() => ActivityNotifier2();

  @override
  bool operator ==(Object other) {
    return other is ActivityNotifier2Provider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activityNotifier2Hash() => r'9e67c655d53a9f98c3b012a0534421385dde0339';

final class ActivityNotifier2Family extends $Family
    with
        $ClassFamilyOverride<ActivityNotifier2, AsyncValue<Activity>, Activity,
            FutureOr<Activity>, String> {
  const ActivityNotifier2Family._()
      : super(
          retry: null,
          name: r'activityNotifier2Provider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ActivityNotifier2Provider call(
    String activityType,
  ) =>
      ActivityNotifier2Provider._(argument: activityType, from: this);

  @override
  String toString() => r'activityNotifier2Provider';
}

abstract class _$ActivityNotifier2 extends $AsyncNotifier<Activity> {
  late final _$args = ref.$arg as String;
  String get activityType => _$args;

  FutureOr<Activity> build(
    String activityType,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<Activity>, Activity>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<Activity>, Activity>,
        AsyncValue<Activity>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
