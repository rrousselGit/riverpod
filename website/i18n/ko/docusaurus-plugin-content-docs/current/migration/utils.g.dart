// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'utils.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef RandomRef = Ref<int>;

@ProviderFor(random)
const randomProvider = RandomProvider._();

final class RandomProvider extends $FunctionalProvider<int, int, RandomRef>
    with $Provider<int, RandomRef> {
  const RandomProvider._(
      {int Function(
        RandomRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'randomProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    RandomRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$randomHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  RandomProvider $copyWithCreate(
    int Function(
      RandomRef ref,
    ) create,
  ) {
    return RandomProvider._(create: create);
  }

  @override
  int create(RandomRef ref) {
    final _$cb = _createCb ?? random;
    return _$cb(ref);
  }
}

String _$randomHash() => r'789ed69452c1cde06c8a48f69eae2c242e7764ab';

typedef TaskTrackerRef = Ref<TaskTrackerRepo>;

@ProviderFor(taskTracker)
const taskTrackerProvider = TaskTrackerProvider._();

final class TaskTrackerProvider extends $FunctionalProvider<
    TaskTrackerRepo,
    TaskTrackerRepo,
    TaskTrackerRef> with $Provider<TaskTrackerRepo, TaskTrackerRef> {
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
  $ProviderElement<TaskTrackerRepo> $createElement(
          ProviderContainer container) =>
      $ProviderElement(this, container);

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

typedef DurationRef = Ref<Duration>;

@ProviderFor(duration)
const durationProvider = DurationProvider._();

final class DurationProvider
    extends $FunctionalProvider<Duration, Duration, DurationRef>
    with $Provider<Duration, DurationRef> {
  const DurationProvider._(
      {Duration Function(
        DurationRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'durationProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Duration Function(
    DurationRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$durationHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Duration value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Duration>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<Duration> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  DurationProvider $copyWithCreate(
    Duration Function(
      DurationRef ref,
    ) create,
  ) {
    return DurationProvider._(create: create);
  }

  @override
  Duration create(DurationRef ref) {
    final _$cb = _createCb ?? duration;
    return _$cb(ref);
  }
}

String _$durationHash() => r'00e8192d47835ec451b18bc2cfc1e8610aa5f5c2';

typedef AvailableWaterRef = Ref<int>;

@ProviderFor(availableWater)
const availableWaterProvider = AvailableWaterProvider._();

final class AvailableWaterProvider
    extends $FunctionalProvider<int, int, AvailableWaterRef>
    with $Provider<int, AvailableWaterRef> {
  const AvailableWaterProvider._(
      {int Function(
        AvailableWaterRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'availableWaterProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    AvailableWaterRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$availableWaterHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  AvailableWaterProvider $copyWithCreate(
    int Function(
      AvailableWaterRef ref,
    ) create,
  ) {
    return AvailableWaterProvider._(create: create);
  }

  @override
  int create(AvailableWaterRef ref) {
    final _$cb = _createCb ?? availableWater;
    return _$cb(ref);
  }
}

String _$availableWaterHash() => r'7d4e8fb0dd7ff52a78eb569b39c4e472c364aac7';

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
