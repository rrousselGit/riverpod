// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef SynchronousExampleRef = Ref<int>;

@ProviderFor(synchronousExample)
const synchronousExampleProvider = SynchronousExampleProvider._();

final class SynchronousExampleProvider
    extends $FunctionalProvider<int, int, SynchronousExampleRef>
    with $Provider<int, SynchronousExampleRef> {
  const SynchronousExampleProvider._(
      {int Function(
        SynchronousExampleRef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          name: r'synchronousExampleProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final int Function(
    SynchronousExampleRef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$synchronousExampleHash();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<int> $createElement(ProviderContainer container) =>
      $ProviderElement(this, container);

  @override
  SynchronousExampleProvider $copyWithCreate(
    int Function(
      SynchronousExampleRef ref,
    ) create,
  ) {
    return SynchronousExampleProvider._(create: create);
  }

  @override
  int create(SynchronousExampleRef ref) {
    final _$cb = _createCb ?? synchronousExample;
    return _$cb(ref);
  }
}

String _$synchronousExampleHash() =>
    r'98df96e07d554683041f668c06b36f183ff534c1';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
