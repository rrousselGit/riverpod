// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'family_and_dispose.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef TaskTrackerRef = Ref<TaskTrackerRepo>;

@ProviderFor(taskTracker)
const taskTrackerProvider = TaskTrackerProvider._();

final class TaskTrackerProvider
    extends $FunctionalProvider<TaskTrackerRepo, TaskTrackerRepo>
    with $Provider<TaskTrackerRepo, TaskTrackerRef> {
  const TaskTrackerProvider._(
      {TaskTrackerRepo Function(
        TaskTrackerRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'taskTrackerProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final TaskTrackerRepo Function(
    TaskTrackerRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$taskTrackerHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskTrackerRepo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<TaskTrackerRepo>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<TaskTrackerRepo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  TaskTrackerProvider $copyWithCreate(
    TaskTrackerRepo Function(
      TaskTrackerRef ref,
    ) create,
  ) {
    return TaskTrackerProvider._(create: create);
  }

  @override
  TaskTrackerRepo create(TaskTrackerRef ref) {
    final _$cb = _createCb ?? taskTracker;
    return _$cb(ref);
  }
}

String _$taskTrackerHash() => r'd78149146c3a07b78e7dc1d03fa60ed1941c3702';

@ProviderFor(BugsEncounteredNotifier)
const bugsEncounteredNotifierProvider = BugsEncounteredNotifierFamily._();

final class BugsEncounteredNotifierProvider
    extends $AsyncNotifierProvider<BugsEncounteredNotifier, int> {
  const BugsEncounteredNotifierProvider._(
      {required BugsEncounteredNotifierFamily super.from,
      required String super.argument,
      super.runNotifierBuildOverride,
      BugsEncounteredNotifier Function()? create})
      : _createCb = create,
        super(
          name: r'bugsEncounteredNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final BugsEncounteredNotifier Function()? _createCb;

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
  BugsEncounteredNotifier create() =>
      _createCb?.call() ?? BugsEncounteredNotifier();

  @$internal
  @override
  BugsEncounteredNotifierProvider $copyWithCreate(
    BugsEncounteredNotifier Function() create,
  ) {
    return BugsEncounteredNotifierProvider._(
        argument: argument as String,
        from: from! as BugsEncounteredNotifierFamily,
        create: create);
  }

  @$internal
  @override
  BugsEncounteredNotifierProvider $copyWithBuild(
    FutureOr<int> Function(
      Ref<AsyncValue<int>>,
      BugsEncounteredNotifier,
    ) build,
  ) {
    return BugsEncounteredNotifierProvider._(
        argument: argument as String,
        from: from! as BugsEncounteredNotifierFamily,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $AsyncNotifierProviderElement<BugsEncounteredNotifier, int> $createElement(
          $ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(this, pointer);

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

final class BugsEncounteredNotifierFamily extends Family {
  const BugsEncounteredNotifierFamily._()
      : super(
          name: r'bugsEncounteredNotifierProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  BugsEncounteredNotifierProvider call(
    String featureId,
  ) =>
      BugsEncounteredNotifierProvider._(argument: featureId, from: this);

  @override
  String debugGetCreateSourceHash() => _$bugsEncounteredNotifierHash();

  @override
  String toString() => r'bugsEncounteredNotifierProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    BugsEncounteredNotifier Function(
      String args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as BugsEncounteredNotifierProvider;

        final argument = provider.argument as String;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(pointer);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    FutureOr<int> Function(Ref<AsyncValue<int>> ref,
            BugsEncounteredNotifier notifier, String argument)
        build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as BugsEncounteredNotifierProvider;

        final argument = provider.argument as String;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(pointer);
      },
    );
  }
}

abstract class _$BugsEncounteredNotifier extends $AsyncNotifier<int> {
  late final _$args = ref.$arg as String;
  String get featureId => _$args;

  FutureOr<int> build(
    String featureId,
  );
  @$internal
  @override
  FutureOr<int> runBuild() => build(
        _$args,
      );
}

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
