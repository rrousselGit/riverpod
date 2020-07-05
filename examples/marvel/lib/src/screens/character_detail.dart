import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../marvel.dart';
import '../widgets/loading_image.dart';
import 'home.dart' show characterPages;

/// The selected Character's ID
///
/// It is an error to use [CharacterView] without overriding this
/// provider to a non-null value.
///
/// See also:
///
/// - [MaterialApp.onGenerateRoute], in `main.dart`, which overrides
///   [selectedCharacterId] to set the ID based by parsing the route path.
///
/// - [CharacterView], which consumes this provider and [character] to
///   show the informations of one specific [Character].
final selectedCharacterId = Provider<String>((ref) => null);

/// A cache of [Character] shared between the providers [character] and [characterPages].
///
/// Its purpose is so that when navigating to a [Character]'s detail page
/// by clicking on it in the home page, this doesn't unnecesserily download
/// the [Character] informations.
///
/// See also:
/// - [character], a provider that fetches an individual [Character] if it isn't
///   inside [characterCache].
///
/// - [characterPages], the home-page provider that inserts the obtains [Character]s
///   inside [characterCache].
final characterCache = Provider((ref) => <String, Character>{});

/// A provider that individually fetches a [Character] based on its ID.
///
/// This rarely perform an HTTP request as most of the time the [Character]
/// is already pre-fetched by the home page.
///
/// The catch is: When using deep-links, a user may want to see a [Character]
/// without clicking on its item in the home page – in which case the [Character]
/// wasn't obtained yet.
/// In that situation, the provider will trigger an HTTP request to read that
/// [Character] specifically.
///
/// If the user leaves the detail page before the HTTP request completes,
/// the request is cancelled.
final character = AutoDisposeFutureProviderFamily<Character, String>(
  (ref, id) async {
    Character character;

    final cache = ref.read(characterCache);
    if (cache.containsKey(id)) {
      // The Character was already obtained in the Home page
      character = cache[id];
    } else {
      // The user used a deep-link to land in the Character page, so we fetch
      // the Character individually.

      // Cancel the HTTP request if the user leaves the detail page before
      // the request completes.
      final cancelToken = CancelToken();
      ref.onDispose(cancelToken.cancel);

      final repository = ref.read(repositoryProvider);
      character = await repository.fetchCharacter(
        id,
        cancelToken: cancelToken,
      );
    }

    /// Cache the Character once it was successfully obtained.
    ref.maintainState = true;
    return character;
  },
);

class CharacterView extends HookWidget {
  const CharacterView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = useProvider(selectedCharacterId);
    assert(
      id != null,
      'CharacterView used but selectedCharacterId is null',
    );

    return useProvider(character(id)).when(
      loading: () {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
      error: (err, stack) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
          ),
        );
      },
      data: (character) {
        return Scaffold(
          appBar: AppBar(
            title: Text(character.name),
          ),
          body: LoadingImage(url: character.thumbnail.url),
        );
      },
    );
  }
}
