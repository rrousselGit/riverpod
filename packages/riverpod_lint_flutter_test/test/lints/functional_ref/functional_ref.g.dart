// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'functional_ref.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(nameless)
const namelessProvider = NamelessProvider._();

final class NamelessProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const NamelessProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'namelessProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$namelessHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return nameless(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$namelessHash() => r'1a2aa61445a64c65301051820b159c5998195606';

@ProviderFor(generics)
const genericsProvider = GenericsFamily._();

final class GenericsProvider<A extends num, B>
    extends $FunctionalProvider<int, int> with $Provider<int> {
  const GenericsProvider._({required GenericsFamily super.from})
      : super(
          argument: null,
          retry: null,
          name: r'genericsProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$genericsHash();

  @override
  String toString() {
    return r'genericsProvider'
        '<${A}, ${B}>'
        '()';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return generics<A, B>(ref);
  }

  $R _captureGenerics<$R>($R Function<A extends num, B>() cb) {
    return cb<A, B>();
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
    return other is GenericsProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$genericsHash() => r'dddbd6460e73b1f20343bbadee6666311c5ac0ea';

final class GenericsFamily extends $Family {
  const GenericsFamily._()
      : super(
          retry: null,
          name: r'genericsProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  GenericsProvider<A, B> call<A extends num, B>() =>
      GenericsProvider<A, B>._(from: this);

  @override
  String toString() => r'genericsProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(int Function<A extends num, B>(Ref ref) create) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as GenericsProvider;
            return provider._captureGenerics(<A extends num, B>() {
              provider as GenericsProvider<A, B>;
              return provider
                  .$view(create: create<A, B>)
                  .$createElement(pointer);
            });
          });
}

@ProviderFor(valid)
const validProvider = ValidProvider._();

final class ValidProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const ValidProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'validProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$validHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return valid(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$validHash() => r'f33913278e3b1615927fe05b3e6e1f781da7729a';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
