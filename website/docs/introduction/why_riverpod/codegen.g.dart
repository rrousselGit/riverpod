// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: non_constant_identifier_names

part of 'codegen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

typedef FetchPackagesRef = Ref<AsyncValue<List<Package>>>;

@ProviderFor(fetchPackages)
const fetchPackagesProvider = FetchPackagesFamily._();

final class FetchPackagesProvider extends $FunctionalProvider<
        AsyncValue<List<Package>>, FutureOr<List<Package>>>
    with
        $FutureModifier<List<Package>>,
        $FutureProvider<List<Package>, FetchPackagesRef> {
  const FetchPackagesProvider._(
      {required FetchPackagesFamily super.from,
      required ({
        int page,
        String search,
      })
          super.argument,
      FutureOr<List<Package>> Function(
        FetchPackagesRef ref, {
        required int page,
        String search,
      })? create})
      : _createCb = create,
        super(
          retry: null,
          name: r'fetchPackagesProvider',
          isAutoDispose: true,
          dependencies: null,
          allTransitiveDependencies: null,
        );

  final FutureOr<List<Package>> Function(
    FetchPackagesRef ref, {
    required int page,
    String search,
  })? _createCb;

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
      $FutureProviderElement(this, pointer);

  @override
  FetchPackagesProvider $copyWithCreate(
    FutureOr<List<Package>> Function(
      FetchPackagesRef ref,
    ) create,
  ) {
    return FetchPackagesProvider._(
        argument: argument as ({
          int page,
          String search,
        }),
        from: from! as FetchPackagesFamily,
        create: (
          ref, {
          required int page,
          String search = '',
        }) =>
            create(ref));
  }

  @override
  FutureOr<List<Package>> create(FetchPackagesRef ref) {
    final _$cb = _createCb ?? fetchPackages;
    final argument = this.argument as ({
      int page,
      String search,
    });
    return _$cb(
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

final class FetchPackagesFamily extends Family {
  const FetchPackagesFamily._()
      : super(
          retry: null,
          name: r'fetchPackagesProvider',
          dependencies: null,
          allTransitiveDependencies: null,
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
  String debugGetCreateSourceHash() => _$fetchPackagesHash();

  @override
  String toString() => r'fetchPackagesProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(
    FutureOr<List<Package>> Function(
      FetchPackagesRef ref,
      ({
        int page,
        String search,
      }) args,
    ) create,
  ) {
    return $FamilyOverride(
      from: this,
      createElement: (pointer) {
        final provider = pointer.origin as FetchPackagesProvider;

        final argument = provider.argument as ({
          int page,
          String search,
        });

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(pointer);
      },
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
