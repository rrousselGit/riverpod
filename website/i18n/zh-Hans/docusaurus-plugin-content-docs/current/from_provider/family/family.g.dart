// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'family.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef RandomRef = Ref<int>;

@ProviderFor(random)
const randomProvider = RandomFamily._();

final class RandomProvider extends $FunctionalProvider<int, int, RandomRef>
    with $Provider<int, RandomRef> {
  const RandomProvider._(
      {required RandomFamily super.from,
      required ({
        int seed,
        int max,
      })
          super.argument,
      int Function(
        RandomRef ref, {
        required int seed,
        required int max,
      })? create})
      : _createCb = create,
        super(
          name: r'randomProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    RandomRef ref, {
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
  $ProviderElement<int> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  RandomProvider $copyWithCreate(
    int Function(
      RandomRef ref,
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
  int create(RandomRef ref) {
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

String _$randomHash() => r'517b12aad4df7b31f8872b89af74e7880377b2ea';

final class RandomFamily extends Family {
  const RandomFamily._()
      : super(
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
      RandomRef ref,
      ({
        int seed,
        int max,
      }) args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as RandomProvider;

        final argument = provider.argument as ({
          int seed,
          int max,
        });

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(container);
      },
    );
  }
}

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
