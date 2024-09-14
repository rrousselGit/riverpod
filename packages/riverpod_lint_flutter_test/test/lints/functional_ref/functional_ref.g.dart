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

String _$genericsHash() => r'b5813cf6a00581bafea48d8ab66f7d5468fff0e4';

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

typedef NoGenericsRef<A extends num, B> = Ref<int>;

@ProviderFor(noGenerics)
const noGenericsProvider = NoGenericsFamily._();

final class NoGenericsProvider<A extends num, B>
    extends $FunctionalProvider<int, int>
    with $Provider<int, NoGenericsRef<A, B>> {
  const NoGenericsProvider._(
      {required NoGenericsFamily super.from,
      int Function(
        NoGenericsRef<A, B> ref,
      )? create})
      : _createCb = create,
        super(
          argument: null,
          retry: null,
          name: r'noGenericsProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    NoGenericsRef<A, B> ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$noGenericsHash();

  NoGenericsProvider<A, B> _copyWithCreate(
    int Function<A extends num, B>(
      NoGenericsRef<A, B> ref,
    ) create,
  ) {
    return NoGenericsProvider<A, B>._(
        from: from! as NoGenericsFamily, create: create<A, B>);
  }

  @override
  String toString() {
    return r'noGenericsProvider'
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
  NoGenericsProvider<A, B> $copyWithCreate(
    int Function(
      NoGenericsRef<A, B> ref,
    ) create,
  ) {
    return NoGenericsProvider<A, B>._(
        from: from! as NoGenericsFamily, create: create);
  }

  @override
  int create(NoGenericsRef<A, B> ref) {
    final _$cb = _createCb ?? noGenerics<A, B>;
    return _$cb(ref);
  }

  @override
  bool operator ==(Object other) {
    return other is NoGenericsProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$noGenericsHash() => r'449264e25990bc14ad811c0940117c8cde4d730a';

final class NoGenericsFamily extends Family {
  const NoGenericsFamily._()
      : super(
          retry: null,
          name: r'noGenericsProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  NoGenericsProvider<A, B> call<A extends num, B>() =>
      NoGenericsProvider<A, B>._(from: this);

  @override
  String debugGetCreateSourceHash() => _$noGenericsHash();

  @override
  String toString() => r'noGenericsProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    int Function<A extends num, B>(NoGenericsRef<A, B> ref) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as NoGenericsProvider;

        return provider._copyWithCreate(create).$createElement(pointer);
      },
    );
  }
}

typedef MissingGenericsRef<A, B> = Ref<int>;

@ProviderFor(missingGenerics)
const missingGenericsProvider = MissingGenericsFamily._();

final class MissingGenericsProvider<A, B> extends $FunctionalProvider<int, int>
    with $Provider<int, MissingGenericsRef<A, B>> {
  const MissingGenericsProvider._(
      {required MissingGenericsFamily super.from,
      int Function(
        MissingGenericsRef<A, B> ref,
      )? create})
      : _createCb = create,
        super(
          argument: null,
          retry: null,
          name: r'missingGenericsProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    MissingGenericsRef<A, B> ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$missingGenericsHash();

  MissingGenericsProvider<A, B> _copyWithCreate(
    int Function<A, B>(
      MissingGenericsRef<A, B> ref,
    ) create,
  ) {
    return MissingGenericsProvider<A, B>._(
        from: from! as MissingGenericsFamily, create: create<A, B>);
  }

  @override
  String toString() {
    return r'missingGenericsProvider'
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
  MissingGenericsProvider<A, B> $copyWithCreate(
    int Function(
      MissingGenericsRef<A, B> ref,
    ) create,
  ) {
    return MissingGenericsProvider<A, B>._(
        from: from! as MissingGenericsFamily, create: create);
  }

  @override
  int create(MissingGenericsRef<A, B> ref) {
    final _$cb = _createCb ?? missingGenerics<A, B>;
    return _$cb(ref);
  }

  @override
  bool operator ==(Object other) {
    return other is MissingGenericsProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$missingGenericsHash() => r'7d8bc49e4f1e466260fbf6a61a3f9e62b4aef28f';

final class MissingGenericsFamily extends Family {
  const MissingGenericsFamily._()
      : super(
          retry: null,
          name: r'missingGenericsProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  MissingGenericsProvider<A, B> call<A, B>() =>
      MissingGenericsProvider<A, B>._(from: this);

  @override
  String debugGetCreateSourceHash() => _$missingGenericsHash();

  @override
  String toString() => r'missingGenericsProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    int Function<A, B>(MissingGenericsRef<A, B> ref) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as MissingGenericsProvider;

        return provider._copyWithCreate(create).$createElement(pointer);
      },
    );
  }
}

typedef WrongOrderRef<B, A> = Ref<int>;

@ProviderFor(wrongOrder)
const wrongOrderProvider = WrongOrderFamily._();

final class WrongOrderProvider<B, A> extends $FunctionalProvider<int, int>
    with $Provider<int, WrongOrderRef<B, A>> {
  const WrongOrderProvider._(
      {required WrongOrderFamily super.from,
      int Function(
        WrongOrderRef<B, A> ref,
      )? create})
      : _createCb = create,
        super(
          argument: null,
          retry: null,
          name: r'wrongOrderProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    WrongOrderRef<B, A> ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$wrongOrderHash();

  WrongOrderProvider<B, A> _copyWithCreate(
    int Function<B, A>(
      WrongOrderRef<B, A> ref,
    ) create,
  ) {
    return WrongOrderProvider<B, A>._(
        from: from! as WrongOrderFamily, create: create<B, A>);
  }

  @override
  String toString() {
    return r'wrongOrderProvider'
        '<${B}, ${A}>'
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
  WrongOrderProvider<B, A> $copyWithCreate(
    int Function(
      WrongOrderRef<B, A> ref,
    ) create,
  ) {
    return WrongOrderProvider<B, A>._(
        from: from! as WrongOrderFamily, create: create);
  }

  @override
  int create(WrongOrderRef<B, A> ref) {
    final _$cb = _createCb ?? wrongOrder<B, A>;
    return _$cb(ref);
  }

  @override
  bool operator ==(Object other) {
    return other is WrongOrderProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$wrongOrderHash() => r'6732863e85b220c07f82c2d13be15c1e6f08192d';

final class WrongOrderFamily extends Family {
  const WrongOrderFamily._()
      : super(
          retry: null,
          name: r'wrongOrderProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  WrongOrderProvider<B, A> call<B, A>() =>
      WrongOrderProvider<B, A>._(from: this);

  @override
  String debugGetCreateSourceHash() => _$wrongOrderHash();

  @override
  String toString() => r'wrongOrderProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    int Function<B, A>(WrongOrderRef<B, A> ref) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as WrongOrderProvider;

        return provider._copyWithCreate(create).$createElement(pointer);
      },
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
