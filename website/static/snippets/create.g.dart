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
  const BoredSuggestionProvider._(
      {FutureOr<String> Function(
        Ref ref,
      )? create})
      : _createCb = create,
        super(
          from: null,
          argument: null,
          retry: null,
          name: r'boredSuggestionProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<String> Function(
    Ref ref,
  )? _createCb;

  @override
  String debugGetCreateSourceHash() => _$boredSuggestionHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(this, pointer);

  @override
  BoredSuggestionProvider $copyWithCreate(
    FutureOr<String> Function(
      Ref ref,
    ) create,
  ) {
    return BoredSuggestionProvider._(create: create);
  }

  @override
  FutureOr<String> create(Ref ref) {
    final _$cb = _createCb ?? boredSuggestion;
    return _$cb(ref);
  }
}

String _$boredSuggestionHash() => r'ea7579b20dd2a5f45fd9d9ea09fcbd3608330d24';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
