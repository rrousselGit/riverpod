import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'detail.dart';

part 'search.g.dart';
part 'search.freezed.dart';

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

const packagesPackageSize = 100;
const searchPageSize = 10;

// TODO hot-reload handle provider type change
// TODO hot-reload handle provider response type change
// TODO hot-reload handle provider -> family
// TODO hot-reload handle family adding parameters
// TODO found "Future already completed error" after adding family parameter

const userToken =
    'Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjE3MjdiNmI0OTQwMmI5Y2Y5NWJlNGU4ZmQzOGFhN2U3YzExNjQ0YjEiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJhY2NvdW50cy5nb29nbGUuY29tIiwiYXpwIjoiODE4MzY4ODU1MTA4LWU4c2thb3BtNWloNW5iYjgydmhoNjZrN2Z0NW83ZG4zLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwiYXVkIjoiODE4MzY4ODU1MTA4LWU4c2thb3BtNWloNW5iYjgydmhoNjZrN2Z0NW83ZG4zLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTA0MjM3Mzc5ODQ2Mzc0OTAzNjIxIiwiZW1haWwiOiJkYXJreTEyc0BnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiYXRfaGFzaCI6IjNkNElnVmUyVzZkdWhmU1pHUWRsVnciLCJuYW1lIjoiUmVtaSBSb3Vzc2VsZXQiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EtL0FGZFp1Y3BzQjhUdUtoTHhZeFdVLWQ1T2FGUVBIX3gtRFFJNnJuVV96cjVDUXc9czk2LWMiLCJnaXZlbl9uYW1lIjoiUmVtaSIsImZhbWlseV9uYW1lIjoiUm91c3NlbGV0IiwibG9jYWxlIjoiZnIiLCJpYXQiOjE2NjEwMDg5MjQsImV4cCI6MTY2MTAxMjUyNCwianRpIjoiNTJiOTAyNGM1MTcyYmU2NjMxOWQ5ODlmN2JhNzQyYzljNmIzZWVkOCJ9.JK4wwIAuA591fHbBiYy_N7xv--x9lSmB8eWk43mKkPQpWZZyQheG2-z2Y48t1k47MFdvN-ld83TCK827D9eEjDHWaYBY_S3PulNxwKKp2rbjxrerVQdi-fJ6K8pSOG5ksv2-oekk1JVY7FRNktkvQA49_N8yAEmzi5qbJugaFVxV32o3fqRbgUhpA23bvNnzP2Bt9ZwhmuA3YNjskjac2J8zxixsY4ffbq_gdU_Je_UgNJZUAv_WAMOf4fqg118QbHndjZpiAeNmTy9bOeaI-6_1DG4wySXO0TsVXU5c6N6itP76E0q0nLbaZ9d_OrfyMzFy573wmEUIgfCjWfxISw';

@riverpod
Future<List<Package>> fetchPackages(
  FetchPackagesRef ref, {
  required int page,
  String search = '',
}) async {
  final dio = Dio();

  if (search.isEmpty) {
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

  final uri = Uri(
    scheme: 'https',
    host: 'pub.dartlang.org',
    path: 'api/search',
    queryParameters: <String, String>{'page': '$page', 'q': search},
  );
  // Returns {packages: [{ package: string }]}
  final response = await dio.getUri<Map<String, Object?>>(uri);

  final packagesResponse = PubSearchResponse.fromJson(response.data!);

  return Future.wait([
    for (final package in packagesResponse.packages)
      ref.watch(
        FetchPackageDetailsProvider(packageName: package.package).future,
      ),
  ]);
}

class SearchPage extends HookConsumerWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    useListenable(searchController);

    return Scaffold(
      appBar: AppBar(
        title: const Text('pub.dev'),
        actions: [
          SizedBox(
            width: 200,
            child: TextField(
              controller: searchController,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          // disposes the pages previously fetched. Next read will refresh them
          ref.invalidate(FetchPackagesProvider);
          // keep showing the progress indicator until the first page is fetched
          return ref.read(
            FetchPackagesProvider(page: 0, search: searchController.text)
                .future,
          );
        },
        child: ListView.custom(
          childrenDelegate: SliverChildBuilderDelegate((context, index) {
            final pageSize = searchController.text.isEmpty
                ? packagesPackageSize
                : searchPageSize;

            final page = index ~/ pageSize + 1;
            final indexInPage = index % pageSize;
            final packageList = ref.watch(
              FetchPackagesProvider(
                page: page,
                search: searchController.text,
              ),
            );

            return packageList.when(
              error: (err, stack) => Text('Error $err'),
              loading: () => const Center(child: CircularProgressIndicator()),
              data: (packages) {
                if (indexInPage >= packages.length) return null;

                final package = packages[indexInPage];

                return ListTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(builder: (context) {
                      return PackageDetailPage(packageName: package.name);
                    }),
                  ),
                  title: Row(
                    children: [
                      Text(package.name),
                      const Spacer(),
                      Text(package.latest.version),
                    ],
                  ),
                  subtitle: package.latest.pubspec.description != null
                      ? Text(package.latest.pubspec.description!)
                      : null,
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
