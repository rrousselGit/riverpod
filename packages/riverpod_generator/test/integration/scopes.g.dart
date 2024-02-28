// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scopes.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(ScopedClass)
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
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  final ScopedClass Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$scopedClassHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

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
  $NotifierProviderElement<ScopedClass, int> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);
}

String _$scopedClassHash() => r'113acc46a2e61abfeb61cf4b89a1dc555e915793';

abstract class _$ScopedClass extends $Notifier<int> {
  int build() => throw MissingScopeException(ref);
  @$internal
  @override
  int runBuild() => build();
}

@ProviderFor(ScopedClassFamily)
const scopedClassFamilyProvider = ScopedClassFamilyFamily._();

final class ScopedClassFamilyProvider
    extends $NotifierProvider<ScopedClassFamily, int> {
  const ScopedClassFamilyProvider._(
      {required ScopedClassFamilyFamily super.from,
      required int super.argument,
      super.runNotifierBuildOverride,
      ScopedClassFamily Function()? create})
      : _createCb = create,
        super(
          name: r'scopedClassFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final ScopedClassFamily Function()? _createCb;

  @override
  String debugGetCreateSourceHash() => _$scopedClassFamilyHash();

  @override
  String toString() {
    return r'scopedClassFamilyProvider'
        ''
        '($argument)';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  ScopedClassFamily create() => _createCb?.call() ?? ScopedClassFamily();

  @$internal
  @override
  ScopedClassFamilyProvider $copyWithCreate(
    ScopedClassFamily Function() create,
  ) {
    return ScopedClassFamilyProvider._(
        argument: argument as int,
        from: from! as ScopedClassFamilyFamily,
        create: create);
  }

  @$internal
  @override
  ScopedClassFamilyProvider $copyWithBuild(
    int Function(
      Ref<int>,
      ScopedClassFamily,
    ) build,
  ) {
    return ScopedClassFamilyProvider._(
        argument: argument as int,
        from: from! as ScopedClassFamilyFamily,
        runNotifierBuildOverride: build);
  }

  @$internal
  @override
  $NotifierProviderElement<ScopedClassFamily, int> $createElement(
          ProviderContainer container) =>
      $NotifierProviderElement(this, container);

  @override
  bool operator ==(Object other) {
    return other is ScopedClassFamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$scopedClassFamilyHash() => r'04aeb0bbfdc363e2c8714c7a5967368a7f990d58';

final class ScopedClassFamilyFamily extends Family {
  const ScopedClassFamilyFamily._()
      : super(
          name: r'scopedClassFamilyProvider',
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
          isAutoDispose: true,
        );

  ScopedClassFamilyProvider call(
    int a,
  ) =>
      ScopedClassFamilyProvider._(argument: a, from: this);

  @override
  String debugGetCreateSourceHash() => _$scopedClassFamilyHash();

  @override
  String toString() => r'scopedClassFamilyProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    ScopedClassFamily Function(
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as ScopedClassFamilyProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate(() => create(argument))
            .$createElement(container);
      },
    );
  }

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    int Function(Ref<int> ref, ScopedClassFamily notifier, int argument) build,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as ScopedClassFamilyProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithBuild((ref, notifier) => build(ref, notifier, argument))
            .$createElement(container);
      },
    );
  }
}

abstract class _$ScopedClassFamily extends $Notifier<int> {
  late final _$args = (ref as $NotifierProviderElement).origin.argument as int;
  int get a => _$args;

  int build(
    int a,
  ) =>
      throw MissingScopeException(ref);
  @$internal
  @override
  int runBuild() => build(
        _$args,
      );
}

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
