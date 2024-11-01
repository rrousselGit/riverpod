// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retry.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef ARef = Ref<String>;

@ProviderFor(a)
const aProvider = AProvider._();

final class AProvider extends $FunctionalProvider<String, String>
    with $Provider<String, ARef> {
  const AProvider._(
      {String Function(
        ARef ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: myRetry,
          name: r'aProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    ARef ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$aHash();

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
  AProvider $copyWithCreate(
    String Function(
      ARef ref,
    ) create,
  ) {
    return AProvider._(create: create);
  }

  @override
  String create(ARef ref) {
    final _$cb = _createCb ?? a;
    return _$cb(ref);
  }
}

String _$aHash() => r'83a9516d10f85dc72ca773837e042bfc6e36c1f1';

typedef BRef = Ref<String>;

@ProviderFor(b)
const bProvider = BFamily._();

final class BProvider extends $FunctionalProvider<String, String>
    with $Provider<String, BRef> {
  const BProvider._(
      {required BFamily super.from,
      required int super.argument,
      String Function(
        BRef ref,
        int arg,
      )? create})
      : _createCb = create,
        super(
          retry: myRetry2,
          name: r'bProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    BRef ref,
    int arg,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$bHash();

  @override
  String toString() {
    return r'bProvider'
        ''
        '($argument)';
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
  BProvider $copyWithCreate(
    String Function(
      BRef ref,
    ) create,
  ) {
    return BProvider._(
        argument: argument as int,
        from: from! as BFamily,
        create: (
          ref,
          int arg,
        ) =>
            create(ref));
  }

  @override
  String create(BRef ref) {
    final _$cb = _createCb ?? b;
    final argument = this.argument as int;
    return _$cb(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bHash() => r'95798a157250c86a901bca5701b487f508f8a5a4';

final class BFamily extends Family {
  const BFamily._()
      : super(
          retry: myRetry2,
          name: r'bProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  BProvider call(
    int arg,
  ) =>
      BProvider._(argument: arg, from: this);

  @override
  String debugGetCreateSourceHash() => _$bHash();

  @override
  String toString() => r'bProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    String Function(
      BRef ref,
      int args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as BProvider;

        final argument = provider.argument as int;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
