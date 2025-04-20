// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(my)
const myProvider = MyProvider._();

final class MyProvider extends $FunctionalProvider<MyValue, MyValue>
    with $Provider<MyValue> {
  const MyProvider._(
      {MyValue Function(
        Ref ref,
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
    Ref ref,
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
      Ref ref,
    ) create,
  ) {
    return MyProvider._(create: create);
  }

  @override
  MyValue create(Ref ref) {
    final _$cb = _createCb ?? my;
    return _$cb(ref);
  }
}

String _$myHash() => r'abf4b86b981ed95db3f391483b0a1497c33e98b8';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
