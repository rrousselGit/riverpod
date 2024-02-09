// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scopes.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef ScopedRef = Ref<int>;

const scopedProvider = ScopedProvider._();

final class ScopedProvider extends $FunctionalProvider<int, int, ScopedRef>
    with $Provider<int, ScopedRef> {
  const ScopedProvider._(
      {int Function(
        ScopedRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'scopedProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    ScopedRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$scopedHash();

  @override
  $ProviderElement<int> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  ScopedProvider $copyWithCreate(
    int Function(
      ScopedRef ref,
    ) create,
  ) {
    return ScopedProvider._(create: create);
  }

  @override
  int create(ScopedRef ref) {
    final fn = _createCb ?? scoped;
    return fn(ref);
  }
}

String _$scopedHash() => r'590f1a203323105e732397a2616fbd7dac65f0cc';

const scopedClassProvider = ScopedClassProvider._();

final class ScopedClassProvider extends $NotifierProvider<ScopedClass, int> {
  const ScopedClassProvider._(
      {super.runNotifierBuildOverride, ScopedClass Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'scopedClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final ScopedClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$scopedClassHash();

  @$internal
  @override
  ScopedClass create() => _createCb?.call() ?? ScopedClass();

  @$internal
  @override
  ScopedClassProvider $copyWithCreate(
    ScopedClass Function() create,
  ) {
    return ScopedClassProvider._(create: create);
  }

  @$internal
  @override
  ScopedClassProvider $copyWithBuild(
    int Function(
      Ref<int>,
      ScopedClass,
    ) build,
  ) {
    return ScopedClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<ScopedClass, int> createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$scopedClassHash() => r'12c0c3f2bbda7eaeaaf1c30cb6398f056f801647';

abstract class _$ScopedClass extends $Notifier<int> {
  int build();

  @$internal
  @override
  int runBuild() => build();
}

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package
