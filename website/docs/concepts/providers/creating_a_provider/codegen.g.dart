// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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

String _$myHash() => r'0810ee24cae78c131d00773ac20d254c83eefab7';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
