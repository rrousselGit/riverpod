// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(my)
const myProvider = MyProvider._();

final class MyProvider extends $FunctionalProvider<MyValue, MyValue, MyValue>
    with $Provider<MyValue> {
  const MyProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'myProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$myHash();

  @$internal
  @override
  $ProviderElement<MyValue> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MyValue create(Ref ref) {
    return my(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyValue value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MyValue>(value),
    );
  }
}

String _$myHash() => r'abf4b86b981ed95db3f391483b0a1497c33e98b8';
