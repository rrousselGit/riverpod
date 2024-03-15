// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef LabelRef = Ref<String>;

@ProviderFor(label)
const labelProvider = LabelFamily._();

final class LabelProvider extends $FunctionalProvider<String, String>
    with $Provider<String, LabelRef> {
  const LabelProvider._(
      {required LabelFamily super.from,
      required String super.argument,
      String Function(
        LabelRef ref,
        String userName,
      )? create})
      : _createCb = create,
        super(
          name: r'labelProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final String Function(
    LabelRef ref,
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
      LabelRef ref,
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
  String create(LabelRef ref) {
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

String _$labelHash() => r'20aa8ce0231205540f466f91259732bd86953c64';

final class LabelFamily extends Family {
  const LabelFamily._()
      : super(
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
      LabelRef ref,
      String args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer, provider) {
        provider as LabelProvider;

        final argument = provider.argument as String;

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
