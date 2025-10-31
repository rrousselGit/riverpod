// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names, require_trailing_commas

part of 'search.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fetchPackages)
final fetchPackagesProvider = FetchPackagesFamily._();

final class FetchPackagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Package>>,
          List<Package>,
          FutureOr<List<Package>>
        >
    with $FutureModifier<List<Package>>, $FutureProvider<List<Package>> {
  FetchPackagesProvider._({
    required FetchPackagesFamily super.from,
    required ({int page, String search}) super.argument,
  }) : super(
         retry: null,
         name: r'fetchPackagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fetchPackagesHash();

  @override
  String toString() {
    return r'fetchPackagesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Package>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Package>> create(Ref ref) {
    final argument = this.argument as ({int page, String search});
    return fetchPackages(ref, page: argument.page, search: argument.search);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchPackagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fetchPackagesHash() => r'b52d4beb5d9ac53769d76ccd1d81bb005c66edd5';

final class FetchPackagesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Package>>,
          ({int page, String search})
        > {
  FetchPackagesFamily._()
    : super(
        retry: null,
        name: r'fetchPackagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FetchPackagesProvider call({required int page, String search = ''}) =>
      FetchPackagesProvider._(
        argument: (page: page, search: search),
        from: this,
      );

  @override
  String toString() => r'fetchPackagesProvider';
}
