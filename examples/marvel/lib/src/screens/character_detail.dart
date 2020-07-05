import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/loading_image.dart';
import 'home.dart';

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

    final character = useProvider(characterAtIndex(
      CharacterOffset(offset: index, name: ''),
    )).data.value;
    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
      ),
      body: LoadingImage(url: character.thumbnail.url),
    );
  }
}
