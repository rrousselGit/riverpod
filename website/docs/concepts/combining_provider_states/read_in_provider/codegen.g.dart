// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef AnotherRef = Ref<MyValue>;

@ProviderFor(another)
const anotherProvider = AnotherProvider._();

final class AnotherProvider extends $FunctionalProvider<MyValue, MyValue>
    with $Provider<MyValue, AnotherRef> {
  const AnotherProvider._(
      {MyValue Function(
        AnotherRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'anotherProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final MyValue Function(
    AnotherRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$anotherHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyValue value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<MyValue>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<MyValue> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  AnotherProvider $copyWithCreate(
    MyValue Function(
      AnotherRef ref,
    ) create,
  ) {
    return AnotherProvider._(create: create);
  }

  @override
  MyValue create(AnotherRef ref) {
    final _$cb = _createCb ?? another;
    return _$cb(ref);
  }
}

String _$anotherHash() => r'bb412edc55657c14eace37792cd18e5254604a36';

typedef MyRef = Ref<MyValue>;

@ProviderFor(my)
const myProvider = MyProvider._();

final class MyProvider extends $FunctionalProvider<MyValue, MyValue>
    with $Provider<MyValue, MyRef> {
  const MyProvider._(
      {MyValue Function(
        MyRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'myProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final MyValue Function(
    MyRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$myHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyValue value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<MyValue>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<MyValue> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  MyProvider $copyWithCreate(
    MyValue Function(
      MyRef ref,
    ) create,
  ) {
    return MyProvider._(create: create);
  }

  @override
  MyValue create(MyRef ref) {
    final _$cb = _createCb ?? my;
    return _$cb(ref);
  }
}

String _$myHash() => r'2712c772be4dbaabd4c99fd803f927a7e9938b21';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
