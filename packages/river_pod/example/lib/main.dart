///  A pure Dart script that fetches the list of comics from https://developer.marvel.com/
///
///  The process is split into two objects:
///
///  - [Configuration], which stores the API keys of a marvel account.
///    This object is loaded asynchronously by reading a JSON file.
///  - [Repository], a utility that depends on [Configuration] to
///    connect to https://developer.marvel.com/ and request the comics.
///
///  Both [Repository] and [Configuration] are created using `river_pod`.
///
///  This showcases how to use `river_pod` without Flutter.
///  It also shows how a provider can depend on another provider asynchronously loaded.
library main;

import 'dart:convert';
import 'dart:io';

import 'package:river_pod/river_pod.dart';

import 'models.dart';

/// A Provider that reads a json file and decodes it into a [Configuration].
final configurationProvider = FutureProvider((_) async {
  final file = await File.fromUri(Uri.file('configuration.json')) //
      .readAsString();
  final map = json.decode(file) as Map<String, dynamic>;

  return Configuration.fromJson(map);
});

/// Creates a [Repository] from [configurationProvider].
///
/// This will correctly wait until the configurations are available.
final repositoryProvider = FutureProvider((context) async {
  /// Reads the configurations from [configurationProvider]. This is type-safe.
  final configs = await context.dependOn(configurationProvider).future;

  final repository = Repository(configs);
  // Releases the resources when the provider is destroyed.
  // This will stop pending HTTP requests.
  context.onDispose(repository.dispose);

  return repository;
});

Future<void> main() async {
  // Where the state of our providers will be stored.
  // Avoid making this a global variable, for testability purposes.
  // If you are using Flutter, you do not need this.
  final owner = ProviderStateOwner();

  /// Obtains the [Repository]. This will implicitly load [Configuration] too.
  final repository = await owner.dependOn(repositoryProvider).future;

  final comics = await repository.fetchComics();
  for (final comic in comics) {
    print(comic.title);
  }

  /// Disposes the providers associated to [owner].
  owner.dispose();
}
