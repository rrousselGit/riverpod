// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen_keep_alive.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef ExampleRef = Ref<int>;

@ProviderFor(example)
const exampleProvider = ExampleProvider._();

final class ExampleProvider extends $FunctionalProvider<int, int>
    with $Provider<int, ExampleRef> {
  const ExampleProvider._(
      {int Function(
        ExampleRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'exampleProvider',
          isAutoDispose: false,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    ExampleRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$exampleHash();

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
  ExampleProvider $copyWithCreate(
    int Function(
      ExampleRef ref,
    ) create,
  ) {
    return ExampleProvider._(create: create);
  }

  @override
  int create(ExampleRef ref) {
    final _$cb = _createCb ?? example;
    return _$cb(ref);
  }
}

String _$exampleHash() => r'78f9426f6cbda80564387a9db8cd02368d890a85';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
