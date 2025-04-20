// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(label)
const labelProvider = LabelFamily._();

final class LabelProvider extends $FunctionalProvider<String, String>
    with $Provider<String> {
  const LabelProvider._(
      {required LabelFamily super.from,
      required String super.argument,
      String Function(
        Ref ref,
        String userName,
      )? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'labelProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    Ref ref,
    String userName,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$labelHash();

  @override
  String toString() {
    return r'labelProvider'
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
  LabelProvider $copyWithCreate(
    String Function(
      Ref ref,
    ) create,
  ) {
    return LabelProvider._(
        argument: argument as String,
        from: from! as LabelFamily,
        create: (
          ref,
          String userName,
        ) =>
            create(ref));
  }

  @override
  String create(Ref ref) {
    final _$cb = _createCb ?? label;
    final argument = this.argument as String;
    return _$cb(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LabelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$labelHash() => r'c53d17dd111313633bd7ca6d6cf6b48dded58ca5';

final class LabelFamily extends Family {
  const LabelFamily._()
      : super(
          retry: null,
          name: r'labelProvider',
          dependencies: null,
          allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  LabelProvider call(
    String userName,
  ) =>
      LabelProvider._(argument: userName, from: this);

  @override
  String debugGetCreateSourceHash() => _$labelHash();

  @override
  String toString() => r'labelProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    String Function(
      Ref ref,
      String args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as LabelProvider;

        final argument = provider.argument as String;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
