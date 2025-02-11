// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'family_and_dispose.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(taskTracker)
const taskTrackerProvider = TaskTrackerProvider._();

final class TaskTrackerProvider
    extends $FunctionalProvider<TaskTrackerRepo, TaskTrackerRepo>
    with $Provider<TaskTrackerRepo> {
  const TaskTrackerProvider._(
      {TaskTrackerRepo Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'taskTrackerProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final TaskTrackerRepo Function(
    Ref ref,
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
      Ref ref,
    ) create,
  ) {
    return TaskTrackerProvider._(create: create);
  }

  @override
  TaskTrackerRepo create(Ref ref) {
    final _$cb = _createCb ?? taskTracker;
    return _$cb(ref);
  }
}

String _$taskTrackerHash() => r'004d4554b37d841c6f668e298067dd39611a453a';

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
          retry: null,
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
      Ref,
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
          retry: null,
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
    FutureOr<int> Function(
            Ref ref, BugsEncounteredNotifier notifier, String argument)
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
  void runBuild() {
    final created = build(
      _$args,
    );
    final ref = this.ref as $Ref<AsyncValue<int>>;
    final element = ref.element as $ClassProviderElement<
        NotifierBase<AsyncValue<int>>, AsyncValue<int>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
