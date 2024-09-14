// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'family_fn.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef ExampleRef = Ref<String>;

@ProviderFor(example)
const exampleProvider = ExampleFamily._();

final class ExampleProvider extends $FunctionalProvider<String, String>
    with $Provider<String, ExampleRef> {
  const ExampleProvider._(
      {required ExampleFamily super.from,
      required (
        int, {
        String param2,
      })
          super.argument,
      String Function(
        ExampleRef ref,
        int param1, {
        String param2,
      })? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'exampleProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    ExampleRef ref,
    int param1, {
    String param2,
  })? _createCb;

  @override
  String debugGetCreateSourceHash() => _$exampleHash();

  @override
  String toString() {
    return r'exampleProvider'
        ''
        '$argument';
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(this, pointer);

  @override
  ExampleProvider $copyWithCreate(
    String Function(
      ExampleRef ref,
    ) create,
  ) {
    return ExampleProvider._(
        argument: argument as (
          int, {
          String param2,
        }),
        from: from! as ExampleFamily,
        create: (
          ref,
          int param1, {
          String param2 = 'foo',
        }) =>
            create(ref));
  }

  @override
  String create(ExampleRef ref) {
    final _$cb = _createCb ?? example;
    final argument = this.argument as (
      int, {
      String param2,
    });
    return _$cb(
      ref,
      argument.$1,
      param2: argument.param2,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ExampleProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$exampleHash() => r'9c32e94eea83a436746088de51e6426f251b2190';

final class ExampleFamily extends Family {
  const ExampleFamily._()
      : super(
          retry: null,
          name: r'exampleProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ExampleProvider call(
    int param1, {
    String param2 = 'foo',
  }) =>
      ExampleProvider._(argument: (
        param1,
        param2: param2,
      ), from: this);

  @override
  String debugGetCreateSourceHash() => _$exampleHash();

  @override
  String toString() => r'exampleProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    String Function(
      ExampleRef ref,
      (
        int, {
        String param2,
      }) args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as ExampleProvider;

        final argument = provider.argument as (
          int, {
          String param2,
        });

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
