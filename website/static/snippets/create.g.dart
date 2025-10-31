// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'create.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(boredSuggestion)
final boredSuggestionProvider = BoredSuggestionProvider._();

final class BoredSuggestionProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  BoredSuggestionProvider._()
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
