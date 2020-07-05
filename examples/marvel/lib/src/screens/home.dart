import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../marvel.dart';
import '../widgets/loading_image.dart';
import 'character_detail.dart';

part 'home.freezed.dart';

const kCharactersPageLimit = 50;

@freezed
abstract class CharacterPagination with _$CharacterPagination {
  factory CharacterPagination({
    @required int page,
    String name,
  }) = _CharacterPagination;
}

final characterPages = AutoDisposeFutureProviderFamily<
    MarvelListCharactersReponse, CharacterPagination>(
  (ref, meta) async {
    final repository = ref.read(repositoryProvider);

    return repository.fetchCharacters(
      offset: meta.page * kCharactersPageLimit,
      limit: kCharactersPageLimit,
      nameStartsWith: meta.name,
    );
  },
);

final nameFilter = StateProvider((ref) => '');

final charactersCount = ComputedFamily<AsyncValue<int>, String>((read, name) {
  final meta = CharacterPagination(page: 0, name: name);

  return read(characterPages(meta)).whenData((value) => value.totalCount);
});

@freezed
abstract class CharacterOffset with _$CharacterOffset {
  factory CharacterOffset({
    @required int offset,
    String name,
  }) = _CharacterOffset;
}

final characterAtIndex =
    ComputedFamily<AsyncValue<Character>, CharacterOffset>((read, query) {
  final offsetInPage = query.offset % kCharactersPageLimit;

  final meta = CharacterPagination(
    page: query.offset ~/ kCharactersPageLimit,
    name: read(nameFilter).state,
  );

  return read(characterPages(meta)).whenData(
    (value) => value.characters[offsetInPage],
  );
});

class Home extends HookWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = useProvider(nameFilter).state;
    return useProvider(charactersCount(name)).when(
      loading: () => Container(
          color: Colors.white,
          child: const Center(child: CircularProgressIndicator())),
      error: (err, stack) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(
            child: Text('$err'),
          ),
        );
      },
      data: (charactersCount) {
        return Scaffold(
          appBar: AppBar(title: const Text('Marvel characters')),
          body: Column(
            children: [
              const Searchbar(),
              Expanded(
                child: GridView.builder(
                  itemCount: charactersCount,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    return ProviderScope(
                      overrides: [
                        _characterIndex.overrideAs(Provider((ref) => index)),
                      ],
                      child: const CharacterItem(),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Searchbar extends HookWidget {
  const Searchbar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filter = useProvider(nameFilter);
    final searchController = useTextEditingController(text: filter.state);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Focus(
        onFocusChange: (focused) {
          if (focused == false) {
            filter.state = searchController.text;
          }
        },
        child: TextField(
          controller: searchController,
        ),
      ),
    );
  }
}

final _characterIndex = Provider<int>((ref) => null);

class CharacterItem extends HookWidget {
  const CharacterItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final index = useProvider(_characterIndex);
    assert(
      index != null,
      'CharacterItem cannot be used but _characterIndex is undefined',
    );

    final character = useProvider(characterAtIndex(CharacterOffset(
      offset: index,
      name: useProvider(nameFilter).state,
    )));

    return GestureDetector(
      onTap: () {
        selectedCharacterIndex.read(context).state = index;
        Navigator.pushNamed(context, '/character');
      },
      child: character.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Text('Error $err'),
        data: (character) {
          return Card(
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
          );
        },
      ),
    );
  }
}
