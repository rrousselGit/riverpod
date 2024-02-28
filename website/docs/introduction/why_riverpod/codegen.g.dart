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
        AsyncValue<List<Package>>, FutureOr<List<Package>>, FetchPackagesRef>
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
          ProviderContainer container) =>
      $FutureProviderElement(this, container);

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

String _$fetchPackagesHash() => r'eebf7d838a57f493fffebfd2c8d8ab76d3233165';

final class FetchPackagesFamily extends Family {
  const FetchPackagesFamily._()
      : super(
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
      createElement: (container, provider) {
        provider as FetchPackagesProvider;

        final argument = provider.argument as ({
          int page,
          String search,
        });

        return provider
            .$copyWithCreate((ref) => create(ref, argument))
            .$createElement(container);
      },
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use_from_same_package, unreachable_from_main, invalid_use_of_internal_member
