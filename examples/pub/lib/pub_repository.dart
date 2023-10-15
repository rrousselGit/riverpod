import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

part 'pub_repository.freezed.dart';
part 'pub_repository.g.dart';

class PubRepository {
  PubRepository() {
    _configureDio();
  }

  static const _host = 'pub.dartlang.org';
  final dio = Dio();

  Future<List<Package>> getPackages({
    required int page,
    CancelToken? cancelToken,
  }) async {
    final uri = Uri.https(
      _host,
      'api/packages',
      <String, String>{'page': '$page'},
    );

    final response = await dio.getUri<Map<String, Object?>>(
      uri,
      cancelToken: cancelToken,
    );

    final packagesResponse = PubPackagesResponse.fromJson(response.data!);
    return packagesResponse.packages;
  }

  Future<List<SearchPackage>> searchPackages({
    required int page,
    required String search,
    CancelToken? cancelToken,
  }) async {
    final uri = Uri.https(
      _host,
      'api/search',
      <String, String>{'page': '$page', 'q': search},
    );
    // Returns {packages: [{ package: string }]}
    final response = await dio.getUri<Map<String, Object?>>(
      uri,
      cancelToken: cancelToken,
    );

    final packagesResponse = PubSearchResponse.fromJson(response.data!);
    return packagesResponse.packages;
  }

  Future<Package> getPackageDetails({
    required String packageName,
    CancelToken? cancelToken,
  }) async {
    final uri = Uri.https(_host, 'api/packages/$packageName');

    final response = await dio.getUri<Map<String, Object?>>(
      uri,
      cancelToken: cancelToken,
    );

    final packageResponse = Package.fromJson(response.data!);
    return packageResponse;
  }

  Future<PackageMetricsScore> getPackageMetrics({
    required String packageName,
    CancelToken? cancelToken,
  }) async {
    final uri = Uri.https(_host, 'api/packages/$packageName/metrics');

    final responseFuture = dio.getUri<Map<String, Object?>>(
      uri,
      cancelToken: cancelToken,
    );

    final likesUri = Uri.https(_host, 'api/packages/$packageName/likes');

    /// Although the metrics request does include the likes count, it seems that
    /// the server caches the response for a long period of time.
    /// For the same of "http polling" showcase, we're separately fetching the likes
    /// count
    final likesResponsFuture = dio.getUri<Map<String, Object?>>(
      likesUri,
      cancelToken: cancelToken,
    );

    final metricsResponse =
        PackageMetricsResponse.fromJson((await responseFuture).data!);
    return metricsResponse.score.copyWith(
      likeCount: (await likesResponsFuture).data!['likes']! as int,
    );
  }

  Future<void> like({
    required String packageName,
    CancelToken? cancelToken,
  }) async {
    final uri = Uri.https(_host, 'api/account/likes/$packageName');

    await dio.putUri<void>(
      uri,
      cancelToken: cancelToken,
      options: Options(
        headers: <String, String>{'authorization': userToken},
      ),
    );
  }

  Future<void> unlike({
    required String packageName,
    CancelToken? cancelToken,
  }) async {
    final uri = Uri.https(_host, 'api/account/likes/$packageName');

    await dio.deleteUri<void>(
      uri,
      cancelToken: cancelToken,
      options: Options(headers: <String, String>{'authorization': userToken}),
    );
  }

  Future<List<String>> getLikedPackages({CancelToken? cancelToken}) async {
    final uri = Uri.https(_host, 'api/account/likes');

    final response = await dio.getUri<Map<String, Object?>>(
      uri,
      cancelToken: cancelToken,
      options: Options(
        headers: <String, String>{'authorization': userToken},
      ),
    );

    final packageResponse = LikedPackagesResponse.fromJson(response.data!);
    return packageResponse.likedPackages.map((e) => e.package).toList();
  }

  void _configureDio() {
    if (kIsWeb) {
      dio.interceptors.add(PubProxyInterceptor());
    }
  }
}

const userToken = '';

@freezed
class PackageMetricsScore with _$PackageMetricsScore {
  factory PackageMetricsScore({
    required int grantedPoints,
    required int maxPoints,
    required int likeCount,
    required double popularityScore,
    required List<String> tags,
  }) = _PackageMetricsScore;

  factory PackageMetricsScore.fromJson(Map<String, Object?> json) =>
      _$PackageMetricsScoreFromJson(json);
}

@freezed
class PackageMetricsResponse with _$PackageMetricsResponse {
  factory PackageMetricsResponse({
    required PackageMetricsScore score,
  }) = _PackageMetricsResponse;

  factory PackageMetricsResponse.fromJson(Map<String, Object?> json) =>
      _$PackageMetricsResponseFromJson(json);
}

@freezed
class PackageDetails with _$PackageDetails {
  factory PackageDetails({
    required String version,
    required Pubspec pubspec,
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

// A custom interceptor that proxies requests to a cors-proxy server
// in order to workaround the CORS issue on web platform.
class PubProxyInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(
      options.copyWith(
        path: 'https://api.codetabs.com/v1/proxy/?quest=${options.path}',
      ),
      handler,
    );
  }
}
