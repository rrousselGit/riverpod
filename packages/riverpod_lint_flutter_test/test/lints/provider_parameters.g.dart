// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_parameters.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef GeneratorRef = Ref<int>;

@ProviderFor(generator)
const generatorProvider = GeneratorFamily._();

final class GeneratorProvider
    extends $FunctionalProvider<int, int, GeneratorRef>
    with $Provider<int, GeneratorRef> {
  const GeneratorProvider._(
      {required GeneratorFamily super.from,
      required Object? super.argument,
      int Function(
        GeneratorRef ref, {
        Object? value,
      })? create})
      : _createCb = create,
        super(
          name: r'generatorProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    GeneratorRef ref, {
    Object? value,
  })? _createCb;

  @override
  String debugGetCreateSourceHash() => _$generatorHash();

  @override
  String toString() {
    return r'generatorProvider'
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

  @override
  $ProviderElement<int> createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  GeneratorProvider $copyWithCreate(
    int Function(
      GeneratorRef ref,
    ) create,
  ) {
    return GeneratorProvider._(
        argument: argument,
        from: from! as GeneratorFamily,
        create: (
          ref, {
          Object? value,
        }) =>
            create(ref));
  }

  @override
  int create(GeneratorRef ref) {
    final fn = _createCb ?? generator;
    final argument = this.argument;
    return fn(
      ref,
      value: argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GeneratorProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$generatorHash() => r'e76b8050c3a272ecef1985e4dc7dfe5df3270f2f';

final class GeneratorFamily extends Family {
  const GeneratorFamily._()
      : super(
          name: r'generatorProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: false,
        );

  GeneratorProvider call({
    Object? value,
  }) =>
      GeneratorProvider._(argument: value, from: this);

  @override
  String debugGetCreateSourceHash() => _$generatorHash();

  @override
  String toString() => r'generatorProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    int Function(
      GeneratorRef ref,
      Object? args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as GeneratorProvider;

        final argument = provider.argument;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .createElement(container);
      },
    );
  }
}

const $kDebugMode = bool.fromEnvironment('dart.vm.product');
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main
