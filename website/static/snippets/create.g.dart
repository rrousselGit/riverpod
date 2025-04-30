// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'create.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(boredSuggestion)
const boredSuggestionProvider = BoredSuggestionProvider._();

final class BoredSuggestionProvider
    extends $FunctionalProvider<AsyncValue<String>, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  const BoredSuggestionProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'boredSuggestionProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$boredSuggestionHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return boredSuggestion(ref);
  }
}

String _$boredSuggestionHash() => r'ea7579b20dd2a5f45fd9d9ea09fcbd3608330d24';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
