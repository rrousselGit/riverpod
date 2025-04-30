// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(fetchPackages)
const fetchPackagesProvider = FetchPackagesFamily._();

final class FetchPackagesProvider extends $FunctionalProvider<
        AsyncValue<List<Package>>, FutureOr<List<Package>>>
    with $FutureModifier<List<Package>>, $FutureProvider<List<Package>> {
  const FetchPackagesProvider._(
      {required FetchPackagesFamily super.from,
      required ({
        int page,
        String search,
      })
          super.argument})
      : super(
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
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Package>> create(Ref ref) {
    final argument = this.argument as ({
      int page,
      String search,
    });
    return fetchPackages(
      ref,
      page: argument.page,
      search: argument.search,
    );
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

String _$fetchPackagesHash() => r'4b2c6ea2cd702ab0f9846ba19c945d2c43161605';

final class FetchPackagesFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<List<Package>>,
            ({
              int page,
              String search,
            })> {
  const FetchPackagesFamily._()
      : super(
          retry: null,
          name: r'fetchPackagesProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  FetchPackagesProvider call({
    required int page,
    String search = '',
  }) =>
      FetchPackagesProvider._(argument: (
        page: page,
        search: search,
      ), from: this);

  @override
  String toString() => r'fetchPackagesProvider';
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
