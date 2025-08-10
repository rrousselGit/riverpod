// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

@ProviderFor(label)
const labelProvider = LabelFamily._();

final class LabelProvider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const LabelProvider._(
      {required LabelFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'labelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$labelHash();

  @override
  String toString() {
    return r'labelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as String;
    return label(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
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

final class LabelFamily extends $Family
    with $FunctionalFamilyOverride<String, String> {
  const LabelFamily._()
      : super(
          retry: null,
          name: r'labelProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  LabelProvider call(
    String userName,
  ) =>
      LabelProvider._(argument: userName, from: this);

  @override
  String toString() => r'labelProvider';
}
