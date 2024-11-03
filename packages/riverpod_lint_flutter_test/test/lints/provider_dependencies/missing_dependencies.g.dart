// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'missing_dependencies.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(dep)
const depProvider = DepProvider._();

final class DepProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const DepProvider._(
      {int Function(
        Ref ref,
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
    Ref ref,
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
      Ref ref,
    ) create,
  ) {
    return DepProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? dep;
    return _$cb(ref);
  }
}

String _$depHash() => r'578a350a40cda46444ecd9fa3ea2fd7bd0994692';

@ProviderFor(transitiveDep)
const transitiveDepProvider = TransitiveDepProvider._();

final class TransitiveDepProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const TransitiveDepProvider._(
      {int Function(
        Ref ref,
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
    Ref ref,
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
      Ref ref,
    ) create,
  ) {
    return TransitiveDepProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? transitiveDep;
    return _$cb(ref);
  }
}

String _$transitiveDepHash() => r'cedc000b7d16447684dff970ddea659cca24cdf6';

@ProviderFor(dep2)
const dep2Provider = Dep2Provider._();

final class Dep2Provider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const Dep2Provider._(
      {int Function(
        Ref ref,
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
    Ref ref,
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
      Ref ref,
    ) create,
  ) {
    return Dep2Provider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? dep2;
    return _$cb(ref);
  }
}

String _$dep2Hash() => r'97901e825cdcf5b1ac455b0fe8a2111662ce9f13';

@ProviderFor(depFamily)
const depFamilyProvider = DepFamilyFamily._();

final class DepFamilyProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const DepFamilyProvider._(
      {required DepFamilyFamily super.from,
      required int super.argument,
      int Function(
        Ref ref,
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
    Ref ref,
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
      Ref ref,
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
  int create(Ref ref) {
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

String _$depFamilyHash() => r'6cca68b98693e352e9b801b1fc441d438fc72525';

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
      Ref ref,
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
@ProviderFor(plainAnnotation)
const plainAnnotationProvider = PlainAnnotationProvider._();

////////////
// expect_lint: provider_dependencies
final class PlainAnnotationProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  ////////////
// expect_lint: provider_dependencies
  const PlainAnnotationProvider._(
      {int Function(
        Ref ref,
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
    Ref ref,
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
      Ref ref,
    ) create,
  ) {
    return PlainAnnotationProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? plainAnnotation;
    return _$cb(ref);
  }
}

String _$plainAnnotationHash() => r'6a3d1f1f2e53902af56cd7ce6ceba17358690b70';

@ProviderFor(customAnnotation)
const customAnnotationProvider = CustomAnnotationProvider._();

final class CustomAnnotationProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const CustomAnnotationProvider._(
      {int Function(
        Ref ref,
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
    Ref ref,
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
      Ref ref,
    ) create,
  ) {
    return CustomAnnotationProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? customAnnotation;
    return _$cb(ref);
  }
}

String _$customAnnotationHash() => r'8081bbad2cfbe5bff1ace9aa3be450dd28112488';

@ProviderFor(customAnnotationWithTrailingComma)
const customAnnotationWithTrailingCommaProvider =
    CustomAnnotationWithTrailingCommaProvider._();

final class CustomAnnotationWithTrailingCommaProvider
    extends $FunctionalProvider<int, int> with $Provider<int> {
  const CustomAnnotationWithTrailingCommaProvider._(
      {int Function(
        Ref ref,
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
    Ref ref,
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
      Ref ref,
    ) create,
  ) {
    return CustomAnnotationWithTrailingCommaProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? customAnnotationWithTrailingComma;
    return _$cb(ref);
  }
}

String _$customAnnotationWithTrailingCommaHash() =>
    r'709613050eb1db7b4c43cb87855e2c32988141d8';

@ProviderFor(existingDep)
const existingDepProvider = ExistingDepProvider._();

final class ExistingDepProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const ExistingDepProvider._(
      {int Function(
        Ref ref,
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
    Ref ref,
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
      Ref ref,
    ) create,
  ) {
    return ExistingDepProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? existingDep;
    return _$cb(ref);
  }
}

String _$existingDepHash() => r'73e7e1a0d4c2ae07ed03fb248408c3d82fe85554';

@ProviderFor(multipleDeps)
const multipleDepsProvider = MultipleDepsProvider._();

final class MultipleDepsProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const MultipleDepsProvider._(
      {int Function(
        Ref ref,
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
    Ref ref,
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
      Ref ref,
    ) create,
  ) {
    return MultipleDepsProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? multipleDeps;
    return _$cb(ref);
  }
}

String _$multipleDepsHash() => r'66de70567c011a294a2c46703dfab8ba7247fd5e';

/// Random doc to test that identifiers in docs don't trigger the lint.
/// [dep], [DepWidget], [depProvider]
@ProviderFor(providerWithDartDoc)
const providerWithDartDocProvider = ProviderWithDartDocProvider._();

/// Random doc to test that identifiers in docs don't trigger the lint.
/// [dep], [DepWidget], [depProvider]
final class ProviderWithDartDocProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  /// Random doc to test that identifiers in docs don't trigger the lint.
  /// [dep], [DepWidget], [depProvider]
  const ProviderWithDartDocProvider._(
      {int Function(
        Ref ref,
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
    Ref ref,
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
      Ref ref,
    ) create,
  ) {
    return ProviderWithDartDocProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? providerWithDartDoc;
    return _$cb(ref);
  }
}

String _$providerWithDartDocHash() =>
    r'aeb5735ad2dbe1d0b41a529828f9bb2c915071b6';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
