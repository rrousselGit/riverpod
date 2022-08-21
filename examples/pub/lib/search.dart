import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'detail.dart';
import 'pub_repository.dart';

part 'search.g.dart';

const packagesPackageSize = 100;
const searchPageSize = 10;

// TODO hot-reload handle provider type change
// TODO hot-reload handle provider response type change
// TODO hot-reload handle provider -> family
// TODO hot-reload handle family adding parameters
// TODO found "Future already completed error" after adding family parameter

@riverpod
Future<List<Package>> fetchPackages(
  FetchPackagesRef ref, {
  required int page,
  String search = '',
}) async {
  if (search.isEmpty) {
    return ref.watch(PubRepositoryProvider).getPackages(page: page);
  }

  final searchedPackages = await ref
      .watch(PubRepositoryProvider)
      .searchPackages(page: page, search: search);

  return Future.wait([
    for (final package in searchedPackages)
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
