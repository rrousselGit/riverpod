import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'detail.g.dart';
part 'detail.freezed.dart';

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

// TODO hot-reload handle provider type change
// TODO hot-reload handle provider response type change
// TODO hot-reload handle provider -> family
// TODO hot-reload handle family adding parameters
// TODO found "Future already completed error" after adding family parameter

const userToken =
    'Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjE3MjdiNmI0OTQwMmI5Y2Y5NWJlNGU4ZmQzOGFhN2U3YzExNjQ0YjEiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJhY2NvdW50cy5nb29nbGUuY29tIiwiYXpwIjoiODE4MzY4ODU1MTA4LWU4c2thb3BtNWloNW5iYjgydmhoNjZrN2Z0NW83ZG4zLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwiYXVkIjoiODE4MzY4ODU1MTA4LWU4c2thb3BtNWloNW5iYjgydmhoNjZrN2Z0NW83ZG4zLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTA0MjM3Mzc5ODQ2Mzc0OTAzNjIxIiwiZW1haWwiOiJkYXJreTEyc0BnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiYXRfaGFzaCI6IjNkNElnVmUyVzZkdWhmU1pHUWRsVnciLCJuYW1lIjoiUmVtaSBSb3Vzc2VsZXQiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EtL0FGZFp1Y3BzQjhUdUtoTHhZeFdVLWQ1T2FGUVBIX3gtRFFJNnJuVV96cjVDUXc9czk2LWMiLCJnaXZlbl9uYW1lIjoiUmVtaSIsImZhbWlseV9uYW1lIjoiUm91c3NlbGV0IiwibG9jYWxlIjoiZnIiLCJpYXQiOjE2NjEwMDg5MjQsImV4cCI6MTY2MTAxMjUyNCwianRpIjoiNTJiOTAyNGM1MTcyYmU2NjMxOWQ5ODlmN2JhNzQyYzljNmIzZWVkOCJ9.JK4wwIAuA591fHbBiYy_N7xv--x9lSmB8eWk43mKkPQpWZZyQheG2-z2Y48t1k47MFdvN-ld83TCK827D9eEjDHWaYBY_S3PulNxwKKp2rbjxrerVQdi-fJ6K8pSOG5ksv2-oekk1JVY7FRNktkvQA49_N8yAEmzi5qbJugaFVxV32o3fqRbgUhpA23bvNnzP2Bt9ZwhmuA3YNjskjac2J8zxixsY4ffbq_gdU_Je_UgNJZUAv_WAMOf4fqg118QbHndjZpiAeNmTy9bOeaI-6_1DG4wySXO0TsVXU5c6N6itP76E0q0nLbaZ9d_OrfyMzFy573wmEUIgfCjWfxISw';

@riverpod
Future<Package> fetchPackageDetails(
  FetchPackageDetailsRef ref, {
  required String packageName,
}) async {
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

@riverpod
class LikedPackages extends _$LikedPackages {
  @override
  Future<List<String>> build() async {
    final dio = Dio();
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

@riverpod
class PackageLikes extends _$PackageLikes {
  @override
  Future<int> build({required String packageName}) async {
    final dio = Dio();
    final uri = Uri(
      scheme: 'https',
      host: 'pub.dartlang.org',
      path: 'api/packages/$packageName/likes',
    );

    final response = await dio.getUri<Map<String, Object?>>(uri);
    final likesResponse = PackageLikesResponse.fromJson(response.data!);
    return likesResponse.likes;
  }

  Future<void> like() async {
    final dio = Dio();
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

    ref.invalidateSelf();
    ref.invalidate(LikedPackagesProvider);
  }

  Future<void> unlike() async {
    final dio = Dio();
    final uri = Uri(
      scheme: 'https',
      host: 'pub.dartlang.org',
      path: 'api/account/likes/$packageName',
    );

    await dio.deleteUri<void>(
      uri,
      options: Options(
        headers: <String, String>{'authorization': userToken},
      ),
    );

    ref.invalidateSelf();
    ref.invalidate(LikedPackagesProvider);
  }
}

class PackageDetailPage extends ConsumerWidget {
  const PackageDetailPage({Key? key, required this.packageName})
      : super(key: key);

  final String packageName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final package =
        ref.watch(FetchPackageDetailsProvider(packageName: packageName));

    final likedPackages = ref.watch(LikedPackagesProvider);
    final isLiked = likedPackages.valueOrNull?.contains(packageName) ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(packageName)),
      body: package.when(
        error: (err, stack) => Text('Error $err'),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (package) {
          final likes = ref.watch(
            PackageLikesProviderProvider(packageName: packageName),
          );

          return RefreshIndicator(
            onRefresh: () {
              return Future.wait([
                ref.refresh(
                  PackageLikesProviderProvider(packageName: packageName).future,
                ),
                ref.refresh(
                  FetchPackageDetailsProvider(packageName: packageName).future,
                ),
              ]);
            },
            child: ListView(
              children: [
                Text(package.name),
                Text(package.latest.pubspec.description ?? ''),
                likes.when(
                  error: (err, stack) => Text('Error $err'),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  data: (likes) => Text('Likes: $likes'),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final packageLikes = ref.read(
            PackageLikesProviderProvider(packageName: packageName).notifier,
          );

          if (isLiked) {
            packageLikes.unlike();
          } else {
            packageLikes.like();
          }
        },
        child: isLiked
            ? const Icon(Icons.favorite)
            : const Icon(Icons.favorite_border),
      ),
    );
  }
}
