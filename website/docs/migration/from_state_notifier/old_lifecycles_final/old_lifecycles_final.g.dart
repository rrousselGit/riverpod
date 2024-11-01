// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'old_lifecycles_final.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef DurationRef = Ref<Duration>;

@ProviderFor(duration)
const durationProvider = DurationProvider._();

final class DurationProvider extends $FunctionalProvider<Duration, Duration>
    with $Provider<Duration, DurationRef> {
  const DurationProvider._(
      {Duration Function(
        DurationRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
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
  $ProviderElement<Duration> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

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

String _$durationHash() => r'be282a34a01007c6f3e04447579609199306aecc';

typedef RepositoryRef = Ref<_MyRepo>;

@ProviderFor(repository)
const repositoryProvider = RepositoryProvider._();

final class RepositoryProvider extends $FunctionalProvider<_MyRepo, _MyRepo>
    with $Provider<_MyRepo, RepositoryRef> {
  const RepositoryProvider._(
      {_MyRepo Function(
        RepositoryRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'repositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final _MyRepo Function(
    RepositoryRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$repositoryHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(_MyRepo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<_MyRepo>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<_MyRepo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  RepositoryProvider $copyWithCreate(
    _MyRepo Function(
      RepositoryRef ref,
    ) create,
  ) {
    return RepositoryProvider._(create: create);
  }

  @override
  _MyRepo create(RepositoryRef ref) {
    final _$cb = _createCb ?? repository;
    return _$cb(ref);
  }
}

String _$repositoryHash() => r'80732dff4b7c3731f85f4c5ae72c820ae349c7fe';

@ProviderFor(MyNotifier)
const myNotifierProvider = MyNotifierProvider._();

final class MyNotifierProvider extends $NotifierProvider<MyNotifier, int> {
  const MyNotifierProvider._(
      {super.runNotifierBuildOverride, MyNotifier Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'myNotifierProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final MyNotifier Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$myNotifierHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  MyNotifier create() => _createCb?.call() ?? MyNotifier();

  @$internal
  @override
  MyNotifierProvider $copyWithCreate(
    MyNotifier Function() create,
  ) {
    return MyNotifierProvider._(create: create);
  }

  @$internal
  @override
  MyNotifierProvider $copyWithBuild(
    int Function(
      Ref<int>,
      MyNotifier,
    ) build,
  ) {
    return MyNotifierProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<MyNotifier, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$myNotifierHash() => r'8ea2586ea29d12306efd4b8b847142136dd20338';

abstract class _$MyNotifier extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
