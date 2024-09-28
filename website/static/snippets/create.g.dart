// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'create.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef BoredSuggestionRef = Ref<AsyncValue<String>>;

@ProviderFor(boredSuggestion)
const boredSuggestionProvider = BoredSuggestionProvider._();

final class BoredSuggestionProvider
    extends $FunctionalProvider<AsyncValue<String>, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String, BoredSuggestionRef> {
  const BoredSuggestionProvider._(
      {FutureOr<String> Function(
        BoredSuggestionRef ref,
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
    BoredSuggestionRef ref,
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
      BoredSuggestionRef ref,
    ) create,
  ) {
    return BoredSuggestionProvider._(create: create);
  }

  @override
  FutureOr<String> create(BoredSuggestionRef ref) {
    final _$cb = _createCb ?? boredSuggestion;
    return _$cb(ref);
  }
}

String _$boredSuggestionHash() => r'6cceb7a902c8fe2477eae0dff97d10644a848ea0';

// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
