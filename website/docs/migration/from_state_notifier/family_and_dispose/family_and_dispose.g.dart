// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'family_and_dispose.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(taskTracker)
const taskTrackerProvider = TaskTrackerProvider._();

final class TaskTrackerProvider extends $FunctionalProvider<TaskTrackerRepo,
    TaskTrackerRepo, TaskTrackerRepo> with $Provider<TaskTrackerRepo> {
  const TaskTrackerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'taskTrackerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$taskTrackerHash();

  @$internal
  @override
  $ProviderElement<TaskTrackerRepo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TaskTrackerRepo create(Ref ref) {
    return taskTracker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskTrackerRepo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskTrackerRepo>(value),
    );
  }
}

String _$taskTrackerHash() => r'004d4554b37d841c6f668e298067dd39611a453a';

@ProviderFor(BugsEncounteredNotifier)
const bugsEncounteredNotifierProvider = BugsEncounteredNotifierFamily._();

final class BugsEncounteredNotifierProvider
    extends $AsyncNotifierProvider<BugsEncounteredNotifier, int> {
  const BugsEncounteredNotifierProvider._(
      {required BugsEncounteredNotifierFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'bugsEncounteredNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$bugsEncounteredNotifierHash();

  @override
  String toString() {
    return r'bugsEncounteredNotifierProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BugsEncounteredNotifier create() => BugsEncounteredNotifier();

  @override
  bool operator ==(Object other) {
    return other is BugsEncounteredNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bugsEncounteredNotifierHash() =>
    r'c76e924f84db91c57d226896b062d9f4e8ab79e5';

final class BugsEncounteredNotifierFamily extends $Family
    with
        $ClassFamilyOverride<BugsEncounteredNotifier, AsyncValue<int>, int,
            FutureOr<int>, String> {
  const BugsEncounteredNotifierFamily._()
      : super(
          retry: null,
          name: r'bugsEncounteredNotifierProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  BugsEncounteredNotifierProvider call(
    String featureId,
  ) =>
      BugsEncounteredNotifierProvider._(argument: featureId, from: this);

  @override
  String toString() => r'bugsEncounteredNotifierProvider';
}

abstract class _$BugsEncounteredNotifier extends $AsyncNotifier<int> {
  late final _$args = ref.$arg as String;
  String get featureId => _$args;

  FutureOr<int> build(
    String featureId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<int>, int>, AsyncValue<int>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
