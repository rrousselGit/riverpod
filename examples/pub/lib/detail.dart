import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'pub_repository.dart';
import 'pub_ui/appbar.dart';

part 'detail.g.dart';

// TODO hot-reload handle provider type change
// TODO hot-reload handle provider response type change
// TODO hot-reload handle provider -> family
// TODO hot-reload handle family adding parameters
// TODO found "Future already completed error" after adding family parameter

@riverpod
Future<Package> fetchPackageDetails(
  FetchPackageDetailsRef ref, {
  required String packageName,
}) async {
  return ref
      .watch(PubRepositoryProvider)
      .getPackageDetails(packageName: packageName);
}

@riverpod
Future<List<String>> likedPackages(LikedPackagesRef ref) async {
  return ref.watch(PubRepositoryProvider).getLikedPackages();
}

@riverpod
PubRepository pubRepository(PubRepositoryRef ref) => PubRepository();

@riverpod
class PackageLikes extends _$PackageLikes {
  @override
  Future<int> build({required String packageName}) {
    return ref
        .watch(PubRepositoryProvider)
        .getPackageLikesCount(packageName: packageName);
  }

  Future<void> like() async {
    await ref.read(PubRepositoryProvider).like(packageName: packageName);

    ref.invalidateSelf();
    ref.invalidate(LikedPackagesProvider);
  }

  Future<void> unlike() async {
    await ref.read(PubRepositoryProvider).unlike(packageName: packageName);

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
      appBar: const PubAppbar(),
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
