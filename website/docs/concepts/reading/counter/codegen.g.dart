// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(repository)
const repositoryProvider = RepositoryProvider._();

final class RepositoryProvider
    extends $FunctionalProvider<Repository, Repository>
    with $Provider<Repository> {
  const RepositoryProvider._(
      {Repository Function(
        Ref ref,
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

  final Repository Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$repositoryHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Repository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<Repository>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<Repository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  RepositoryProvider $copyWithCreate(
    Repository Function(
      Ref ref,
    ) create,
  ) {
    return RepositoryProvider._(create: create);
  }

  @override
  Repository create(Ref ref) {
    final _$cb = _createCb ?? repository;
    return _$cb(ref);
  }
}

String _$repositoryHash() => r'6f859a9d70c3112139aaf826ee2bd541a4c001cb';

@ProviderFor(Counter)
const counterProvider = CounterProvider._();

final class CounterProvider extends $NotifierProvider<Counter, int> {
  const CounterProvider._(
      {super.runNotifierBuildOverride, Counter Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'counterProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Counter Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$counterHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  Counter create() => _createCb?.call() ?? Counter();

  @$internal
  @override
  CounterProvider $copyWithCreate(
    Counter Function() create,
  ) {
    return CounterProvider._(create: create);
  }

  @$internal
  @override
  CounterProvider $copyWithBuild(
    int Function(
      Ref,
      Counter,
    ) build,
  ) {
    return CounterProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<Counter, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$counterHash() => r'6bd7806869af024b3288645da03c077af9478083';

abstract class _$Counter extends $Notifier<int> {
  int build();
  @$internal
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int>;
    final element = ref.element
        as $ClassProviderElement<NotifierBase<int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
