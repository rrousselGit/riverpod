// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(another)
const anotherProvider = AnotherProvider._();

final class AnotherProvider
    extends $FunctionalProvider<MyValue, MyValue, MyValue>
    with $Provider<MyValue> {
  const AnotherProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'anotherProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$anotherHash();

  @$internal
  @override
  $ProviderElement<MyValue> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MyValue create(Ref ref) {
    return another(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyValue value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MyValue>(value),
    );
  }
}

String _$anotherHash() => r'07629e5ae4a53bcd316b91c07d7558edbdea9317';

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

String _$myHash() => r'816efc8816269dabd0944c434946903db197fe0b';
