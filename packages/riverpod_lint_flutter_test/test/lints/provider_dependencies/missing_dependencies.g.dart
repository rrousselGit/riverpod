// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'missing_dependencies.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef DepRef = Ref<int>;

@ProviderFor(dep)
const depProvider = DepProvider._();

final class DepProvider extends $FunctionalProvider<int, int>
    with $Provider<int, DepRef> {
  const DepProvider._(
      {int Function(
        DepRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'depProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  final int Function(
    DepRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$depHash();

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
  DepProvider $copyWithCreate(
    int Function(
      DepRef ref,
    ) create,
  ) {
    return DepProvider._(create: create);
  }

  @override
  int create(DepRef ref) {
    final _$cb = _createCb ?? dep;
    return _$cb(ref);
  }
}

String _$depHash() => r'749c4d696d29c72686cabcabd6fa7855f5cbf4db';

typedef TransitiveDepRef = Ref<int>;

@ProviderFor(transitiveDep)
const transitiveDepProvider = TransitiveDepProvider._();

final class TransitiveDepProvider extends $FunctionalProvider<int, int>
    with $Provider<int, TransitiveDepRef> {
  const TransitiveDepProvider._(
      {int Function(
        TransitiveDepRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'transitiveDepProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[depProvider],
          allTransitiveDependencies: const <ProviderOrFamily>[
            TransitiveDepProvider.$allTransitiveDependencies0,
          ],
        );

  static const $allTransitiveDependencies0 = depProvider;

  final int Function(
    TransitiveDepRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$transitiveDepHash();

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
  TransitiveDepProvider $copyWithCreate(
    int Function(
      TransitiveDepRef ref,
    ) create,
  ) {
    return TransitiveDepProvider._(create: create);
  }

  @override
  int create(TransitiveDepRef ref) {
    final _$cb = _createCb ?? transitiveDep;
    return _$cb(ref);
  }
}

String _$transitiveDepHash() => r'3718ab2a36c91fb776740c6aeafc49db08bbffd5';

typedef Dep2Ref = Ref<int>;

@ProviderFor(dep2)
const dep2Provider = Dep2Provider._();

final class Dep2Provider extends $FunctionalProvider<int, int>
    with $Provider<int, Dep2Ref> {
  const Dep2Provider._(
      {int Function(
        Dep2Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'dep2Provider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  final int Function(
    Dep2Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$dep2Hash();

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
  Dep2Provider $copyWithCreate(
    int Function(
      Dep2Ref ref,
    ) create,
  ) {
    return Dep2Provider._(create: create);
  }

  @override
  int create(Dep2Ref ref) {
    final _$cb = _createCb ?? dep2;
    return _$cb(ref);
  }
}

String _$dep2Hash() => r'13cd909366c79168e3d9cd95f529ddbcee6de7dc';

typedef DepFamilyRef = Ref<int>;

@ProviderFor(depFamily)
const depFamilyProvider = DepFamilyFamily._();

final class DepFamilyProvider extends $FunctionalProvider<int, int>
    with $Provider<int, DepFamilyRef> {
  const DepFamilyProvider._(
      {required DepFamilyFamily super.from,
      required int super.argument,
      int Function(
        DepFamilyRef ref,
        int id,
      )? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'depFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    DepFamilyRef ref,
    int id,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$depFamilyHash();

  @override
  String toString() {
    return r'depFamilyProvider'
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
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  DepFamilyProvider $copyWithCreate(
    int Function(
      DepFamilyRef ref,
    ) create,
  ) {
    return DepFamilyProvider._(
        argument: argument as int,
        from: from! as DepFamilyFamily,
        create: (
          ref,
          int id,
        ) =>
            create(ref));
  }

  @override
  int create(DepFamilyRef ref) {
    final _$cb = _createCb ?? depFamily;
    final argument = this.argument as int;
    return _$cb(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DepFamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$depFamilyHash() => r'c11006a8b9718af9899999b7c49f78cf3423f558';

final class DepFamilyFamily extends Family {
  const DepFamilyFamily._()
      : super(
          retry: null,
          name: r'depFamilyProvider',
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
          isAutoDispose: true,
        );

  DepFamilyProvider call(
    int id,
  ) =>
      DepFamilyProvider._(argument: id, from: this);

  @override
  String debugGetCreateSourceHash() => _$depFamilyHash();

  @override
  String toString() => r'depFamilyProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    int Function(
      DepFamilyRef ref,
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as DepFamilyProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}

////////////
// expect_lint: provider_dependencies
typedef PlainAnnotationRef = Ref<int>;

////////////
// expect_lint: provider_dependencies
@ProviderFor(plainAnnotation)
const plainAnnotationProvider = PlainAnnotationProvider._();

////////////
// expect_lint: provider_dependencies
final class PlainAnnotationProvider extends $FunctionalProvider<int, int>
    with $Provider<int, PlainAnnotationRef> {
  ////////////
// expect_lint: provider_dependencies
  const PlainAnnotationProvider._(
      {int Function(
        PlainAnnotationRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'plainAnnotationProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    PlainAnnotationRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$plainAnnotationHash();

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
  PlainAnnotationProvider $copyWithCreate(
    int Function(
      PlainAnnotationRef ref,
    ) create,
  ) {
    return PlainAnnotationProvider._(create: create);
  }

  @override
  int create(PlainAnnotationRef ref) {
    final _$cb = _createCb ?? plainAnnotation;
    return _$cb(ref);
  }
}

String _$plainAnnotationHash() => r'ceeb01dfcbd115f3676c8e38ce35a03cff16246b';

typedef CustomAnnotationRef = Ref<int>;

@ProviderFor(customAnnotation)
const customAnnotationProvider = CustomAnnotationProvider._();

final class CustomAnnotationProvider extends $FunctionalProvider<int, int>
    with $Provider<int, CustomAnnotationRef> {
  const CustomAnnotationProvider._(
      {int Function(
        CustomAnnotationRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'customAnnotationProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    CustomAnnotationRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$customAnnotationHash();

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
  CustomAnnotationProvider $copyWithCreate(
    int Function(
      CustomAnnotationRef ref,
    ) create,
  ) {
    return CustomAnnotationProvider._(create: create);
  }

  @override
  int create(CustomAnnotationRef ref) {
    final _$cb = _createCb ?? customAnnotation;
    return _$cb(ref);
  }
}

String _$customAnnotationHash() => r'04faed9b424be360e594870f91c4ef4689f05672';

typedef CustomAnnotationWithTrailingCommaRef = Ref<int>;

@ProviderFor(customAnnotationWithTrailingComma)
const customAnnotationWithTrailingCommaProvider =
    CustomAnnotationWithTrailingCommaProvider._();

final class CustomAnnotationWithTrailingCommaProvider
    extends $FunctionalProvider<int, int>
    with $Provider<int, CustomAnnotationWithTrailingCommaRef> {
  const CustomAnnotationWithTrailingCommaProvider._(
      {int Function(
        CustomAnnotationWithTrailingCommaRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'customAnnotationWithTrailingCommaProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    CustomAnnotationWithTrailingCommaRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() =>
      _$customAnnotationWithTrailingCommaHash();

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
  CustomAnnotationWithTrailingCommaProvider $copyWithCreate(
    int Function(
      CustomAnnotationWithTrailingCommaRef ref,
    ) create,
  ) {
    return CustomAnnotationWithTrailingCommaProvider._(create: create);
  }

  @override
  int create(CustomAnnotationWithTrailingCommaRef ref) {
    final _$cb = _createCb ?? customAnnotationWithTrailingComma;
    return _$cb(ref);
  }
}

String _$customAnnotationWithTrailingCommaHash() =>
    r'b5c62d769dfc53d6d77e8fde9e0eb7d8a0ab9d18';

typedef ExistingDepRef = Ref<int>;

@ProviderFor(existingDep)
const existingDepProvider = ExistingDepProvider._();

final class ExistingDepProvider extends $FunctionalProvider<int, int>
    with $Provider<int, ExistingDepRef> {
  const ExistingDepProvider._(
      {int Function(
        ExistingDepRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'existingDepProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  final int Function(
    ExistingDepRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$existingDepHash();

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
  ExistingDepProvider $copyWithCreate(
    int Function(
      ExistingDepRef ref,
    ) create,
  ) {
    return ExistingDepProvider._(create: create);
  }

  @override
  int create(ExistingDepRef ref) {
    final _$cb = _createCb ?? existingDep;
    return _$cb(ref);
  }
}

String _$existingDepHash() => r'8d7866d1af7e350d7c792e43a542cd47b130b239';

typedef MultipleDepsRef = Ref<int>;

@ProviderFor(multipleDeps)
const multipleDepsProvider = MultipleDepsProvider._();

final class MultipleDepsProvider extends $FunctionalProvider<int, int>
    with $Provider<int, MultipleDepsRef> {
  const MultipleDepsProvider._(
      {int Function(
        MultipleDepsRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'multipleDepsProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  final int Function(
    MultipleDepsRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$multipleDepsHash();

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
  MultipleDepsProvider $copyWithCreate(
    int Function(
      MultipleDepsRef ref,
    ) create,
  ) {
    return MultipleDepsProvider._(create: create);
  }

  @override
  int create(MultipleDepsRef ref) {
    final _$cb = _createCb ?? multipleDeps;
    return _$cb(ref);
  }
}

String _$multipleDepsHash() => r'9d08791636a0435ba115062a453d0d9e530ecf71';

/// Random doc to test that identifiers in docs don't trigger the lint.
/// [dep], [DepWidget], [depProvider]
typedef ProviderWithDartDocRef = Ref<int>;

/// Random doc to test that identifiers in docs don't trigger the lint.
/// [dep], [DepWidget], [depProvider]
@ProviderFor(providerWithDartDoc)
const providerWithDartDocProvider = ProviderWithDartDocProvider._();

/// Random doc to test that identifiers in docs don't trigger the lint.
/// [dep], [DepWidget], [depProvider]
final class ProviderWithDartDocProvider extends $FunctionalProvider<int, int>
    with $Provider<int, ProviderWithDartDocRef> {
  /// Random doc to test that identifiers in docs don't trigger the lint.
  /// [dep], [DepWidget], [depProvider]
  const ProviderWithDartDocProvider._(
      {int Function(
        ProviderWithDartDocRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'providerWithDartDocProvider',
          isAutoDispose: true,
          dependencies: const <ProviderOrFamily>[],
          allTransitiveDependencies: const <ProviderOrFamily>[],
        );

  final int Function(
    ProviderWithDartDocRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$providerWithDartDocHash();

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
  ProviderWithDartDocProvider $copyWithCreate(
    int Function(
      ProviderWithDartDocRef ref,
    ) create,
  ) {
    return ProviderWithDartDocProvider._(create: create);
  }

  @override
  int create(ProviderWithDartDocRef ref) {
    final _$cb = _createCb ?? providerWithDartDoc;
    return _$cb(ref);
  }
}

String _$providerWithDartDocHash() =>
    r'6aeff1697c1ec37f475319a4100e01c0e56369ae';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
