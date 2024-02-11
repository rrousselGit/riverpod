// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef RepositoryRef = Ref<Repository>;

@ProviderFor(repository)
const repositoryProvider = RepositoryProvider._();

final class RepositoryProvider
    extends $FunctionalProvider<Repository, Repository, RepositoryRef>
    with $Provider<Repository, RepositoryRef> {
  const RepositoryProvider._(
      {Repository Function(
        RepositoryRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'repositoryProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final Repository Function(
    RepositoryRef ref,
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
  $ProviderElement<Repository> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  RepositoryProvider $copyWithCreate(
    Repository Function(
      RepositoryRef ref,
    ) create,
  ) {
    return RepositoryProvider._(create: create);
  }

  @override
  Repository create(RepositoryRef ref) {
    final _$cb = _createCb ?? repository;
    return _$cb(ref);
  }
}

String _$repositoryHash() => r'c6dc3b5b727028966b5b850b27ffc7294b485273';

@ProviderFor(Counter)
const counterProvider = CounterProvider._();

final class CounterProvider extends $NotifierProvider<Counter, int> {
  const CounterProvider._(
      {super.runNotifierBuildOverride, Counter Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
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
      Ref<int>,
      Counter,
    ) build,
  ) {
    return CounterProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<Counter, int> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$counterHash() => r'6bd7806869af024b3288645da03c077af9478083';

abstract class _$Counter extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
