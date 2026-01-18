// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'missing_dependencies.provider_dependencies-4.fix.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dep)
final depProvider = DepProvider._();

final class DepProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  DepProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'depProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$depHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return dep(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$depHash() => r'578a350a40cda46444ecd9fa3ea2fd7bd0994692';

@ProviderFor(transitiveDep)
final transitiveDepProvider = TransitiveDepProvider._();

final class TransitiveDepProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  TransitiveDepProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transitiveDepProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[depProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          TransitiveDepProvider.$allTransitiveDependencies0,
        ],
      );

  static final $allTransitiveDependencies0 = depProvider;

  @override
  String debugGetCreateSourceHash() => _$transitiveDepHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return transitiveDep(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$transitiveDepHash() => r'cedc000b7d16447684dff970ddea659cca24cdf6';

@ProviderFor(dep2)
final dep2Provider = Dep2Provider._();

final class Dep2Provider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  Dep2Provider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dep2Provider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$dep2Hash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return dep2(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$dep2Hash() => r'97901e825cdcf5b1ac455b0fe8a2111662ce9f13';

@ProviderFor(depFamily)
final depFamilyProvider = DepFamilyFamily._();

final class DepFamilyProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  DepFamilyProvider._({
    required DepFamilyFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'depFamilyProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$depFamilyHash();

  @override
  String toString() {
    return r'depFamilyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    final argument = this.argument as int;
    return depFamily(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
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

final class DepFamilyFamily extends $Family
    with $FunctionalFamilyOverride<int, int> {
  DepFamilyFamily._()
    : super(
        retry: null,
        name: r'depFamilyProvider',
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
        isAutoDispose: true,
      );

  DepFamilyProvider call(int id) =>
      DepFamilyProvider._(argument: id, from: this);

  @override
  String toString() => r'depFamilyProvider';
}
////////////
// ignore: riverpod_lint/provider_dependencies

@ProviderFor(plainAnnotation)
final plainAnnotationProvider = PlainAnnotationProvider._();

////////////
// ignore: riverpod_lint/provider_dependencies

final class PlainAnnotationProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  ////////////
  // ignore: riverpod_lint/provider_dependencies
  PlainAnnotationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plainAnnotationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plainAnnotationHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return plainAnnotation(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$plainAnnotationHash() => r'6a3d1f1f2e53902af56cd7ce6ceba17358690b70';

@ProviderFor(customAnnotation)
final customAnnotationProvider = CustomAnnotationProvider._();

final class CustomAnnotationProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  CustomAnnotationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customAnnotationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customAnnotationHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return customAnnotation(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$customAnnotationHash() => r'8081bbad2cfbe5bff1ace9aa3be450dd28112488';

@ProviderFor(customAnnotationWithTrailingComma)
final customAnnotationWithTrailingCommaProvider =
    CustomAnnotationWithTrailingCommaProvider._();

final class CustomAnnotationWithTrailingCommaProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  CustomAnnotationWithTrailingCommaProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customAnnotationWithTrailingCommaProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$customAnnotationWithTrailingCommaHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return customAnnotationWithTrailingComma(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$customAnnotationWithTrailingCommaHash() =>
    r'709613050eb1db7b4c43cb87855e2c32988141d8';

@ProviderFor(existingDep)
final existingDepProvider = ExistingDepProvider._();

final class ExistingDepProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  ExistingDepProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'existingDepProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$existingDepHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return existingDep(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$existingDepHash() => r'73e7e1a0d4c2ae07ed03fb248408c3d82fe85554';

@ProviderFor(multipleDeps)
final multipleDepsProvider = MultipleDepsProvider._();

final class MultipleDepsProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  MultipleDepsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'multipleDepsProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$multipleDepsHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return multipleDeps(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$multipleDepsHash() => r'66de70567c011a294a2c46703dfab8ba7247fd5e';

/// Random doc to test that identifiers in docs don't trigger the lint.
/// [dep], [DepWidget], [depProvider]

@ProviderFor(providerWithDartDoc)
final providerWithDartDocProvider = ProviderWithDartDocProvider._();

/// Random doc to test that identifiers in docs don't trigger the lint.
/// [dep], [DepWidget], [depProvider]

final class ProviderWithDartDocProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Random doc to test that identifiers in docs don't trigger the lint.
  /// [dep], [DepWidget], [depProvider]
  ProviderWithDartDocProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'providerWithDartDocProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$providerWithDartDocHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return providerWithDartDoc(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$providerWithDartDocHash() =>
    r'aeb5735ad2dbe1d0b41a529828f9bb2c915071b6';
