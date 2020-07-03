import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'marvel.dart';

part 'main.freezed.dart';

void main() {
  runApp(
    const ProviderScope(
      // uncomment to mock the HTTP requests

      // overrides: [
      //   repositoryProvider.overrideAs(
      //     Provider(
      //       (ref) => MarvelRepository(ref, client: FakeDio(null)),
      //     ),
      //   ),
      // ],
      child: MyApp(),
    ),
  );
}

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

final nameFilter = StateProvider((ref) => 'Ab');

final totalCharactersCount = Computed((read) {
  final meta = CharacterPagination(page: 0, name: read(nameFilter).state);

  return read(characterPages(meta)).whenData((value) => value.totalCount);
});

final characterAtIndex =
    ComputedFamily<AsyncValue<Character>, int>((read, index) {
  final offsetInPage = index % kCharactersPageLimit;

  final meta = CharacterPagination(
    page: index ~/ kCharactersPageLimit,
    name: read(nameFilter).state,
  );

  return read(characterPages(meta)).whenData(
    (value) => value.characters[offsetInPage],
  );
});

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Home(),
      routes: {
        '/character': (c) => const CharacterView(),
      },
    );
  }
}

class Home extends HookWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return useProvider(totalCharactersCount).when(
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
      data: (totalCharactersCount) {
        return Scaffold(
          appBar: AppBar(title: const Text('Marvel characters')),
          body: Column(
            children: [
              const Searchbar(),
              Expanded(
                child: GridView.builder(
                  itemCount: totalCharactersCount,
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

    final character = useProvider(characterAtIndex(index));
    return GestureDetector(
      onTap: () {
        selectedCharacterIndex.read(context).state = index;
        Navigator.pushNamed(context, '/character');
      },
      child: character.when(
        loading: () => const CircularProgressIndicator(),
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

class LoadingImage extends StatelessWidget {
  const LoadingImage({
    Key key,
    @required this.url,
  }) : super(key: key);

  final String url;
  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (c, err, stack) {
        return const Center(child: Text('error'));
      },
      frameBuilder: (c, image, frame, sync) {
        if (!sync && frame == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return image;
      },
    );
  }
}

final selectedCharacterIndex = StateProvider<int>((ref) => null);

class CharacterView extends HookWidget {
  const CharacterView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final index = useProvider(selectedCharacterIndex).state;
    assert(
      index != null,
      'CharacterItem cannot be used but _characterIndex is undefined',
    );

    final character = useProvider(characterAtIndex(index));
    return Scaffold(
      appBar: AppBar(),
      body: LoadingImage(url: character.data.value.thumbnail.url),
    );
  }
}
