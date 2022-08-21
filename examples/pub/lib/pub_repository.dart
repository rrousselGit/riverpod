import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pub_repository.freezed.dart';
part 'pub_repository.g.dart';

class PubRepository {
  final dio = Dio();

  Future<List<Package>> getPackages({required int page}) async {
    final uri = Uri(
      scheme: 'https',
      host: 'pub.dartlang.org',
      path: 'api/packages',
      queryParameters: <String, String>{'page': '$page'},
    );

    final response = await dio.getUri<Map<String, Object?>>(uri);

    final packagesResponse = PubPackagesResponse.fromJson(response.data!);
    return packagesResponse.packages;
  }

  Future<List<SearchPackage>> searchPackages({
    required int page,
    required String search,
  }) async {
    final uri = Uri(
      scheme: 'https',
      host: 'pub.dartlang.org',
      path: 'api/search',
      queryParameters: <String, String>{'page': '$page', 'q': search},
    );
    // Returns {packages: [{ package: string }]}
    final response = await dio.getUri<Map<String, Object?>>(uri);

    final packagesResponse = PubSearchResponse.fromJson(response.data!);
    return packagesResponse.packages;
  }

  Future<Package> getPackageDetails({required String packageName}) async {
    final dio = Dio();
    final uri = Uri(
      scheme: 'https',
      host: 'pub.dartlang.org',
      path: 'api/packages/$packageName',
    );

    final response = await dio.getUri<Map<String, Object?>>(uri);

    final packageResponse = Package.fromJson(response.data!);
    return packageResponse;
  }

  Future<int> getPackageLikesCount({required String packageName}) async {
    final uri = Uri(
      scheme: 'https',
      host: 'pub.dartlang.org',
      path: 'api/packages/$packageName/likes',
    );

    final response = await dio.getUri<Map<String, Object?>>(uri);
    final likesResponse = PackageLikesResponse.fromJson(response.data!);
    return likesResponse.likes;
  }

  Future<void> like({required String packageName}) async {
    final uri = Uri(
      scheme: 'https',
      host: 'pub.dartlang.org',
      path: 'api/account/likes/$packageName',
    );

    await dio.putUri<void>(
      uri,
      options: Options(
        headers: <String, String>{'authorization': userToken},
      ),
    );
  }

  Future<void> unlike({required String packageName}) async {
    final uri = Uri(
      scheme: 'https',
      host: 'pub.dartlang.org',
      path: 'api/account/likes/$packageName',
    );

    await dio.deleteUri<void>(
      uri,
      options: Options(headers: <String, String>{'authorization': userToken}),
    );
  }

  Future<List<String>> getLikedPackages() async {
    final uri = Uri(
      scheme: 'https',
      host: 'pub.dartlang.org',
      path: 'api/account/likes',
    );

    final response = await dio.getUri<Map<String, Object?>>(
      uri,
      options: Options(
        headers: <String, String>{'authorization': userToken},
      ),
    );

    final packageResponse = LikedPackagesResponse.fromJson(response.data!);
    return packageResponse.likedPackages.map((e) => e.package).toList();
  }
}

const userToken = '';

@freezed
class PackagePubpspec with _$PackagePubpspec {
  factory PackagePubpspec({
    required String name,
    required String? description,
    required String? homepage,
  }) = _PackagePubpspec;

  factory PackagePubpspec.fromJson(Map<String, Object?> json) =>
      _$PackagePubpspecFromJson(json);
}

@freezed
class PackageDetails with _$PackageDetails {
  factory PackageDetails({
    required String version,
    required PackagePubpspec pubspec,
  }) = _PackageDetails;

  factory PackageDetails.fromJson(Map<String, Object?> json) =>
      _$PackageDetailsFromJson(json);
}

@freezed
class Package with _$Package {
  factory Package({
    required String name,
    required PackageDetails latest,
  }) = _Package;

  factory Package.fromJson(Map<String, Object?> json) =>
      _$PackageFromJson(json);
}

@freezed
class PackageLikesResponse with _$PackageLikesResponse {
  factory PackageLikesResponse({required String package, required int likes}) =
      _PackageLikesResponse;

  factory PackageLikesResponse.fromJson(Map<String, Object?> json) =>
      _$PackageLikesResponseFromJson(json);
}

@freezed
class LikedPackage with _$LikedPackage {
  factory LikedPackage({required String package, required bool liked}) =
      _LikedPackage;

  factory LikedPackage.fromJson(Map<String, Object?> json) =>
      _$LikedPackageFromJson(json);
}

@freezed
class LikedPackagesResponse with _$LikedPackagesResponse {
  factory LikedPackagesResponse({required List<LikedPackage> likedPackages}) =
      _LikesPackagesResponse;

  factory LikedPackagesResponse.fromJson(Map<String, Object?> json) =>
      _$LikedPackagesResponseFromJson(json);
}

@freezed
class PubPackagesResponse with _$PubPackagesResponse {
  factory PubPackagesResponse({
    required List<Package> packages,
  }) = _PubPackagesResponse;

  factory PubPackagesResponse.fromJson(Map<String, Object?> json) =>
      _$PubPackagesResponseFromJson(json);
}

@freezed
class SearchPackage with _$SearchPackage {
  factory SearchPackage({required String package}) = _SearchPackage;

  factory SearchPackage.fromJson(Map<String, Object?> json) =>
      _$SearchPackageFromJson(json);
}

@freezed
class PubSearchResponse with _$PubSearchResponse {
  factory PubSearchResponse({
    required List<SearchPackage> packages,
  }) = _PubSearchResponse;

  factory PubSearchResponse.fromJson(Map<String, Object?> json) =>
      _$PubSearchResponseFromJson(json);
}
