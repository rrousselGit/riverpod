// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_parameters.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(generator)
const generatorProvider = GeneratorFamily._();

final class GeneratorProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const GeneratorProvider._(
      {required GeneratorFamily super.from, required Object? super.argument})
      : super(
          retry: null,
          name: r'generatorProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$generatorHash();

  @override
  String toString() {
    return r'generatorProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    final argument = this.argument;
    return generator(
      ref,
      value: argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
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

String _$generatorHash() => r'd7d1733f8884b6702f363ddb178ae57797d0034f';

final class GeneratorFamily extends $Family {
  const GeneratorFamily._()
      : super(
          retry: null,
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
  String toString() => r'generatorProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
          int Function(
            Ref ref,
            Object? args,
          ) create) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as GeneratorProvider;
            final argument = provider.argument;
            return provider
                .$view(create: (ref) => create(ref, argument))
                .$createElement(pointer);
          });
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
