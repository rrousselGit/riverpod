// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(currentItem)
final currentItemProvider = CurrentItemProvider._();

final class CurrentItemProvider
    extends $FunctionalProvider<AsyncValue<Item?>, Item?, FutureOr<Item?>>
    with $FutureModifier<Item?>, $FutureProvider<Item?> {
  CurrentItemProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentItemProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[currentItemIdProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          CurrentItemProvider.$allTransitiveDependencies0,
        ],
      );

  static final $allTransitiveDependencies0 = currentItemIdProvider;

  @override
  String debugGetCreateSourceHash() => _$currentItemHash();

  @$internal
  @override
  $FutureProviderElement<Item?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Item?> create(Ref ref) {
    return currentItem(ref);
  }
}

String _$currentItemHash() => r'ebafcaae468176f01bfc9d92533fba55ee2005a8';
