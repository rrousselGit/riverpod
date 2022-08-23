import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'pub_repository.dart';
import 'pub_ui/appbar.dart';
import 'pub_ui/package_detail_body.dart';
import 'search.dart';

part 'detail.g.dart';

// TODO hot-reload handle provider type change
// TODO hot-reload handle provider response type change
// TODO hot-reload handle provider -> family
// TODO hot-reload handle family adding parameters
// TODO found "Future already completed error" after adding family parameter

extension CancelTokenX on Ref {
  CancelToken cancelToken() {
    final cancelToken = CancelToken();
    onDispose(cancelToken.cancel);
    return cancelToken;
  }
}

@Riverpod(cacheTime: 30 * 100)
Future<Package> fetchPackageDetails(
  FetchPackageDetailsRef ref, {
  required String packageName,
}) async {
  final cancelToken = ref.cancelToken();

  return ref
      .watch(PubRepositoryProvider)
      .getPackageDetails(packageName: packageName, cancelToken: cancelToken);
}

@riverpod
Future<List<String>> likedPackages(LikedPackagesRef ref) async {
  final cancelToken = ref.cancelToken();

  return ref
      .watch(PubRepositoryProvider)
      .getLikedPackages(cancelToken: cancelToken);
}

@riverpod
PubRepository pubRepository(PubRepositoryRef ref) => PubRepository();

/// A provider that fetches the likes count, popularity score and pub points
/// for a given package.
///
/// It also exposes utilities to like/unlike a package, assuming the user
/// is logged-in.
@Riverpod(cacheTime: 30 * 100)
class PackageMetrics extends _$PackageMetrics {
  @override
  Future<PackageMetricsScore> build({required String packageName}) async {
    final metrics = await ref
        .watch(PubRepositoryProvider)
        .getPackageMetrics(packageName: packageName);

    // Automatically refresh the package metrics page every 5 seconds
    final timer = Timer(const Duration(seconds: 5), () => ref.invalidateSelf());
    // If the request was refreshed before the 5 second timer completes,
    // cancel the timer.
    ref.onDispose(timer.cancel);

    return metrics;
  }

  Future<void> like() async {
    await ref.read(PubRepositoryProvider).like(packageName: packageName);

    /// Since the like count as change, we refresh the package metrics.
    /// We could alternatively do something like:
    // state = AsyncData(
    //   state.value!.copyWith(likeCount: state.value!.likeCount + 1),
    // );
    ref.invalidateSelf();

    // Since we liked a package, the list of liked packages should also be updated.
    // An alternative could be:
    // - convert likedPackages to a class
    // - add a like/unlike methods that updates the list of liked packages
    // - call ref.read(LikedPackagesProvider).like(packageName);
    ref.invalidate(LikedPackagesProvider);
  }

  Future<void> unlike() async {
    await ref.read(PubRepositoryProvider).unlike(packageName: packageName);

    ref.invalidateSelf();
    ref.invalidate(LikedPackagesProvider);
  }
}

/// The detail page of a package, typically reached by clicking on a package from [SearchPage].
class PackageDetailPage extends ConsumerWidget {
  const PackageDetailPage({Key? key, required this.packageName})
      : super(key: key);

  /// The name of the package that is inspected.
  final String packageName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final package =
        ref.watch(FetchPackageDetailsProvider(packageName: packageName));

    final likedPackages = ref.watch(LikedPackagesProvider);
    final isLiked = likedPackages.valueOrNull?.contains(packageName) ?? false;

    final metrics = ref.watch(
      PackageMetricsProviderProvider(packageName: packageName),
    );

    return Scaffold(
      appBar: const PubAppbar(),
      body: package.when(
        error: (err, stack) => Text('Error2 $err'),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (package) {
          return RefreshIndicator(
            onRefresh: () {
              return Future.wait([
                ref.refresh(
                  PackageMetricsProviderProvider(packageName: packageName)
                      .future,
                ),
                ref.refresh(
                  FetchPackageDetailsProvider(packageName: packageName).future,
                ),
              ]);
            },
            child: metrics.when(
              error: (err, stack) => Text('Error $err'),
              loading: () => const Center(child: CircularProgressIndicator()),
              data: (metrics) {
                return PackageDetailBodyScrollView(
                  packageName: packageName,
                  packageVersion: package.latest.version,
                  packageDescription: package.latest.pubspec.description,
                  grantedPoints: metrics.grantedPoints,
                  likeCount: metrics.likeCount,
                  maxPoints: metrics.maxPoints,
                  popularityScore: metrics.popularityScore * 100,
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final packageLikes = ref.read(
            PackageMetricsProviderProvider(packageName: packageName).notifier,
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
