// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convert_functional_provider_to_class_based.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Some comment
@ProviderFor(example)
const exampleProvider = ExampleProvider._();

/// Some comment
final class ExampleProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  /// Some comment
  const ExampleProvider._(
      {int Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'exampleProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$exampleHash();

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
  ExampleProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return ExampleProvider._(create: create);
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? example;
    return _$cb(ref);
  }
}

String _$exampleHash() => r'67898608b444d39a000852f647ca6d3326740c98';

/// Some comment
@ProviderFor(exampleFamily)
const exampleFamilyProvider = ExampleFamilyFamily._();

/// Some comment
final class ExampleFamilyProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  /// Some comment
  const ExampleFamilyProvider._(
      {required ExampleFamilyFamily super.from,
      required ({
        int a,
        String b,
      })
          super.argument,
      int Function(
        Ref ref, {
        required int a,
        String b,
      })? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'exampleFamilyProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref, {
    required int a,
    String b,
  })? _createCb;

  @override
  String debugGetCreateSourceHash() => _$exampleFamilyHash();

  @override
  String toString() {
    return r'exampleFamilyProvider'
        ''
        '$argument';
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
  ExampleFamilyProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return ExampleFamilyProvider._(
        argument: argument as ({
          int a,
          String b,
        }),
        from: from! as ExampleFamilyFamily,
        create: (
          ref, {
          required int a,
          String b = '42',
        }) =>
            create(ref));
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? exampleFamily;
    final argument = this.argument as ({
      int a,
      String b,
    });
    return _$cb(
      ref,
      a: argument.a,
      b: argument.b,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ExampleFamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$exampleFamilyHash() => r'70dfc6f4b2d7d251edbc3a66c3ac0f2c56aebf8b';

/// Some comment
final class ExampleFamilyFamily extends Family {
  const ExampleFamilyFamily._()
      : super(
          retry: null,
          name: r'exampleFamilyProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Some comment
  ExampleFamilyProvider call({
    required int a,
    String b = '42',
  }) =>
      ExampleFamilyProvider._(argument: (
        a: a,
        b: b,
      ), from: this);

  @override
  String debugGetCreateSourceHash() => _$exampleFamilyHash();

  @override
  String toString() => r'exampleFamilyProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    int Function(
      Ref ref,
      ({
        int a,
        String b,
      }) args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as ExampleFamilyProvider;

        final argument = provider.argument as ({
          int a,
          String b,
        });

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
