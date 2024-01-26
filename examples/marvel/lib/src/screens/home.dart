import 'package:dio/dio.dart';
// ignore: undefined_hidden_name
import 'package:flutter/material.dart' hide SearchBar;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../marvel.dart';
import '../widgets/loading_image.dart';
import '../widgets/marvel_logo.dart';
import '../widgets/search_bar.dart';

part 'home.freezed.dart';

const kCharactersPageLimit = 50;

@freezed
class CharacterPagination with _$CharacterPagination {
  factory CharacterPagination({
    required int page,
    String? name,
  }) = _CharacterPagination;
}

class AbortedException implements Exception {}

final characterPages = FutureProvider.autoDispose
    .family<MarvelListCharactersResponse, CharacterPagination>(
  (ref, meta) async {
    // Cancel the page request if the UI no longer needs it before the request
    // is finished.
    // This typically happen if the user scrolls very fast
    final cancelToken = CancelToken();
    ref.onDispose(cancelToken.cancel);

    // Debouncing the request. By having this delay, it leaves the opportunity
    // for consumers to subscribe to a different `meta` parameters. In which
    // case, this request will be aborted.
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (cancelToken.isCancelled) throw AbortedException();

    final repository = ref.watch(repositoryProvider);
    final charactersResponse = await repository.fetchCharacters(
      offset: meta.page * kCharactersPageLimit,
      limit: kCharactersPageLimit,
      nameStartsWith: meta.name,
      cancelToken: cancelToken,
    );
    return charactersResponse;
  },
);

final charactersCount =
    Provider.autoDispose.family<AsyncValue<int>, String>((ref, name) {
  final meta = CharacterPagination(page: 0, name: name);

  return ref.watch(characterPages(meta)).whenData((value) => value.totalCount);
});

@freezed
class CharacterOffset with _$CharacterOffset {
  factory CharacterOffset({
    required int offset,
    @Default('') String name,
  }) = _CharacterOffset;
}

final characterAtIndex = Provider.autoDispose
    .family<AsyncValue<Character>, CharacterOffset>((ref, query) {
  final offsetInPage = query.offset % kCharactersPageLimit;

  final meta = CharacterPagination(
    page: query.offset ~/ kCharactersPageLimit,
    name: query.name,
  );

  return ref.watch(characterPages(meta)).whenData(
        (value) => value.characters[offsetInPage],
      );
});

class Home extends HookConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(charactersCount('')).when(
          loading: () => Container(
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator()),
          ),
          error: (err, stack) {
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: Center(
                child: Text(
                  switch (err) {
                    DioException() => err.message ?? '$err',
                    _ => '$err',
                  },
                ),
              ),
            );
          },
          data: (charactersCount) {
            return Scaffold(
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 200,
                    flexibleSpace: FlexibleSpaceBar(
                      title: SizedBox(
                        height: 40,
                        child: marvelLogo,
                      ),
                      centerTitle: true,
                      background: Image.asset(
                        'assets/marvel_background.jpeg',
                        fit: BoxFit.cover,
                        colorBlendMode: BlendMode.multiply,
                        color: Colors.grey.shade500,
                      ),
                      titlePadding: const EdgeInsetsDirectional.only(bottom: 8),
                    ),
                    pinned: true,
                    actions: const [
                      SearchBar(),
                    ],
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 10, left: 3, right: 3),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        childCount: charactersCount,
                        (c, index) {
                          return ProviderScope(
                            overrides: [
                              _characterIndex.overrideWithValue(index),
                            ],
                            child: const CharacterItem(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () =>
                    Navigator.pushNamed(context, '/characters/1009368'),
                label: const Text('Deep link to Iron-man'),
                icon: const Icon(Icons.link),
              ),
            );
          },
        );
  }
}

final _characterIndex = Provider<int>((ref) => throw UnimplementedError());

class CharacterItem extends HookConsumerWidget {
  const CharacterItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(_characterIndex);

    final character = ref.watch(
      characterAtIndex(CharacterOffset(offset: index)),
    );

    return character.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Text('Error $err'),
      data: (character) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/characters/${character.id}');
          },
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Hero(
                    tag: 'character-${character.id}',
                    child: LoadingImage(url: character.thumbnail.url),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(character.name),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
