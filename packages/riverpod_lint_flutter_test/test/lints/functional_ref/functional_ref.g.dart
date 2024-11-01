// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'functional_ref.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef NamelessRef = Ref<int>;

@ProviderFor(nameless)
const namelessProvider = NamelessProvider._();

final class NamelessProvider extends $FunctionalProvider<int, int>
    with $Provider<int, NamelessRef> {
  const NamelessProvider._(
      {int Function(
        NamelessRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'namelessProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    NamelessRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$namelessHash();

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
  NamelessProvider $copyWithCreate(
    int Function(
      NamelessRef ref,
    ) create,
  ) {
    return NamelessProvider._(create: create);
  }

  @override
  int create(NamelessRef ref) {
    final _$cb = _createCb ?? nameless;
    return _$cb(ref);
  }
}

String _$namelessHash() => r'1a2aa61445a64c65301051820b159c5998195606';

typedef GenericsRef<A extends num, B> = Ref<int>;

@ProviderFor(generics)
const genericsProvider = GenericsFamily._();

final class GenericsProvider<A extends num, B>
    extends $FunctionalProvider<int, int>
    with $Provider<int, GenericsRef<A, B>> {
  const GenericsProvider._(
      {required GenericsFamily super.from,
      int Function(
        GenericsRef<A, B> ref,
      )? create})
      : _createCb = create,
        super(
          argument: null,
          retry: null,
          name: r'genericsProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    GenericsRef<A, B> ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$genericsHash();

  GenericsProvider<A, B> _copyWithCreate(
    int Function<A extends num, B>(
      GenericsRef<A, B> ref,
    ) create,
  ) {
    return GenericsProvider<A, B>._(
        from: from! as GenericsFamily, create: create<A, B>);
  }

  @override
  String toString() {
    return r'genericsProvider'
        '<${A}, ${B}>'
        '()';
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
  GenericsProvider<A, B> $copyWithCreate(
    int Function(
      GenericsRef<A, B> ref,
    ) create,
  ) {
    return GenericsProvider<A, B>._(
        from: from! as GenericsFamily, create: create);
  }

  @override
  int create(GenericsRef<A, B> ref) {
    final _$cb = _createCb ?? generics<A, B>;
    return _$cb(ref);
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

final class GenericsFamily extends Family {
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
  String debugGetCreateSourceHash() => _$genericsHash();

  @override
  String toString() => r'genericsProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    int Function<A extends num, B>(GenericsRef<A, B> ref) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as GenericsProvider;

        return provider._copyWithCreate(create).$createElement(pointer);
      },
    );
  }
}

typedef ValidRef = Ref<int>;

@ProviderFor(valid)
const validProvider = ValidProvider._();

final class ValidProvider extends $FunctionalProvider<int, int>
    with $Provider<int, ValidRef> {
  const ValidProvider._(
      {int Function(
        ValidRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'validProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    ValidRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$validHash();

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
  ValidProvider $copyWithCreate(
    int Function(
      ValidRef ref,
    ) create,
  ) {
    return ValidProvider._(create: create);
  }

  @override
  int create(ValidRef ref) {
    final _$cb = _createCb ?? valid;
    return _$cb(ref);
  }
}

String _$validHash() => r'f33913278e3b1615927fe05b3e6e1f781da7729a';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
