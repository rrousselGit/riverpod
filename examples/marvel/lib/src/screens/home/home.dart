import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../widgets/loading_image.dart';
import '../../widgets/marvel_logo.dart';
import '../../widgets/search_bar.dart';
import 'home_models.dart';
import 'home_providers.dart';

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
                child: Text('$err'),
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
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                      ),
                      delegate: SliverChildBuilderDelegate((c, index) {
                        return ProviderScope(
                          overrides: [
                            characterIndex.overrideWithValue(index),
                          ],
                          child: const CharacterItem(),
                        );
                      }),
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () => Navigator.pushNamed(context, '/characters/1009368'),
                label: const Text('Deep link to Iron-man'),
                icon: const Icon(Icons.link),
              ),
            );
          },
        );
  }
}

class CharacterItem extends HookConsumerWidget {
  const CharacterItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(characterIndex);

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
