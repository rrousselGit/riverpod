// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../marvel.dart';
import '../widgets/loading_image.dart';

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
///   show the information of one specific [Character].
final selectedCharacterId = Provider<String>((ref) {
  throw UnimplementedError();
});

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
final character =
    FutureProvider.autoDispose.family<Character, String>((ref, id) async {
  // The user used a deep-link to land in the Character page, so we fetch
  // the Character individually.

  // Cancel the HTTP request if the user leaves the detail page before
  // the request completes.
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);

  final repository = ref.watch(repositoryProvider);
  final character = await repository.fetchCharacter(
    id,
    cancelToken: cancelToken,
  );

  /// Cache the Character once it was successfully obtained.
  ref.keepAlive();
  return character;
});

class CharacterView extends HookConsumerWidget {
  const CharacterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(selectedCharacterId);

    return ref.watch(character(id)).when(
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
