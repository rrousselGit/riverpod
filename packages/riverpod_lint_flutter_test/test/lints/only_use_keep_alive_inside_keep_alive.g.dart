// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'only_use_keep_alive_inside_keep_alive.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(keepAlive)
const keepAliveProvider = KeepAliveProvider._();

final class KeepAliveProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const KeepAliveProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'keepAliveProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$keepAliveHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  KeepAliveProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return KeepAliveProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? keepAlive;
    return _$cb(ref);
  }
}

String _$keepAliveHash() => r'095b2cb2261b9d79721aa6552b8aaf0d8a7bb7ee';

@ProviderFor(KeepAliveClass)
const keepAliveClassProvider = KeepAliveClassProvider._();

final class KeepAliveClassProvider
    extends $NotifierProvider<KeepAliveClass, int> {
  const KeepAliveClassProvider._(
      {super.runNotifierBuildOverride, KeepAliveClass Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'keepAliveClassProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final KeepAliveClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$keepAliveClassHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  KeepAliveClass create() => _createCb?.call() ?? KeepAliveClass();

  @$internal
  @override
  KeepAliveClassProvider $copyWithCreate(
    KeepAliveClass Function() create,
  ) {
    return KeepAliveClassProvider._(create: create);
  }

  @$internal
  @override
  KeepAliveClassProvider $copyWithBuild(
    int Function(
      Ref,
      KeepAliveClass,
    ) build,
  ) {
    return KeepAliveClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<KeepAliveClass, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$keepAliveClassHash() => r'e2fffa4d14837dfef71f6a2cc230b826b82541ea';

abstract class _$KeepAliveClass extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

@ProviderFor(autoDispose)
const autoDisposeProvider = AutoDisposeProvider._();

final class AutoDisposeProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const AutoDisposeProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'autoDisposeProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$autoDisposeHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  AutoDisposeProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return AutoDisposeProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? autoDispose;
    return _$cb(ref);
  }
}

String _$autoDisposeHash() => r'1ace7b4b2957ecf77b683b868e91a2614fc77d03';

@ProviderFor(AutoDisposeClass)
const autoDisposeClassProvider = AutoDisposeClassProvider._();

final class AutoDisposeClassProvider
    extends $NotifierProvider<AutoDisposeClass, int> {
  const AutoDisposeClassProvider._(
      {super.runNotifierBuildOverride, AutoDisposeClass Function()? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'autoDisposeClassProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final AutoDisposeClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$autoDisposeClassHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  AutoDisposeClass create() => _createCb?.call() ?? AutoDisposeClass();

  @$internal
  @override
  AutoDisposeClassProvider $copyWithCreate(
    AutoDisposeClass Function() create,
  ) {
    return AutoDisposeClassProvider._(create: create);
  }

  @$internal
  @override
  AutoDisposeClassProvider $copyWithBuild(
    int Function(
      Ref,
      AutoDisposeClass,
    ) build,
  ) {
    return AutoDisposeClassProvider._(runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<AutoDisposeClass, int> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(this, pointer);
}

String _$autoDisposeClassHash() => r'5127ab94f7ab4ccf90deb3fca90d7a3c3c4c83f5';

abstract class _$AutoDisposeClass extends $Notifier<int> {
  int build();
  @$internal
  @override
  int runBuild() => build();
}

@ProviderFor(fn)
const fnProvider = FnProvider._();

final class FnProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const FnProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'fnProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$fnHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  FnProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return FnProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? fn;
    return _$cb(ref);
  }
}

String _$fnHash() => r'e96b0302f7492f5aecedd46f6edeeea456839d01';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
