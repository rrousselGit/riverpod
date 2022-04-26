import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../marvel.dart';
import 'home_models.dart';

final characterPages = FutureProvider.autoDispose.family<MarvelListCharactersReponse, CharacterPagination>(
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
  // When a page is no-longer use, keep it in cache for up to 5 minutes.
  // After this point, if the list of characters is requested again, a new fetch
  // will be performed.
  cacheTime: const Duration(minutes: 5),
);

final charactersCount = Provider.autoDispose.family<AsyncValue<int>, String>((ref, name) {
  final meta = CharacterPagination(page: 0, name: name);

  return ref.watch(characterPages(meta)).whenData((value) => value.totalCount);
});

final characterIndex = Provider<int>((ref) => throw UnimplementedError());

final characterAtIndex = Provider.autoDispose.family<AsyncValue<Character>, CharacterOffset>((ref, query) {
  final offsetInPage = query.offset % kCharactersPageLimit;

  final meta = CharacterPagination(
    page: query.offset ~/ kCharactersPageLimit,
    name: query.name,
  );

  return ref.watch(characterPages(meta)).whenData(
        (value) => value.characters[offsetInPage],
      );
});
