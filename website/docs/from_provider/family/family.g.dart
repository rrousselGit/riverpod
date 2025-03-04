// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'family.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(random)
const randomProvider = RandomFamily._();

final class RandomProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const RandomProvider._(
      {required RandomFamily super.from,
      required ({
        int seed,
        int max,
      })
          super.argument,
      int Function(
        Ref ref, {
        required int seed,
        required int max,
      })? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'randomProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    Ref ref, {
    required int seed,
    required int max,
  })? _createCb;

  @override
  String debugGetCreateSourceHash() => _$randomHash();

  @override
  String toString() {
    return r'randomProvider'
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
  RandomProvider $copyWithCreate(
    int Function(
      Ref ref,
    ) create,
  ) {
    return RandomProvider._(
        argument: argument as ({
          int seed,
          int max,
        }),
        from: from! as RandomFamily,
        create: (
          ref, {
          required int seed,
          required int max,
        }) =>
            create(ref));
  }

  @override
  int create(Ref ref) {
    final _$cb = _createCb ?? random;
    final argument = this.argument as ({
      int seed,
      int max,
    });
    return _$cb(
      ref,
      seed: argument.seed,
      max: argument.max,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RandomProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$randomHash() => r'ab69799dce84746b22880feae0f1db6dea906f6a';

final class RandomFamily extends Family {
  const RandomFamily._()
      : super(
          retry: null,
          name: r'randomProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  RandomProvider call({
    required int seed,
    required int max,
  }) =>
      RandomProvider._(argument: (
        seed: seed,
        max: max,
      ), from: this);

  @override
  String debugGetCreateSourceHash() => _$randomHash();

  @override
  String toString() => r'randomProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    int Function(
      Ref ref,
      ({
        int seed,
        int max,
      }) args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as RandomProvider;

        final argument = provider.argument as ({
          int seed,
          int max,
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
